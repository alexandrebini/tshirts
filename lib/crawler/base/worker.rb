module Crawler
  class Worker
    def perform(asset_id)
      @asset = Asset.find(asset_id)

      unless @asset.downloading?
        download_logger "\nTShirt #{ @asset.id } is not downloading. Current status: #{ @asset.status }"
        return
      end

      @filename = File.basename URI.parse(@asset.source_url).path
      @local_image = Crawler::FileHelper.find_local_image(@filename)
      if @local_image
        @source = 'local'
        @file = File.open(@local_image)
      else
        @source = 'remote'
        @file = StringIO.new(Crawler::UrlOpener.instance.open_url @asset.source_url,
          proxy: false, min_size: 22.kilobytes, image: true, name: @asset.source.slug)
      end

      @asset.data = @file
      @asset.data_file_name = @filename
      @asset.status = 'downloaded'

      if @asset.save
        download_logger "\nTShirt #{ @asset.id } image: #{ @asset.source_url } (#{ @source })"
      else
        raise @asset.errors.full_messages.join(' ')
      end
    rescue Exception => e
      if @asset
        @asset.status = 'pending'
        @asset.save(validate: false)
        download_logger "\nError on asset #{ @asset.id }: #{ @asset.source_url } (#{ @source }). #{ e }" + e.backtrace.join("\n")
      else
        download_logger "\nError on asset #{ asset_id } (#{ @source }). #{ e }"
      end
      return false
    ensure
      @file.close rescue nil
      Crawler::FileHelper.delete_local_image(@local_image) if @local_image
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