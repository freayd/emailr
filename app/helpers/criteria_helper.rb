module CriteriaHelper
  def field_options_for_select
    Criterion.fields.collect { |field| [ t("criterion.field.#{field}"), field ] }
  end
  def condition_options_for_select
    Criterion.conditions.collect { |condition| [ t("criterion.condition.#{condition}"), condition ] }
  end
end
