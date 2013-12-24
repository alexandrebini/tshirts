module Crawler
  module ActMacro
    # For use this lib you should implement the following methods:
    #
    # source():                 the source model
    # pages_urls(page):         this method receive a nokogiri page and return
    #                           a list of urls to be crawled. This is used for
    #                           listing pages.
    # tshirts_urls(page):    this method receive a nokogiri page and return
    #                           a list of tshirts urls do be crawled. This is
    #                           used for tshirts (show) pages.
    # parse_tshirt(options): this method receive a nokogiri page and the
    #                           image src url. This method must create a new tshirt.
    # parse_image(options):     this method receive a nokogiri page and the page
    #                           url. This method must return the tshirt image url.
    def acts_as_crawler(options={})
      default_options = {
        source: :source,
        pages_urls: :pages_urls,
        tshirts_urls: :tshirts_urls,
        parse_tshirt: :parse_tshirt,
        parse_image: :parse_image
      }
      class_attribute :crawler_options
      self.crawler_options = default_options.merge(options)

      include Singleton
      include InstanceMethods
      extend  ClassMethods
    end
  end
end