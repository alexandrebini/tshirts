class Asset < ActiveRecord::Base
  belongs_to :assetable, polymorphic: true

  # callbacks
  after_create :download_image
  after_save :analyse_colors

  # others
  def download_image
    self.status = 'downloading'
    self.save(validate: false)
    worker.perform_async(id) if source_url
  end

  def downloading?
    status == 'downloading'
  end

  def pending?
    status == 'pending'
  end

  private
  def worker
    Crawler.const_get("#{ assetable.source.name.downcase.titleize }::Worker")
  end

  def analyse_colors
    assetable.colors.destroy_all
    return unless data.present? && File.exists?(data.path)

    colors = Miro::DominantColors.new(data.path)
    percentages = colors.by_percentage
    colors.to_hex.each_with_index do |hex, i|
      begin
        color = Color.where(hex: hex, t_shirt_id: assetable.id).lock(true).first_or_initialize
        color.percentage = (percentages[i] * 100).to_i
        color.save
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end
  end
end