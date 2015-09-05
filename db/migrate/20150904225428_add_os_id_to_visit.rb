class AddOsIdToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :os_id, :integer
  end
end