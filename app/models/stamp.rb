class Stamp < Asset
  has_attached_file :data,
    path: 'rails_root/public/system/:attachment/:fingerprint/:id/:filename',
    url: 'system/:attachment/:fingerprint/:id/:filename'

  validates_attachment_presence :data
  validates_attachment_content_type :data, content_type: 'image/png'
end