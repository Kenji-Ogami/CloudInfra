class AddKeyToInstances < ActiveRecord::Migration[6.1]
  def change
    add_column :instances, :key, :string
    add_column :instances, :text, :string
  end
end
