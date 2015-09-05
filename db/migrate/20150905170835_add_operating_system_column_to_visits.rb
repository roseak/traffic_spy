class AddOperatingSystemColumnToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :operating_system_id, :integer
  end
end
