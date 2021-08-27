class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :token, null: false
      t.boolean :expired, null: false, default: false
      t.datetime :expired_in, null: false

      t.timestamps
    end
  end
end
