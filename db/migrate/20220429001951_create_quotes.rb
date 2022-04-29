class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.text :content, null: false
      t.references :post, foreign_key: true
      t.timestamps
    end
  end
end
