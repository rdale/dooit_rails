class CreateVtodos < ActiveRecord::Migration
  def self.up
    create_table :vtodos do |t|
      t.text :summary
      t.string :subject

      t.timestamps
    end
  end

  def self.down
    drop_table :vtodos
  end
end
