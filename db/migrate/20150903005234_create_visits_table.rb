class CreateVisitsTable < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.text :requested_at
      t.text :responded_in
    end
  end
end
