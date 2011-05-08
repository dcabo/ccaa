require "rubygems"
require "bundler/setup"

require 'sinatra/base'
require 'haml'
require 'json'

require 'app/model'

class RegionBudgetApp < Sinatra::Base
  
  # Enable serving of static files
  set :static, true
  set :public, 'public'
  
  get '/' do
    @regions = Region.all
    haml :index
  end
  
  get '/ca/:region' do
    # Fetch relevant data
    region = Region.first(:id => params[:region])
    expenses = region.expenses
    data = [[1999, -0.1], [2000, 2.9], [2001, 0.2], [2002, 0.3], [2003, 1.4], [2004, 2.7], [2005, 1.9], [2006, 2.0], [2007, 2.3], [2008, -0.7]]

    # Prepare JSON response
    content_type :json
    response = { 
      :label => region.name, 
      :data => data 
      }
    response.to_json
  end
  
end