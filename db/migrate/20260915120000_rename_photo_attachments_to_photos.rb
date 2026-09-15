class RenamePhotoAttachmentsToPhotos < ActiveRecord::Migration[8.0]
  def up
    ActiveStorage::Attachment.where(record_type: "Product", name: "photo").update_all(name: "photos")
  end

  def down
    ActiveStorage::Attachment.where(record_type: "Product", name: "photos").update_all(name: "photo")
  end
end
