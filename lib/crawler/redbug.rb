module Crawler
  class Redbug
    extend Crawler::ActMacro

    acts_as_crawler

    def source
      @source ||= Source.where(
        name: 'RedBug',
        url: 'http://http://www.redbug.com.br',
        start_url: 'http://www.redbug.com.br/c/cm',
        verification_matcher: 'UA-4515147-1'
      ).first_or_create
    end

    def pages_urls(page)
      page.css('ul.pagination').first.css('li a.crawling.pages').map do |a|
        a.attr(:href)
      end
    end

    def tshirts_urls(page)
      page.css('li.prod_item a.overlay').map do |a|
        a.attr(:href)
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
      page.css('h1.prod_title').text.strip
    end

    def parse_stamp(options)
      parse_large_image options[:page].css('li.thumb a').first
    end

    def parse_photos(options)
      options[:page].css('li.thumb a')[1..-1].map do |a|
        parse_large_image a
      end
    end

    def parse_price(options)
      options[:page].css('span.full_price').first.text.scan(/\d+/).join.to_i
    end

    def parse_female_sizes(options)
      find_size_of(options[:page], 'span.masculina')
    end

    def parse_male_sizes(options)
      find_size_of(options[:page], 'span.feminina')
    end

    private
    def parse_large_image(a)
      a.attr(:rel).match(/largeimage: '(.*)'/).to_a.last
    end

    def find_size_of(page, selector)
      page.css('#FilterSelecao').each do |filter|
        if filter.at_css(selector).present?
          return filter.css('ul li a').map { |a| a.text }
        end
      end
      []
    end
  end
end