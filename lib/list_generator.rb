class ListGenerator
  def initialize gen_a, gen_b, ratio_a, ratio_b
    gcd = ratio_a.gcd(ratio_b)
    @ratio_a = ratio_a / gcd
    @ratio_b = ratio_b / gcd
    @gen_a = gen_a
    @gen_b = gen_b
  end

  def pick number
    divider = @ratio_a + @ratio_b
    result = @gen_a.pick((Float(number) / divider * @ratio_a).round)
    result + @gen_b.pick((Float(number) / divider * @ratio_b).round)
  end
end
