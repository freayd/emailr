class Visitor < ActiveRecord::Base
  belongs_to :customer
  belongs_to :subscriber
end
