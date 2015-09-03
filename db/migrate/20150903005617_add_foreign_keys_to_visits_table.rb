class AddForeignKeysToVisitsTable < ActiveRecord::Migration
  def change
    add_column :visits, :url_id, :integer
    add_column :visits, :referral_id, :integer
    add_column :visits, :event_id, :integer
    add_column :visits, :user_env_id, :integer
    add_column :visits, :request_type_id, :integer
  end
end
