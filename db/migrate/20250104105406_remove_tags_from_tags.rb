class RemoveTagsFromTags < ActiveRecord::Migration[8.0]
  def change
    remove_column :tags, :tag_id
  end
end
