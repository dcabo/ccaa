require "rubygems"
require "bundler/setup"
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Region
  include DataMapper::Resource
  property :id,           String, :length => 2, :key => true
  property :name,         String, :length => 50
  
  has n, :expenses
end

class Policy
  include DataMapper::Resource
  property :id,           String, :length => 2, :key => true
  property :name,         String, :length => 50

  has n, :expenses
end

class Expense
  include DataMapper::Resource  

  property :id,           Serial, :key => true
  property :region_id,    String, :length => 2
  property :policy_id,    String, :length => 2
  property :year,         Integer
  property :amount,       Float
  
  belongs_to :policy
  belongs_to :region
end

# Convenience method, copied from Rails' active_support
class DataMapper::Collection 
  def index_by
    inject({}) do |accum, elem|
      accum[yield(elem)] = elem
      accum
    end
  end
end

DataMapper.auto_upgrade!