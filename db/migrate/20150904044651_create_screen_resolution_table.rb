class CreateScreenResolutionTable < ActiveRecord::Migration
  def change
    create_table :resolutions do |t|
      t.text :resolution
    end
  end
end
