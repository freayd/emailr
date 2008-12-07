require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  def test_should_create_customer
    assert_difference 'Customer.count' do
      customer = create_customer
      assert !customer.new_record?, "#{customer.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_company
    assert_no_difference 'Customer.count' do
      c = create_customer(:address => nil)
      assert c.errors.on(:address)
    end
  end
  def test_should_require_city
    assert_no_difference 'Customer.count' do
      c = create_customer(:city => nil)
      assert c.errors.on(:city)
    end
  end
  def test_should_require_country
    assert_no_difference 'Customer.count' do
      c = create_customer(:country => nil)
      assert c.errors.on(:country)
    end
  end
  def test_should_require_phone_number
    assert_no_difference 'Customer.count' do
      c = create_customer(:phone_number => nil)
      assert c.errors.on(:phone_number)
    end
  end

  def test_should_have_an_accounts_association
    assert_equal [ accounts(:pierre), accounts(:paul) ], customers(:debian).accounts
  end

protected
  def create_customer(options = {})
    record = Customer.new({ :company => 'My Company', :address => '1 unknown street ',
                            :city => 'nowhere', :country => 'The one', :phone_number => '+01234' }.merge(options))
    record.save
    record
  end
end
