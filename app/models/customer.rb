class Customer < ActiveRecord::Base
  has_many :accounts
  has_many :subscribers
  has_many :profiles
  has_many :newsletters
  has_many :issues, :through => :newsletters
  has_many :visitors
  has_many :emailing_logs,      :finder_sql => 'SELECT distinct emailing_logs.* FROM emailing_logs '
                                               'INNER JOIN newsletters ON newsletters.customer_id = 5 '
                                               'INNER JOIN issues ON emailing_logs.issue_id = issues.id ORDER BY newsletters.id'
  has_many :emailing_link_logs, :finder_sql => 'SELECT distinct emailing_link_logs.* FROM emailing_link_logs '
                                               'INNER JOIN newsletters ON newsletters.customer_id = 5 '
                                               'INNER JOIN issues ON emailing_link_logs.issue_id = issues.id ORDER BY newsletters.id'
  has_many :tracking_logs,      :finder_sql => 'SELECT distinct tracking_logs.* FROM tracking_logs '
                                               'INNER JOIN newsletters ON newsletters.customer_id = 5 '
                                               'INNER JOIN issues ON tracking_logs.issue_id = issues.id ORDER BY newsletters.id'

  validates_uniqueness_of :company, :website
  validates_presence_of   :company, :website, :address, :city, :country, :phone_number
end
