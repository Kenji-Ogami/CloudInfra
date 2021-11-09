class CreateIpAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :ip_addresses do |t|
      t.string :ip_addr
      t.integer :instance_id

      t.timestamps
    end
  end
end
