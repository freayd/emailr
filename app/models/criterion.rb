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

  def to_sql_condition
    case condition
      when 'less_than'                  then [ "#{field} < ?",            value    ]
      when 'less_than_or_equal_to'      then [ "#{field} <= ?",           value    ]
      when 'equal_to'                   then [ "#{field} = ?",            value    ]
      when 'not_equal_to'               then [ "#{field} <> ?",           value    ]
      when 'greater_than_or_equal_to'   then [ "#{field} >= ?",           value    ]
      when 'greater_than'               then [ "#{field} > ?",            value    ]
      when 'matches_exactly'            then [ "#{field} = ?",            value    ]
      when 'matches_regular_expression' then [ "#{field} REGEXP ?",       value    ]
      when 'contains'                   then [ "#{field} LIKE ?",     "%#{value}%" ]
      when 'does_not_contain'           then [ "#{field} NOT LIKE ?", "%#{value}%" ]
      when 'starts_with'                then [ "#{field} LIKE ?",     "%#{value}"  ]
      when 'ends_with'                  then [ "#{field} LIKE ?",      "#{value}%" ]
    end
  end
end
