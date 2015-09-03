class AddClientIdToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :client_id, :integer
  end
end
