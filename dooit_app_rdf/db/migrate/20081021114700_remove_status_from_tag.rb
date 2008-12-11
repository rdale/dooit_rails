class RemoveStatusFromTag < ActiveRecord::Migration
  def self.up
     rename_column :tags, :status, :subject
  
  end

  def self.down
    rename_column :tags, :subject, :status
  end
end
