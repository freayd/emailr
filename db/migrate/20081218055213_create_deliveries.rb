class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.references :issue,      :null_allowed => false
      t.references :subscriber, :null_allowed => false
      t.datetime :sended_at
      t.boolean  :failure
    end
  end

  def self.down
    drop_table :deliveries
  end
end
