class Users < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :FullName
      t.string :Email
      t.string :Password
      t.string :Status
      t.string :Role
      t.datetime :LastLoginDate

      t.timestamps 
    end 
  end
end
