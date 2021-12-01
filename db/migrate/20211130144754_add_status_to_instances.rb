class AddStatusToInstances < ActiveRecord::Migration[6.1]
  def change
    add_column :instances, :status, :string
    add_column :instances, :string, :string
  end
end
