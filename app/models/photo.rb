class Photo < Asset
  has_attached_file :data,
    path: ':rails_root/public/system/photos/:id_partition/:fingerprint/:basename_:style.:extension',
    url: 'system/photos/:id_partition/:fingerprint/:basename_:style.:extension'

  validates_attachment_presence :data
end