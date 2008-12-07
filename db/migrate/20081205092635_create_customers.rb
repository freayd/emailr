class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :company
      t.text   :address
      t.string :city
      t.string :postal_code
      t.string :country
      t.string :phone_number
      t.string :duns
      t.string :siret

      t.timestamps
    end

    add_column :accounts, :customer_id, :integer
  end

  def self.down
    remove_column :accounts, :customer_id

    drop_table :customers
  end
end
