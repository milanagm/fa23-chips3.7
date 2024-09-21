class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  attr_accessor :word, :guesses, :wrong_guesses
  # dies generiert automatisch getter und setter für die attribute

  # Get a word from remote "random word" service
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''

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

  def guess (letter)
    # ist letter ein letter?
    raise ArgumentError if letter.nil? || letter == '' || !letter.match?(/[a-zA-Z]/)

    letter = letter.downcase #to make it case-insensitive

    # Wenn Buchstabe bereits geraten, false zurückgeben
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    # neuer Buchstabe wird geraten
    if @word.include?(letter)
      # correct letter guessed
      @guesses += letter unless @guesses.include?(letter)
      return true  
    else
      # incorrect letter guessed
      @wrong_guesses += letter unless @wrong_guesses.include?(letter)
      return true  
    end
  end  

  def word_with_guesses
    displayed_word = '' 

    @word.each_char do |letter|  # buchstaben des wortes durchgehen
      if @guesses.include?(letter) #check ob geraten
        displayed_word += letter 
      else
        displayed_word += '-' # wenn nicht geraten
      end
    end

    displayed_word # Rückgabe der angeordneten Zeichenkette
  end

  def check_win_or_lose
    # alle eraten?
    if @word.chars.all? { |letter| @guesses.include?(letter) }
      return :win
    # alle 7 guesses falsch?
    elsif @wrong_guesses.length >= 7
      return :lose
    # Wenn weder gewonnen noch verloren, wird weitergespielt
    else
      return :play
    end
  end
end
