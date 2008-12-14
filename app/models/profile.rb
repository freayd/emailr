class Profile < ActiveRecord::Base
  belongs_to :customer
  has_many :criteria
  has_and_belongs_to_many :newsletters

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :customer_id

  def validate
    errors.add_to_base(I18n.t 'profile.validate.criterion_required') unless criteria.size > 0
  end

  def subscribers(options={})
    conditions = Array.new
    criteria.each do |criterion|
      sql_condition = criterion.to_sql_condition

      if conditions.empty?
        conditions << ''
      else
        conditions.first << ' AND '
      end
      conditions.first << sql_condition.first
      conditions << sql_condition.second
    end

    options[:conditions] = conditions unless conditions.empty?
    if options.delete(:paginate)
      customer.subscribers.paginate(options)
    else
      customer.subscribers.find(:all, options)
    end
  end
end
