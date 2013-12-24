class TShirt < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  # relationship
  belongs_to :source
  has_many :sizes
  has_many :colors
  has_many :prices
  has_one :stamp, as: :assetable, dependent: :destroy
  has_many :photos, as: :assetable, dependent: :destroy

  # validations
  validates_presence_of :title, :source_url

  # others
  def stamp_url=url
    unless stamp && stamp.source_url == url
      self.build_stamp(source_url: url)
    end
  end

  def photos_urls=urls
    urls.each do |url|
      unless photos.where(source_url: url).exists?
        photos.build(source_url: url)
      end
    end
  end
end