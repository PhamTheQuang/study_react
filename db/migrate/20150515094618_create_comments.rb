class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author, null: false
      t.string :content

      t.timestamp
    end
  end
end
