require 'nokogiri'
require "FasterCSV"

def parse_html(in_path) 
  out_path = "raw/" + File.basename(in_path).gsub("html","csv")

  doc = Nokogiri::HTML(open("#{in_path}"))
  rows = (doc/"body/table[2]/tbody/tr/td[2]/table/tr")
  
  FasterCSV.open(out_path, "w") do |csv|
    rows.each {|row| csv << parse_row(row)}
  end
end

def parse_row(row)
  (row/"td").map{|e| e.content}
end


files = Dir["original/*"]
files.each{|path| parse_html(path)}