class Customer < ActiveRecord::Base
  has_many :accounts
  has_many :subscribers
  has_many :profiles
  has_many :newsletters
  has_many :issues, :through => :newsletters

  validates_presence_of   :company
  validates_uniqueness_of :company
  validates_presence_of   :website, :address, :city, :country, :phone_number
end
