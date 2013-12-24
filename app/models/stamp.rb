class Stamp < Asset
  has_attached_file :data,
    path: ':rails_root/public/system/stamps/:id_partition/:fingerprint/:basename_:style.:extension',
    url: 'system/stamps/:id_partition/:fingerprint/:basename_:style.:extension'

  # validations
  validates_presence_of :source_url

  # others
  def source
    assetable.source
  end
end