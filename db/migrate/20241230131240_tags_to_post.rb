class TagsToPost < ActiveRecord::Migration[8.0]
  def change
    add_reference :tags, :post, null: false, foreign_key: true
  end
end
