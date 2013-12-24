require "#{ Rails.root }/lib/crawler/crawler"

namespace :crawler do
  desc 'import all tshirts'
  task start: :environment do
    [
      Thread.new{ Crawler::Goodfon.start! },
      Thread.new{ Crawler::Hdtshirts.start! },
      Thread.new{ Crawler::Interfacelift.start! }
    ].each(&:join)
  end

  desc 'start downloads'
  task download: :environment do
    jobs = 10
    puts "Starting #{ jobs } jobs..."
    TShirt.pending.random.limit(jobs).each do |tshirt|
      tshirt.download_image
    end
  end

  desc 'restart downloads'
  task restart_downloads: :environment do
    Thread.abort_on_exception = true

    reset_tshirts_attributes!

    queue = enqueue_local_tshirts

    puts "let's work..."
    puts "#{ queue[:total_downloaded] } downloaded"
    puts "#{ queue[:total] - queue[:total_downloaded] } to download"
    Rake::Task['crawler:download'].invoke
  end

  def reset_tshirts_attributes!
    # clear tshirts
    TShirt.update_all(image_file_name: nil, image_content_type: nil,
      image_file_size: nil, image_updated_at: nil, image_meta: nil,
      image_fingerprint: nil)

    # clean colors
    Color.connection.execute "TRUNCATE TABLE tshirts_colors;"
    Color.connection.execute "TRUNCATE TABLE colors;"
    Color.destroy_all
    TShirt.update_all(status: 'pending')
  end

  def move_images_to_tmp!
    tmp_dir = "#{ Rails.root }/public/system/tshirts_tmp"
    FileUtils.mkdir_p tmp_dir

    Dir["#{ Rails.root }/public/system/tshirts/**/*_original.*"].each do |file|
      FileUtils.mv file, tmp_dir
    end
  end

  def cleanup_images_dir!
    puts "Are you sure you want to delete the tshirts dir? 5 seconds to think about it..."
    sleep(5)
    FileUtils.rm_rf "#{ Rails.root }/public/system/tshirts/"
  end
end