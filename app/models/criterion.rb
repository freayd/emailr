class Criterion < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of  :field, :condition, :value
  validates_inclusion_of :field,     :in => %w( first_name last_name gender birth age city postal_code state country )
  validates_inclusion_of :condition, :in => %w( less_than less_than_or_equal_to equal_to not_equal_to greater_than_or_equal_to greater_than )
end
