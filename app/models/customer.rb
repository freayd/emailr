class Customer < ActiveRecord::Base
  has_many :accounts
  has_many :subscribers

  validates_presence_of   :company
  validates_uniqueness_of :company
  validates_presence_of   :address, :city, :country, :phone_number
end
