class Source < ActiveRecord::Base
  has_one :logo, as: :assetable, dependent: :destroy
  has_many :t_shirts
end