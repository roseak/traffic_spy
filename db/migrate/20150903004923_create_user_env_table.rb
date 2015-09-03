class CreateUserEnvTable < ActiveRecord::Migration
  def change
    create_table :user_envs do |t|
      t.text :user_agent
      t.text :resolution_width
      t.text :resolution_height
      t.text :ip
    end
  end
end
