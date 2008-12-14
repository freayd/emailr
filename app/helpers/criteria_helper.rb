module CriteriaHelper
  def field_options_for_select
    Criterion.fields.collect { |field| [ t("criterion.field.#{field}"), field ] }
  end
  def condition_options_for_select(field)
    Criterion.conditions_for_field(field).collect { |condition| [ t("criterion.condition.#{condition}"), condition ] }
  end
end
