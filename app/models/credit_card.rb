class CreditCard
  VALID_TYPES = [
    CreditCardType.new("AMEX", /^3(4|7)\d{13}$/),
    CreditCardType.new("DCCB", /^30[0-5]\d{11}$/),
    CreditCardType.new("DISC", /^6(011|5\d\d)\d{12}$/),
    CreditCardType.new("MC", /^5[1-5]\d{14}$/),
    CreditCardType.new("VISA", /^4\d{12}(\d{3})?$/)
  ]
  
  attr_reader :number, :type
  
  # def expiration
  #   "#{@expiration_month}/#{@expiration_year}"
  # end
  
  def expired?
    today = Date.today
    @expiration_year < today.year or (@expiration_year == today.year and @expiration_month < today.month)
  end
  
  def initialize(number, expiration_year, expiration_month)
    @expiration_year, @expiration_month = expiration_year, expiration_month
    @number = number.to_s
    # .detect (part of Enumerable) passes each entry in enum to block and returns the first for which block is not false. 
    # If no object matches, it will return nil
    @type = VALID_TYPES.detect { |type| type.match(@number) }
  end
  
  def valid?
    !expired? and !@type.nil?
  end
end