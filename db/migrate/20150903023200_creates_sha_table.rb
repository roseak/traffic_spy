class CreatesShaTable < ActiveRecord::Migration
  def change
    create_table :shas do |t|
      t.text :sha
    end
  end
end
