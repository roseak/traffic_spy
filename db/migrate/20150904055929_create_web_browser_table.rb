class CreateWebBrowserTable < ActiveRecord::Migration
  def change
    create_table :web_browsers do |t|
      t.text :browser
    end
  end
end
