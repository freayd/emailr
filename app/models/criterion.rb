class Criterion < ActiveRecord::Base
  belongs_to :profile

  def self.fields
    @@fields ||= %w( first_name last_name gender birth age city postal_code state country )
  end
  def self.conditions
    @@conditions ||= %w( less_than less_than_or_equal_to equal_to not_equal_to greater_than_or_equal_to greater_than )
  end
  def self.conditions_for_field(field)
    return unless fields.include?(field)

    case Subscriber.columns_hash[field].type
      when :integer, :float, :decimal,
           :datetime, :date, :timestamp, :time
        then @@number_conditions   ||= %w( less_than less_than_or_equal_to equal_to not_equal_to greater_than_or_equal_to greater_than )
      when :text, :string
        then @@text_conditions     ||= %w( matches_exactly matches_regular_expression contains does_not_contain starts_with ends_with )
      when :binary, :boolean
        then @@boolean_conditions  ||= %w( equal_to not_equal_to )
    end
  end

  validates_inclusion_of :field, :in => self.fields
  validates_presence_of  :condition, :value

  def validate
    errors.add('condition', I18n.t('criterion.condition.invalid_for_field')) unless self.class.conditions_for_field(field).include?(condition)
  end
end
