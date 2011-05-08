#!/usr/bin/ruby

require 'open-uri'
require 'csv'
require 'app/model'

class RegionBudgetImporter
  
  def self.import(input_uri)
    STDOUT.sync = true
    
    open(input_uri).each do |line|
        values =line.parse_csv
        
        # FIXME: Skip budget data previous to 2006, different policy structure
        year = values[2].to_i
        next if year < 2006
        
        # Populate reference tables
        region = Region.first_or_create({:id => values[0]}, {:name => values[1]})
        policy = Policy.first_or_create({:id => values[3]}, {:name => values[4]})
        
        # Store expense data
        # FIXME: Storing only totals right now        
        expense = Expense.first_or_create(
          {:region => region, :policy => policy, :year => year},
          {:amount => values[14]}
        )
    end
  end
  
end
