class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.references :customer, :null_allowed => false
      t.string  :name
      t.text    :description
      t.date    :start_at
      t.date    :stop_at
      t.string  :frequency_unit
      t.integer :frequency
      t.text    :email_title
      t.text    :email_content

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
