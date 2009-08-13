class AddResponsibleToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :responsible_id, :integer
  end

  def self.down
    remove_column :versions, :responsible_id
  end
end
