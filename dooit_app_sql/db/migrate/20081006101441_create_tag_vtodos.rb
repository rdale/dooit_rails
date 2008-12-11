class CreateTagVtodos < ActiveRecord::Migration
  def self.up
    create_table :tag_vtodos do |t|
  	t.integer :tag_id
	t.integer :vtodo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tag_vtodos
  end
end
