class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  
  def initialize(word)
    word.downcase!
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  def guess(alphabet)
    
    # 알파벳이 아닌 경우
    # if alphabet.empty? 를 사용하면 안됨 왜냐면 nil이 들어올 경우 에러발생
    if alphabet == ''
      puts "your alphabet is empty, make a right guess."
      raise ArgumentError
    end
    if alphabet.nil?
      puts "there's no guess... make a guess!"
      raise ArgumentError
    end
    if !alphabet.match(/[a-zA-Z]/)
      puts "guess should be an alphabet!"
      raise ArgumentError
    end
    
    alphabet.downcase!
    # 알파벳으로 예측을 할 경우
    if @word.include? alphabet    # 맞게 예측
      if !@guesses.include?(alphabet)
        @guesses += alphabet.to_s
        return true
      end
    else                          # 틀리게 예측
      if !@wrong_guesses.include? alphabet
        @wrong_guesses += alphabet.to_s 
        return true
      end
    end
    return false
  end

  def word_with_guesses
    # 초기에는 '-'가 알파벳의 개수만큼 있어야 한다.
    guessing_word = '-' * word.length
    
    # 문자열을 split("")을 통해 array로 바꾸고 인덱스와 함께 호출
    word.split("").each_with_index do |x, index|
      if guesses.include? x
        guessing_word[index] = x
      end
    end
    return guessing_word
  end
  
  
  def check_win_or_lose
    return :win if word_with_guesses.eql?(@word)
    return :lose if wrong_guesses.length > 6
    return :play
  end


  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
