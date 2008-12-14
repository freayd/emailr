class Criterion < ActiveRecord::Base
  belongs_to :profile

  def self.fields
    @@fields ||= %w( first_name last_name gender birth age city postal_code state country )
  end
  def self.conditions
    @@conditions ||= %w( less_than less_than_or_equal_to equal_to not_equal_to greater_than_or_equal_to greater_than )
  end

  validates_inclusion_of :field,     :in => self.fields
  validates_inclusion_of :condition, :in => self.conditions
  validates_presence_of  :value
end
