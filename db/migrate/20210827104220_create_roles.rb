class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :permission, null: false, default: "user"

      t.timestamps
    end
  end
end
