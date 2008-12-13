class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.references :customer, :null_allowed => false
      t.string :name
      t.text   :description

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
