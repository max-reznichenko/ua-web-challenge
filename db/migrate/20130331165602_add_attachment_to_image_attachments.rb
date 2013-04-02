class AddAttachmentToImageAttachments < ActiveRecord::Migration
  def up
    add_attachment :image_attachments, :attachment
  end

  def down
    remove_attachment :image_attachments, :attachment
  end
end
