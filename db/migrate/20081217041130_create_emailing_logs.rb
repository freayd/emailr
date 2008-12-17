class CreateEmailingLogs < ActiveRecord::Migration
  def self.up
    create_table :emailing_logs do |t|
      t.references :visitor
      t.references :issue

      t.datetime :created_at
    end
  end

  def self.down
    drop_table :emailing_logs
  end
end
