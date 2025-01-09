class RemoveAiCorrectedContentFromPosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :posts, :ai_corrected_content, :text
  end
end
