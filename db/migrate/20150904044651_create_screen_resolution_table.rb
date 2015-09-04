class CreateScreenResolutionTable < ActiveRecord::Migration
  def change
    create_table :screen_resolutions do |t|
      t.text :resolution
    end
  end
end
