class TShirt < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  # relationship
  belongs_to :source
  has_many :sizes
  has_many :female_sizes, -> { where gender: 'female' }, class_name: 'Size'
  has_many :male_sizes, -> { where gender: 'male' }, class_name: 'Size'
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
    urls.compact.uniq.each do |url|
      unless photos.where(source_url: url).exists?
        photos.build(source_url: url)
      end
    end
  end

  def price=value
    unless prices.last && prices.last.value == value
      self.prices.build(value: value)
    end
  end

  def female_sizes=sizes
    new_sizes = sizes.compact.uniq.map do |size|
      self.female_sizes.where(label: size.upcase).first_or_initialize
    end
    self.female_sizes.replace new_sizes
  end

  def male_sizes=sizes
    new_sizes = sizes.compact.uniq.map do |size|
      self.male_sizes.where(label: size.upcase).first_or_initialize
    end
    self.male_sizes.replace new_sizes
  end
end