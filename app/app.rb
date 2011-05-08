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
    
    # Reorder as needed for visualization
    per_policy_data = {}
    expenses.each do |e|
      per_policy_data[e.policy_id] = [] if per_policy_data[e.policy_id].nil?
      per_policy_data[e.policy_id] << [e.year, e.amount]
    end
    
    # Prepare JSON response
    content_type :json
    response = { 
      :label => region.name, 
      :data => per_policy_data['11']  # FIXME 
      }
    response.to_json
  end
  
end