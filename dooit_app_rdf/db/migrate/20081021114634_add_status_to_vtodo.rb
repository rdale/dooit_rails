class AddStatusToVtodo < ActiveRecord::Migration
  def self.up
    add_column :vtodos, :status, :string
  end

  def self.down
    remove_column :vtodos, :status
  end
end
