class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def guess(letter)
    if letter == nil || letter.length != 1
      raise ArgumentError.new("Can only guess single character")
    end
    
    if !(letter =~ /[A-Za-z]/)
      raise ArgumentError.new("Guess can only be a valid english alphabet character")
    end

    if @guesses.downcase.include?(letter.downcase) || @wrong_guesses.downcase.include?(letter.downcase)
      return false
    end

    if @word.downcase.include?(letter.downcase)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    return true
  end

  def word_with_guesses
    display_word = ""
    @word.split('').each { |c| 
      if @guesses.include?(c)
        display_word += c
      else
        display_word += "-"
      end
    }
    return display_word
  end

  def check_win_or_lose
    if @word == self.word_with_guesses
      return :win
    elsif @wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
