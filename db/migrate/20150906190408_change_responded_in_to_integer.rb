class ChangeRespondedInToInteger < ActiveRecord::Migration
  def change
    change_column :visits, :responded_in, 'integer USING CAST("responded_in" AS integer)'
  end
end
