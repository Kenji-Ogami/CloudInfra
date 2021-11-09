class CreateInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :instances do |t|
      t.string :name
      t.integer :machine_id
      t.integer :cpu
      t.integer :memory
      t.integer :disk_space

      t.timestamps
    end
  end
end
