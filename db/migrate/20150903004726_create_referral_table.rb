class CreateReferralTable < ActiveRecord::Migration
  def change
    create_table :referral do |t|
      t.text :url
    end
  end
end
