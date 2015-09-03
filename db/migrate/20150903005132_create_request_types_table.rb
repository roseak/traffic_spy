class CreateRequestTypesTable < ActiveRecord::Migration
  def change
    create_table :request_types do |t|
      t.text :requrest_type
    end
  end
end
