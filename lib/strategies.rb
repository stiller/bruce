module Strategies
  class Random
    attr_reader :banners

    def initialize banners
      @banners = banners
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

  class Weighted < Random
    def pick number
      pick_list = []
      banners(number).each { |banner| banner.weight.times { pick_list << banner } }
      pick_list.sample(number)
    end
  end
end
