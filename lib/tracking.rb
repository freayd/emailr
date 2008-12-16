# FIXME How to access *_url from model ?
module Tracking
  include ActionView::Helpers

  def empty_gif_content
    'R0lGODlhAQABAJEAAAAAAP///////wAAACH5BAEAAAIALAAAAAABAAEAAAICVAEAOw=='.freeze
  end

  # Traque l'ouverture d'un email à l'aide d'une image cachée.
  def email_tracker_tag(subscriber, issue)
    url = "/logger/email_opened?s=#{subscriber.id}&i=#{issue.id}"
    # url = email_opened_url(:sub => subscriber.id, :issue => issue.id)
    tag(:img, :src => url, :heigth => 0, :width => 0)
  end

  # Traque le clic sur un lien dans un email.
  def tracked_link_to(subscriber, issue, name, url)
    forward_url = "/logger/email_forward?s=#{subscriber.id}&i=#{issue.id}&u=#{url}"
    # forward_url = email_forward_url(:sub => subscriber.id, :issue => issue.id, :url => url)
    link_to(name, forward_url)
  end
end
