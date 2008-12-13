module ProfilesHelper
  def criterion_field_options
    Array.new << ['prénom',            'first_name' ] \
              << ['nom',               'last_name'  ] \
              << ['sexe',              'gender'     ] \
              << ['date de naissance', 'birth'      ] \
              << ['age',               'age'        ] \
              << ['ville',             'city'       ] \
              << ['code postal',       'postal_code'] \
              << ['état',              'state'      ] \
              << ['pays',              'country'    ]
  end
  def criterion_condition_options
    Array.new << ['inférieur à',         'less_than'               ] \
              << ['inférieur ou égal à', 'less_than_or_equal_to'   ] \
              << ['égal à',              'equal_to'                ] \
              << ['différent de',        'not_equal_to'            ] \
              << ['supérieur ou égal à', 'greater_than_or_equal_to'] \
              << ['supérieur à',         'greater_than'            ]
  end

  def criterion_field_option(field)
    criterion_field_options.each { |field_name, field_value| return field_name if field_value == field }
    field
  end
  def criterion_condition_option(condition)
    criterion_condition_options.each { |condition_name, condition_value| return condition_name if condition_value == condition }
    field
  end
end
