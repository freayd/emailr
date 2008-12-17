class AddWebsiteToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :website, :string
  end

  def self.down
    remove_column :customers, :website
  end
end
