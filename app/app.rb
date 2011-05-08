require "rubygems"
require "bundler/setup"

require 'sinatra/base'
require 'haml'

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
    @region = Region.first(:id => params[:region])
    @expenses = @region.expenses
    haml :region
  end
  
end