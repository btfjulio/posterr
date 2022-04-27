class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :user, foreign_key: true
      t.references :entryable, polymorphic: true
      t.timestamps
    end

    add_index :entries, :created_at
  end
end
