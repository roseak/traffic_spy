class AddWebBrowserIdColumnToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :web_browser_id, :integer
  end
end
