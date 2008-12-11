class AddDescriptionToVtodo < ActiveRecord::Migration
  def self.up
     add_column :vtodos, :description, :text
     remove_column :vtodos, :subject
  end

  def self.down
     remove_column :vtodos, :description
          add_column :vtodos, :subject
  end
end
