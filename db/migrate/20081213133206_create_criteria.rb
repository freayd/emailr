class CreateCriteria < ActiveRecord::Migration
  def self.up
    create_table :criteria do |t|
      t.references :profile, :null_allowed => false
      t.string :field
      t.string :condition
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :criteria
  end
end
