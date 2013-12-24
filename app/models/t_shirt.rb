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
  validates_presence_of :title, :source_url, :gender
end