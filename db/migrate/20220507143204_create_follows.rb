class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.references :follower, index: true, foreign_key: {to_table: :users}
      t.references :following, index: true, foreign_key: {to_table: :users}
      t.timestamps
    end

    add_index :follows, [:following_id, :follower_id], unique: true
  end
end
