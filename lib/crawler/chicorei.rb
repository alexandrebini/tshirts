module Crawler
  class Chicorei
    extend Crawler::ActMacro

    acts_as_crawler

    def stamps
      @stamps ||= { }
    end

    def source
      @source ||= Source.where(
        name: 'ChicoRei',
        url: 'http://chicorei.com',
        start_url: 'http://chicorei.com/5-camisetas',
        verification_matcher: 'UA-830657-3'
      ).first_or_create
    end

    def pages_urls(page)
      total_pages = page.css('ul.pagination li a').map{ |r| r.text.to_i }.max

      Array.new.tap do |pages|
        pages << source.start_url
        2.upto(total_pages).each do |page|
          pages << "#{ source.url }/category.php?id_category=5&pagina=#{ page }"
        end
      end
    end

    def tshirts_urls(page)
      page.css('#foto_small a.product_img_link img').map do |img|
        url = "#{ source.url }/#{ img.parent.attr(:href) }"
        stamp_url = URI.extract(img.parent.css('span').to_s, ['http', 'https']).
          first.gsub(/\(|\)/, '').gsub('-Capa', '-large')
        puts stamp_url
        stamps[url] = stamp_url
        url
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
      page.css('.titulo_int h1').text.strip
    end

    def parse_stamp(options)
      stamps[options[:url]]
    end

    def parse_photos(options)
      options[:page].css('#caixa_produto2 a').map do |a|
        a.attr(:href)
      end - [stamps[options[:url]]]
    end

    def parse_price(options)
      options[:page].css('.cash').first.text.scan(/\d+/).join.to_i
    end

    def parse_female_sizes(options)
      sizes(options[:page], 'female')
    end

    def parse_male_sizes(options)
      sizes(options[:page], 'male')
    end

    private
    def sizes(page, gender)
      page.css('#caixa_escolha img').each do |img|
        case
        when gender == 'male' && img.attr(:src).match('masc_ic')
          return img.next.next.next.next.css('a.adicionar').map{ |r| r.text }
        when gender == 'female' && img.attr(:src).match('fem_ic')
          return img.next.next.next.next.css('a.adicionar').map{ |r| r.text }
        end
      end
      []
    end
  end
end