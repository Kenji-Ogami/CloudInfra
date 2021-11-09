class CreateMachines < ActiveRecord::Migration[6.1]
  def change
    create_table :machines do |t|
      t.string :name
      t.string :model
      t.integer :cpu
      t.integer :memory
      t.integer :disk_space
      t.string :ip_addr

      t.timestamps
    end
  end
end
