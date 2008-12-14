module NewslettersHelper
  def frequency_unit_options_for_select
    Newsletter.frequency_unit.collect { |unit| [ t("newsletter.frequency_unit.#{unit}"), unit ] }
  end
  def profiles_for_select
    current_customer.profiles.find(:all, :order => 'name ASC').collect { |p| [ p.name, p.id ] }
  end
end
