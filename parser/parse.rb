require 'rubygems'
require 'nokogiri'
require 'csv'
require 'iconv'

def clean_number(s)
  s.delete('.').gsub(',','.')
end

def parse_file(filename)
  doc = Nokogiri::HTML(open(filename, "r:ISO-8859-1"))
  
  # I thought the CA name was a good key, but turns out it changes sligthly
  # with time. So we'll use the original id instead, part of the filename
  filename =~ /\/(\d\d)\./
  region_id = $1
  
  # First, get the metadata about the file from the first chunk of text
  title = doc.css('h1')[0]
  return if title.nil? # Some error pages
  title.text.strip =~ /EJERCICIO +(\d\d\d\d)/
  year = $1

  region_name = doc.css('h3')[0].text.strip
  
  # ...make sure it's fine...
  if year.nil? or year.empty? or region_name.nil? or region_name.empty?
    $stderr.puts "ERROR: can't read metadata for file [#{filename}]"
    return
  end

  # ...and then, process all the rows...
  doc.css('tr').each do |r|
    # ...but look only at the ones with the data
    columns = r.css('td')
    next if columns.size!=12
  
    # ...and ignore the subtotal rows
    policy_id = columns.shift.text
    # Always encoding black magic :/
    policy_label = Iconv.iconv("iso-8859-1", "utf-8", columns.shift.text).first
  
    # Extract the values from remaining columns
    values = columns.map {|c| clean_number(c.text.strip)}
  
    # And output. Note: at the moment we just care about what gets shown in the DVMI region 
    # visualization, so we ignore a bunch of stuff. We display only:
    #  - the total expense, even if we have the chapter breakdown. 
    #  - region id is enough, name not needed.
    #  - only for years after (and including) 2006
    #  - only for actual regions, ignore the total
    #  - only non-zero chapter-level data, ignore 'expense area' subtotals
    if year.to_i >= 2006 and region_id != '00' and policy_id =~ /\d\d/ and !values.last.empty?
      puts CSV::generate_line([year, region_id.to_i, policy_id, policy_label, values.last])
    end
  end
end

# puts CSV::generate_line(['year', 'region_id', 'policy_id', 'policy_label', 'total'])
puts 'Ano,Idcomu,Codigo,Funcion,Total'  # Header expected by Javascript in DVMI

# Parse all files in the staging folder
Dir['staging/*txt'].each {|filename| parse_file(filename)}
