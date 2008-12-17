class CreateEmailingLinkLogs < ActiveRecord::Migration
  def self.up
    create_table :emailing_link_logs do |t|
      t.references :visitor
      t.references :issue
      t.text     :forward_to
      t.datetime :logged_at

      t.datetime :created_at
    end
  end

  def self.down
    drop_table :emailing_link_logs
  end
end
