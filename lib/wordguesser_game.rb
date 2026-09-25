class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    unless letter.is_a?(String) && letter =~ /\A[a-zA-Z]\z/
      raise ArgumentError, "Invalid guess: must be a single letter"
    end

    letter = letter.downcase

    # 已经猜过（无论对错）就忽略，返回 false
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.downcase.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end

    true
  end

  def word_with_guesses
    @word.chars.map { |c| @guesses.include?(c.downcase) ? c : '-' }.join
  end

  def check_win_or_lose
    if @word.downcase.chars.uniq.all? { |c| @guesses.include?(c) }
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord.txt')
    Net::HTTP.get(uri)
  end
end