module Crawler
  class Worker
    def perform(asset_id)
      @asset = Asset.find(asset_id)

      unless @asset.downloading?
        download_logger "\nTShirt #{ @asset.id } is not downloading. Current status: #{ @asset.status }"
        return
      end

      @filename = File.basename URI.parse(@asset.source_url).path
      @file = StringIO.new(Crawler::UrlOpener.instance.open_url @asset.source_url,
        proxy: false, min_size: 5.kilobytes, image: true, name: @asset.source.slug)

      @asset.data = @file
      @asset.data_file_name = @filename
      @asset.status = 'downloaded'

      if @asset.save
        download_logger "\nTShirt #{ @asset.id } image: #{ @asset.source_url }"
      else
        raise @asset.errors.full_messages.join(' ')
      end
    rescue Exception => e
      if @asset
        @asset.status = 'pending'
        @asset.save(validate: false)
        download_logger "\nError on asset #{ @asset.id }: #{ @asset.source_url }. #{ e }" + e.backtrace.join("\n")
      else
        download_logger "\nError on asset #{ asset_id }. #{ e }"
      end
      return false
    ensure
      @file.close rescue nil
    end

    def download_logger(msg)
      logger = if @asset.present?
        Logger.new("#{ Rails.root }/log/#{ @asset.source.slug }.downloads.log")
      else
        Logger.new("#{ Rails.root }/log/download_error.log")
      end
      puts msg
      logger << msg
    end
  end
end