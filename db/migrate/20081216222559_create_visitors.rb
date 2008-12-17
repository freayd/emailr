class CreateVisitors < ActiveRecord::Migration
  def self.up
    create_table :visitors do |t|
      t.references :customer,  :null_allowed => false
      t.references :subscriber
      t.string  :cookie
      t.string  :ip_address
      t.text    :user_agent
      t.integer :screen_width
      t.integer :screen_height
      t.integer :pixel_depth
      t.integer :color_depth

      t.timestamps
    end
    add_index(:visitors, :cookie, :unique => true)
  end

  def self.down
    drop_table :visitors
  end
end
