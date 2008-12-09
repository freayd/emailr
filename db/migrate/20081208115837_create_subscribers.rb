class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.references :customer, :null_allowed => :false
      t.string  :email
      t.string  :first_name
      t.string  :last_name
      t.string  :gender
      t.date    :birth
      t.integer :age
      t.text    :address
      t.string  :city
      t.string  :postal_code
      t.string  :state
      t.string  :country

      t.timestamps
    end
    add_index(:subscribers, [:customer_id, :email], :unique => true)
  end

  def self.down
    drop_table :subscribers
  end
end
