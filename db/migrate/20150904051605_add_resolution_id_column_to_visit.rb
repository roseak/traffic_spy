class AddResolutionIdColumnToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :resolution_id, :integer
  end
end
