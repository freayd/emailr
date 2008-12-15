class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.references :newsletter, :null_allowed => false
      t.datetime :deliver_at
      t.boolean  :deliver, :default => false, :null_allowed => false
      t.text     :email_title
      t.text     :email_content

      t.timestamps
    end
  end

  def self.down
    drop_table :issues
  end
end
