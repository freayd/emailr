module Stats
  def deliveries_count
    @deliveries_count ||= current_customer.deliveries.count
  end
  def compute_delivery_failure_percent
    with_failure = current_customer.deliveries.count(:conditions => "failure = 't'")
    @delivery_failure_percent ||= (with_failure * 100) / deliveries_count rescue nil
  end
  def compute_readed_percent
    readed = current_customer.deliveries.count('distinct(deliveries.id)',
                                               :joins => 'INNER JOIN emailing_logs ON visitors.id            = emailing_logs.visitor_id ' +
                                                         'INNER JOIN visitors      ON visitors.subscriber_id = deliveries.subscriber_id ' +
                                                         'INNER JOIN issues AS i1  ON emailing_logs.issue_id = i1.id ' +
                                                         'INNER JOIN issues AS i2  ON deliveries.issue_id    = i1.id')
    @readed_percent ||= (readed * 100) / deliveries_count rescue nil
  end
end
