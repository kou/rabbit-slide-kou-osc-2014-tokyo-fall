require "benchmark"
require "rabbit/task/slide"

# Edit ./config.yaml to customize meta data

spec = nil
Rabbit::Task::Slide.new do |task|
  spec = task.spec
  spec.files += Dir.glob("images/**/*.*")
  # spec.files -= Dir.glob("private/**/*.*")
  spec.add_runtime_dependency("groonga", ">= 1.0.2")
end

desc "Tag #{spec.version}"
task :tag do
  sh("git", "tag", "-a", spec.version.to_s, "-m", "Publish #{spec.version}")
  sh("git", "push", "--tags")
end

namespace :benchmark do
  benchmark_dir = "benchmark"
  tmp_dir = "#{benchmark_dir}/data"
  data_dir = "#{benchmark_dir}/data"

  directory tmp_dir
  directory data_dir

  data_download_base_url =
    "https://github.com/livedoor/datasets/raw/master"
  data_tgz = "#{data_dir}/ldgourmet.tar.gz"
  file data_tgz => data_dir do
    sh("wget",
       "--output-document", data_tgz,
       "#{data_download_base_url}/#{File.basename(data_tgz)}")
  end

  ratings_csv = "#{data_dir}/ratings.csv"
  file ratings_csv => data_tgz do
    cd(data_dir) do
      sh("tar", "xvf", File.basename(data_tgz))
    end
    touch(ratings_csv) if File.exist?(ratings_csv)
  end

  n_records_list = [
    1000,
    5000,
    10000,
    100000,
    :all,
    :all_index,
    :all_index_id,
  ]

  prepared_time_stamp = "#{tmp_dir}/prepared.time_stamp"
  initialize_database_sql = "#{benchmark_dir}/initialize-database.sql"
  convert_ratings_to_sql = "#{benchmark_dir}/convert-ratings-to-sql.rb"
  prepare_files = [
    tmp_dir,
    ratings_csv,
    initialize_database_sql,
    convert_ratings_to_sql,
  ]
  file prepared_time_stamp => prepare_files do
    sh("mysql -u root < #{initialize_database_sql}")
    n_records_list.each do |n_records|
      if n_records.is_a?(Symbol)
        read_command = "cat"
      else
        read_command = "head -#{n_records + 1}"
      end
      sh("#{read_command} #{ratings_csv} | " +
         "#{convert_ratings_to_sql} ratings_#{n_records} | " +
         "mysql -u root full_text_search")
    end
    touch(prepared_time_stamp)
  end

  desc "Run benchmark"
  task :run => prepared_time_stamp do
    queries = [
      [:and, "ラーメン"],
      [:and, "ラーメン", "焼き肉"],
      [:or, "ラーメン", "焼き肉"],
    ]
    queries.each do |query|
      operator, *keywords = query
      n_records_list.each do |n_records|
        if n_records == :all_index or n_records == :all_index_id
          keywords_in_boolean_mode = keywords.collect do |keyword|
            if operator == :and
              "+#{keyword}"
            else
              keyword
            end
          end
          boolean_mode_query = keywords_in_boolean_mode.join(" ")
          condition =
            "MATCH (comment) " +
            "AGAINST (\"#{boolean_mode_query}\" IN BOOLEAN MODE)"
        else
          conditions = keywords.collect do |keyword|
            "#{comment} LIKE \"%#{keyword}%\""
          end
          condition = conditions.join(" #{operator.to_s.upcase} ")
        end
        table_name = "ratings_#{n_records}"

        sql = <<-SQL
SELECT AVG(CHAR_LENGTH(comment)) AS average,
       MIN(CHAR_LENGTH(comment)) as min,
       MAX(CHAR_LENGTH(comment)) as max
  FROM #{table_name};
        SQL
        sh("mysql -u root full_text_search -e '#{sql}'")

        sql = <<-SQL
SET SESSION query_cache_type = OFF;
SELECT COUNT(*) FROM #{table_name} WHERE #{condition};
        SQL
        elapsed = Benchmark.measure do
          sh("mysql -u root full_text_search -e '#{sql}'")
        end
        puts("#{n_records}: #{elapsed}")
        $stdout.flush
      end
    end
  end
end
