class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.string :name, unique: true, null: false
      t.text :content
      t.text :content_raw
      t.references :parent_page

      t.timestamps
    end
  end
end
