module Strategies
  class Banner
    attr_reader :url, :weight

    def initialize(url, weight=1)
      @url = url
      @weight = weight
    end
  end

  class RandomBanner
    attr_reader :banners

    def initialize banner_hash
      @banners = banner_hash.map { |k,v| Banner.new(k,v) }
    end

    def pick number
      banners(number).sample(number)
    end

    def banners number
      more_banners = @banners
      while more_banners.count < number do
        more_banners += @banners
      end
      more_banners
    end
  end

  class WeightedBanner < RandomBanner
    def pick number
      pick_list = []
      banners(number).each { |banner| banner.weight.times { pick_list << banner } }
      pick_list.sample(number)
    end
  end

  class ListGenerator
    def initialize gen_a, gen_b, ratio_a, ratio_b
      gcd = ratio_a.gcd(ratio_b)
      @ratio_a = ratio_a / gcd
      @ratio_b = ratio_b / gcd
      @gen_a = gen_a
      @gen_b = gen_b
    end

    def pick number
      mult = Float(number) / (@ratio_a + @ratio_b)
      result = @gen_a.pick(10).sample((mult * @ratio_a).ceil)
      result + @gen_b.pick(10).sample((mult * @ratio_b).floor)
    end
  end
end
