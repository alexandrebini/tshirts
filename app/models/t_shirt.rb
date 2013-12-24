class TShirt < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  # relationship
  belongs_to :source
  has_many :sizes
  has_many :female_sizes, class_name: 'Size', through: :sizes, -> { where gender: 'female' }
  has_many :male_sizes, class_name: 'Size', through: :sizes, -> { where gender: 'male' }
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
      photos.where(source_url: url).first_or_create
    end
  end

  def price=value
    unless prices.last && prices.last.value == value
      self.prices.build(value: value)
    end
  end

  def female_sizes=sizes
    self.sizes.where(gender: 'female', "sizes.label not in (#{ sizes })").destroy_all
    new_sizes = sizes.each do |size|
      self.sizes.where(gender: 'female', label: size).first_or_initialize
    end
  end

  def male_sizes=sizes
  end
end