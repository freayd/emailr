require 'csv'

class Subscriber < ActiveRecord::Base
  belongs_to :customer
  has_many :deliveries
  has_many :issues, :through => :deliveries

  validates_presence_of   :identifier
  validates_uniqueness_of :identifier, :scope => :customer_id
  validates_uniqueness_of :email,      :scope => :customer_id
  validates_inclusion_of  :gender, :in => %w( male female ), :allow_nil => true, :message => 'is not male or female'

  def self.authorized_attr_on_import
    @@attr_on_import ||= [ 'identifier', 'email', 'first_name', 'last_name',
                           'gender', 'birth', 'age', 'address', 'city',
                           'postal_code', 'state', 'country' ]
  end

  # Importe les données d'un fichier csv.
  # Retourne les numéros des lignes n'ayant pas pus être insérés avec les messages correspondants.
  def self.import(customer, stringio, separator=',')
    errors  = Array.new
    headers = nil
    line = 0

    CSV::Reader.parse(stringio, separator) do |row|
      line += 1
      row.collect! { |x| x.strip unless x.nil? }

      unless headers
        headers = row
        authorized_attr_on_import # Memoize...
      else
        attributes = Hash.new
        headers.each_index { |i| attributes.store(headers[i], row[i]) unless row[i].nil? || !@@attr_on_import.include?(headers[i]) }

        subscriber   = customer.subscribers.find_by_identifier(attributes['identifier'])
        subscriber ||= customer.subscribers.new
        subscriber.attributes = attributes
        subscriber.errors.each_full { |msg| errors << { :line => line, :message => msg } } unless subscriber.save
      end
    end

    errors
  end


  before_save :define_age

  def define_age
    write_attribute(:age, self.age)
  end


  def age(on=Date.today)
    return read_attribute(:age) unless birth?

    age  = on.year - birth.year
    age -= 1 if birth > on.years_ago(age)
    age
  end

  def male?
    gender == 'male'
  end
  def female?
    gender == 'female'
  end
end
