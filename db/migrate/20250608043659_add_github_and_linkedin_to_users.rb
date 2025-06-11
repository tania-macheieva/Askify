class AddGithubAndLinkedinToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :github_url, :string
    add_column :users, :linkedin_url, :string
  end
end
