namespace :tshirts do
  desc 'status'
  task status: :environment do
    include ActionView::Helpers::NumberHelper
    sources = Source.all.sort_by{ |r| r.tshirts.downloaded.count }.reverse
    sources.each do |source|
      downloaded = "downloaded: #{ number_with_delimiter source.tshirts.downloaded.count }"
      downloading = "downloading: #{ number_with_delimiter source.tshirts.downloading.count }"
      pending = "pending: #{ number_with_delimiter source.tshirts.pending.count }"
      puts "#{ source.slug.ljust(15) } #{ downloaded.ljust(25) } #{ downloading.ljust(25) } #{ pending.ljust(25) }"
    end

    downloaded = "downloaded: #{ number_with_delimiter TShirt.downloaded.count }"
    downloading = "downloading: #{ number_with_delimiter TShirt.downloading.count }"
    pending = "pending: #{ number_with_delimiter TShirt.pending.count }"
    puts "#{ 'Total'.ljust(15) } #{ downloaded.ljust(25) } #{ downloading.ljust(25) } #{ pending.ljust(25) }"

    sleep(60)
    puts
    redo
  end

  desc 'Cleanup'
  task cleanup: :environment do
    tshirts = TShirt.downloaded
    corrupted = []
    slice_size = tshirts.count / 4 rescue 1
    tshirts.each_slice(slice_size).map do |tshirts_slice|
      Thread.new do
        tshirts_slice.each do |tshirt|
          case
          when File.exists?(tshirt.image.path) == false
            corrupted.push tshirt
          when File.extname(tshirt.image.path) == '.jpg' && system("jpeginfo -c \"#{ tshirt.image.path }\" | grep -E \"WARNING|ERROR\"")
            corrupted.push tshirt
          end
        end
      end
    end.each(&:join)

    corrupted.each do |tshirt|
      tshirt.image.destroy
      tshirt.download_image
    end

    puts "#{ corrupted.count }/#{ tshirts.count } corrupted"
  end
end