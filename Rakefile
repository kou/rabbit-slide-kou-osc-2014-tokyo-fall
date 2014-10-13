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
    sh("#{convert_ratings_to_sql} #{ratings_csv} | " +
       "mysql -u root full_text_search")
    touch(prepared_time_stamp)
  end

  desc "Run benchmark"
  task :run => prepared_time_stamp do
    sql = <<-SQL
SET SESSION query_cache_type = OFF;
SELECT COUNT(*) FROM ratings WHERE comment LIKE "%ラーメン%";
    SQL
    elapsed = Benchmark.measure do
      sh("mysql -u root full_text_search -e '#{sql}'")
    end
    puts(elapsed)
  end
end
