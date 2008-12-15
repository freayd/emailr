class CreateNewslettersProfiles < ActiveRecord::Migration
  def self.up
    create_table :newsletters_profiles, :id => false do |t|
      t.references :newsletter, :null_allowed => false
      t.references :profile,    :null_allowed => false
    end
  end

  def self.down
    drop_table :newsletters_profiles
  end
end
