class Newsletter < ActiveRecord::Base
  belongs_to :customer

  def self.frequency_unit
    @@frequency_unit ||= %w( day week month )
  end
  def self.email_variables
    @@email_variables ||= %w( date time first_name last_name email birth age )
  end

  validates_presence_of  :name, :start_at, :email_content
  validates_inclusion_of :frequency_unit, :in => self.frequency_unit, :allow_nil => true


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

  # Retourne les count prochaines dates d'envoi.
  def next_deliveries(count = 3)
    deliveries = Array.new
    1.upto(count) { |nth| deliveries << next_delivery(:nth => nth) }
    deliveries.reject { |d| d.nil? }
  end
end
