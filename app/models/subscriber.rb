class Subscriber < ActiveRecord::Base
  belongs_to :customer

  validates_inclusion_of :gender, :in => %w( male female ), :message => 'is not male or female'
end
