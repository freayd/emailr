module NewslettersHelper
  def frequency_unit_options_for_select
    Newsletter.frequency_unit.collect { |unit| [ t("newsletter.frequency_unit.#{unit}"), unit ] }
  end
end
