class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
