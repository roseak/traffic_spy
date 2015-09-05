class CreateOperatingSystemTable < ActiveRecord::Migration
  def change
    create_table :operating_systems do |t|
      t.text :operating_system
    end
  end
end
