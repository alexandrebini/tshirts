class Source < ActiveRecord::Base
  extend FriendlyId

  # associations
  has_one :logo, as: :assetable, dependent: :destroy
  has_many :t_shirts

  # attributes
  friendly_id :name, use: :slugged
end