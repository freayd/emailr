class Visitor < ActiveRecord::Base
  belongs_to :customer
  belongs_to :subscriber

  def new_cookie
    loop do
      cookie_value = SecureRandom.hex
      return cookie_value unless self.class.exists?(:cookie => cookie_value)
    end
  end
  def new_cookie!
    write_attribute(:cookie, new_cookie)
  end

end
