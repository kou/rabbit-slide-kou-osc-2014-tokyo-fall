#!/usr/bin/env ruby

require "csv"

csv = CSV.new(ARGF, :headers => true)
csv.each_slice(1000) do |rows|
  puts("INSERT INTO ratings VALUES")
  nth_row = 0
  rows.each do |row|
    puts(",") unless nth_row.zero?
    body = row["body"]
    escaped_body = body.gsub(/[\\']/) do |special_character|
      "\\#{special_character}"
    end
    print("('#{escaped_body}')")
    nth_row += 1
  end
  puts(";")
end
