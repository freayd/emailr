class Delivery < ActiveRecord::Base
  belongs_to :issue
  belongs_to :subscriber

  before_create :fill_sended_at

  protected
    # Remplissage de la date d'envoi pour tester.
    def fill_sended_at
      write_attribute(:sended_at, issue.deliveries.size.minutes.from_now.to_datetime)
    end
end
