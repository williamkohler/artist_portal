class ChangeContactsToFullName < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :first_name
    remove_column :contacts, :last_name
    add_column    :contacts, :name, :string
  end
end
