class Stamp < Asset
  has_attached_file :data,
    path: ':rails_root/public/system/:attachment/:fingerprint/:id/:filename',
    url: 'system/:attachment/:fingerprint/:id/:filename'

  # validations
  validates_presence_of :source_url

  # others
  def source
    assetable.source
  end
end