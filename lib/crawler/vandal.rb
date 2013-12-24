module Crawler
  class Vandal
    extend Crawler::ActMacro

    acts_as_crawler

    def source
      @source ||= Source.where(
        name: 'Vandal',
        url: 'http://www.vandal.com.br/',
        start_url: 'http://www.vandal.com.br/?new_products=true&ajax=1',
        verification_matcher: 'UA-24684501-1'
      ).first_or_create
    end

    def pages_urls(page)
      [@source.start_url]
    end

    def tshirts_urls(page)
      page.css('.col-md-3.col-sm-4.col-xs-6 > a').map do |a|
        "http://#{ URI.parse(source.url).host }/#{ a.attr(:href) }"
      end
    end

    def parse_tshirt(options)
      a = TShirt.new(
        source: source,
        source_url: options[:url],
        title: parse_title(options[:page]),
        stamp_url: parse_stamp(options),
        photos_urls: parse_photos(options)
      )
      puts a.save
      p a.errors
    end

    def parse_title(page)
      page.css('#product-data h1').text.strip
    end

    def parse_stamp(options)
      "http:#{ options[:page].css('#source-url').text }"
    end

    def parse_photos(options)
      options[:page].css('.carousel-inner img').map do |img|
        "http://#{ URI.parse(source.url).host }/#{ img.attr(:src) }"
      end.compact.uniq
    end
  end
end