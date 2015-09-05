class CreateOsTable < ActiveRecord::Migration
  def change
    create_table :oss do |t|
      t.text :os
    end
  end
end
