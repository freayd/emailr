class EmailingLinkLog < ActiveRecord::Base
  belongs_to :visitor
  belongs_to :issue
end
