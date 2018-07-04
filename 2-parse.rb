require 'nokogiri'
require 'csv'

def parse_year(year) 
  doc = Nokogiri::HTML(open("original/#{year}.html"))
  rows = (doc/"body/table[2]/tr/td[2]/table/tr")
  
  CSV.open("raw/#{year}.csv", "w") do |csv|
    rows.each {|row| csv << parse_row(row)}
  end
end

def parse_row(row)
  (row/"td").map{|e| e.content}
end

(1880..2008).each{|year| parse_year(year)}
