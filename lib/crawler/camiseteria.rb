module Crawler
  class Camiseteria
    extend Crawler::ActMacro

    acts_as_crawler

    def source
      @source ||= Source.where(
        name: 'Camiseteria',
        url: 'http://www.camiseteria.com',
        start_url: 'http://www.camiseteria.com/javascript/Catalog.js.aspx',
        verification_matcher: 'UA-19752684-1'
      ).first_or_create
    end

    def pages_urls(page)
      [source.start_url]
    end

    def tshirts_urls(page)
      page = open(source.start_url).readlines.join.force_encoding('ASCII-8BIT')

      content = page.match(/Catalog.shirts = \[(.*)\]/).to_a.last
      content.scan(/"id":\d+/).map do |id|
        "#{ source.url }/product.aspx?pid=#{ id.scan(/\d+/).join }"
      end
    end

    def parse_tshirt(options)
      TShirt.create(
        source: source,
        source_url: options[:url],
        title: parse_title(options[:page]),
        stamp_url: parse_stamp(options),
        photos_urls: parse_photos(options),
        price: parse_price(options),
        female_sizes: parse_female_sizes(options),
        male_sizes: parse_male_sizes(options)
      )
    end

    def parse_title(page)
      page.css('h1').text.strip
    end

    def parse_stamp(options)
      path = options[:page].css('#DivImgPinterest img').first.attr(:src)
      "#{ source.url }/#{ path }"
    end

    def parse_photos(options)
      options[:page].css('body').first.attr(:onload).scan(/\d+_\d+/).map do |id|
        "#{ source.url }/images/products/camisetas/album/foto_#{ id }.jpg"
      end
    end

    def parse_price(options)
      options[:page].css('#DataListModelos span.font18pxlaranjabold').first.
        text.scan(/\d+/).join.to_i
    end

    def parse_female_sizes(options)
      options[:page].css('#sizes-of-gender-female > li > label').map do |label|
        label.text
      end
    end

    def parse_male_sizes(options)
      options[:page].css('#sizes-of-gender-male > li > label').map do |label|
        label.text
      end
    end
  end
end