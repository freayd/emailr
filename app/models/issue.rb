class Issue < ActiveRecord::Base
  include Tracking

  belongs_to :newsletter
  has_many :deliveries
  has_many :addressees, :through => :deliveries, :source => :subscriber

  validates_presence_of  :deliver_at
  validates_inclusion_of :deliver, :in => [ true, false ]

  before_create :create_addressees


  def preview_content
    content_for(newsletter.subscribers.first)
  end
  def content_for(subscriber, options={})
    content = email_content
    content.gsub!(/%tracker%/,                  email_tracker_tag(subscriber, self))
    content.gsub!(/%link\|([^\|%]+)\|([^%]+)%/, tracked_link_to(subscriber, self, '\1', '\2'))
    content.gsub!(/%date%/,                     Date.today.to_s)
    content.gsub!(/%time%/,                     Time.now.to_s(:time))
    content.gsub!(/%first_name%/,               subscriber.first_name)
    content.gsub!(/%last_name%/,                subscriber.last_name)
    content.gsub!(/%email%/,                    subscriber.email)
    content.gsub!(/%birth%/,                    subscriber.birth.to_s)
    content.gsub!(/%age%/,                      subscriber.age.to_s)
    content
  end

  protected
    def create_addressees
      newsletter.subscribers.each { |s| addressees << s }
    end
end
