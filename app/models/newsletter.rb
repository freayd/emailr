class Newsletter < ActiveRecord::Base
  belongs_to :customer
  has_many :issues
  has_and_belongs_to_many :profiles
  has_many :emailing_logs,      :through => :issues
  has_many :emailing_link_logs, :through => :issues
  has_many :tracking_logs,      :through => :issues

  def self.frequency_unit
    @@frequency_unit ||= %w( day week month )
  end
  def self.email_variables
    @@email_variables ||= %w( tracker link date time first_name last_name email birth age )
  end

  validates_presence_of  :name, :start_at, :email_content
  validates_inclusion_of :frequency_unit, :in => self.frequency_unit, :allow_nil => true


  def subscribers
    return customer.subscribers if profiles.empty?

    subscribers_by_ids = Hash.new
    profiles.each do |profile|
      profile.subscribers.each do |subscriber|
        subscribers_by_ids[subscriber.id] = subscriber unless subscribers_by_ids.has_key?(subscriber.id)
      end
    end
    subscribers_by_ids.values
  end

  def periodic?
    frequency?
  end

  def daily?
    periodic? && frequency_unit == 'day'
  end
  def weekly?
    periodic? && frequency_unit == 'week'
  end
  def monthly?
    periodic? && frequency_unit == 'month'
  end

  # Retourne la date de prochain envoi.
  # Options:
  #   - :after - Recherche du prochain envoi à partir de cette date (défaut: date courante).
  #   - :nth - Recherche du nième prochain envoi (défault: 1).
  def next_delivery(options={})
    after = options[:after] || start_at || Date.today
    nth   = options[:nth]   || 1

    date =
    if daily?
      after + frequency * nth
    elsif weekly?
      after + frequency * nth * 7
    elsif monthly?
      after.months_since(frequency * nth)
    end

    return date unless stop_at? && date > stop_at
  end

  # Retourne les X prochaines dates d'envoi.
  def next_deliveries(count = 3)
    deliveries = Array.new
    1.upto(count) { |nth| deliveries << next_delivery(:nth => nth) }
    deliveries.reject { |d| d.nil? }
  end

  # Retourne le prochain envoi.
  def next_issue(options={})
    issue_from_date(next_delivery(options))
  end

  # Retourne les X prochains envois.
  def next_issues(count = 3)
    result = Array.new
    next_deliveries(count).each { |date| result << issue_from_date(date) }
    result
  end

  protected
    def issue_from_date(date)
      issue   = issues.find(:first, :conditions => [ 'deliver_at LIKE ?', "#{date.to_s(:db)}%" ])
      issue ||= issues.build(:deliver_at => date.to_datetime, :email_title => email_title, :email_content => email_content)
      issue
    end
end
