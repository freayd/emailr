class Customer < ActiveRecord::Base
  has_many :accounts
  has_many :subscribers
  has_many :profiles
  has_many :newsletters
  has_many :issues, :through => :newsletters
  has_many :visitors
  has_many :emailing_logs,      :through => :issues
  has_many :emailing_link_logs, :through => :issues
  has_many :tracking_logs,      :through => :issues
  has_many :deliveries, :through => :issues

  validates_uniqueness_of :company, :website
  validates_presence_of   :company, :website, :address, :city, :country, :phone_number
end
