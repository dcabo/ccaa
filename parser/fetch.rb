# Fetch CCAA expense summary (functional, by chapters) using the following URL:
#   http://serviciosweb.meh.es/apps/CCAApresupuestos/aspx/DescargaFuncionalCapDC.aspx?cdcdad=xx&ano=xxxx

require 'rubygems'
require 'mechanize'

@agent = Mechanize.new

# Download data and store into staging folder
def fetch_data(region, year)
  url = "http://serviciosweb.meh.es/apps/CCAApresupuestos/aspx/DescargaFuncionalCapDC.aspx?cdcdad=#{region}&ano=#{year}"
  print "Region #{region}, Year #{year}... "
  html = @agent.get(url)
  File.open("staging/#{region}.#{year}.txt", 'w') {|f| f.write(html.content) }
  puts "OK"
end

# Get all available data for a given region
def fetch_region(region)
  begin
    2010.downto(2000).each do |year|  # Will break when one year is missing (depends on region)
      fetch_data("%02d" % region, year.to_s)
    end
  rescue Mechanize::ResponseCodeError => ex
    if ex.response_code == '404'
      puts "Not found"
    else
      puts ex.response_code
    end
  end

end

# Get all available data... 
1.upto(19).each do |region|         # 0: total, 1: Andalucía... 19: Melilla
  fetch_region(region)
end
