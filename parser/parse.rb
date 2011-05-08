require 'rubygems'
require 'nokogiri'
require 'csv'

def clean_number(s)
  s.delete('.').gsub(',','.')
end

def parse_file(filename)
  doc = Nokogiri::HTML(open(filename))
  
  # I thought the CA name was a good key, but turns out it changes sligthly
  # with time. So we'll use the original id instead, part of the filename
  filename =~ /\/(\d\d)\./
  region_id = $1
  
  # First, get the metadata about the file from the first chunk of text
  doc.css('font')[0].text.strip =~ /Ejercicio (\d\d\d\d)\. +(.+)$/
  year = $1
  region_name = $2
  
  # ...make sure it's fine...
  if year.nil? or year.empty? or region_name.nil? or region_name.empty?
    $stderr.puts "ERROR: can't read metadata for file [#{filename}]"
    return
  end

  # ...and then, process all the rows...
  doc.css('tr').each do |r|
    # ...but look only at the ones with the data
    columns = r.css('td')
    next if columns.size!=11
  
    # ...and ignore the subtotal rows
    name = columns.shift
    next unless name.text.strip =~ /^(\d\d) (.+)$/
    policy_id = $1
    policy_label = $2
  
    # Extract the values from remaining columns
    values = columns.map {|c| clean_number(c.text.strip)}
  
    # And output
    puts CSV::generate_line([region_id, region_name,year,policy_id,policy_label]+values)
  end
end

# puts "region, year, policy_id, policy_label, values*9, total"

# Parse all files in the staging folder
Dir['staging/*txt'].each {|filename| parse_file(filename)}
