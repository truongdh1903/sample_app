class AddLoginTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :login_token, :string
  end
end
