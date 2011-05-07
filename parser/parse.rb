require 'rubygems'
require 'nokogiri'
require 'csv'

def clean_number(s)
  s.delete('.').gsub(',','.')
end

def parse_file(filename)
  doc = Nokogiri::HTML(open(filename))
  
  # First, get the metadata about the file from the first chunk of text
  doc.css('font')[0].text.strip =~ /Ejercicio (\d\d\d\d)\. +(.+)$/
  year = $1
  region = $2
  
  # ...make sure it's fine...
  if year.nil? or year.empty? or region.nil? or region.empty?
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
    puts "#{region},#{year},#{policy_id},#{policy_label},#{values.join(',')}"
  end
end

# puts "region, year, policy_id, policy_label, values*9, total"

# Parse all files in the staging folder
Dir['staging/*txt'].each {|filename| parse_file(filename)}
