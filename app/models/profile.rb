class Profile < ActiveRecord::Base
  belongs_to :customer
  has_many :criteria

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :customer_id

  def validate
    errors.add_to_base(I18n.t 'profile.validate.criterion_required') unless criteria.size > 0
  end

  def subscribers
    conditions = [ '' ]
    criteria.each do |criterion|
      sql_condition = criterion.to_sql_condition

      conditions.first << ' AND ' unless conditions.first.blank?
      conditions.first << sql_condition.first
      conditions << sql_condition.second
    end
    customer.subscribers.find(:all, :conditions => conditions)
  end
end
