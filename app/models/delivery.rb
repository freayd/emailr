class Delivery < ActiveRecord::Base
  belongs_to :issue
  belongs_to :subscriber

  before_create :simulate

  protected
    # Simule l'envoi du mail.
    def simulate
      return unless issue_id?

      write_attribute(:sended_at, issue.deliveries.size.minutes.from_now.to_datetime)
      write_attribute(:failure, rand > 0.85 ? 1 : 0)
    end
end
