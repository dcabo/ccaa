# Fetch CCAA expense summary (functional, by chapters) using the following URL:
#   http://serviciosweb.meh.es/apps/CCAApresupuestos/aspx/DescargaFuncionalCapDC.aspx?cdcdad=xx&ano=xxxx

require 'rubygems'
require 'mechanize'

@agent = Mechanize.new

# Download data and store into staging folder
def get_data(region, year)
  url = "http://serviciosweb.meh.es/apps/CCAApresupuestos/aspx/DescargaFuncionalCapDC.aspx?cdcdad=#{region}&ano=#{year}"
  print "Region #{region}, Year #{year}... "
  html = @agent.get(url)
  File.open("staging/#{region}.#{year}.txt", 'w') {|f| f.write(html.content) }
  puts "OK"
end

begin
  # Get all available data... Break when one year is missing (depends on region)
  2010.downto(2000).each do |year|
    get_data('02', year.to_s)  # TODO: Make region configurable
  end
rescue Mechanize::ResponseCodeError => ex
  if ex.response_code == '404'
    puts "Not found"
  else
    puts ex.response_code
  end
end

