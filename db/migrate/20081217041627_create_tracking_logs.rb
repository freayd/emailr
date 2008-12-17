class CreateTrackingLogs < ActiveRecord::Migration
  def self.up
    create_table :tracking_logs do |t|
      t.references :visitor
      t.references :issue
      t.text     :referer
      t.datetime :logged_at

      t.datetime :created_at
    end
  end

  def self.down
    drop_table :tracking_logs
  end
end
