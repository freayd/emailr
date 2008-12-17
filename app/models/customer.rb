class Customer < ActiveRecord::Base
  has_many :accounts
  has_many :subscribers
  has_many :profiles
  has_many :newsletters
  has_many :issues, :through => :newsletters

  validates_uniqueness_of :company, :website
  validates_presence_of   :company, :website, :address, :city, :country, :phone_number
end
