class RemovePostIdFromTags < ActiveRecord::Migration[8.0]
  def change
    remove_reference :tags, :post, null: false, foreign_key: true
  end
end
