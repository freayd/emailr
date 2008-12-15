class Issue < ActiveRecord::Base
  belongs_to :newsletter

  validates_presence_of  :deliver_at
  validates_inclusion_of :deliver, :in => [ true, false ]
end
