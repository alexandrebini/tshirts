class Logo < Asset
  has_attached_file :data,
    path: ':rails_root/public/system/logos/:id_partition/:fingerprint/:basename_:style.:extension',
    url: 'system/logos/:id_partition/:fingerprint/:basename_:style.:extension'

  validates_attachment_presence :data
end