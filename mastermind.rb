require 'pry'
# Project to build the mastermind game for Odin Project

=begin
colors = ["red", "blue", "green", "purple", "orange", "yellow"]

-have computer generate a random list of colors
-Display number of guesses left
-prompt user for guess
-player makes a guess
-computer generates an answer
-check players guess to make sure it matches format
---split on commas
---make all letters downcase
---check against a regex expression
---if ok then continue to next step
-player's guess is added to list of guesses
-list that includes the guesses that were correct and empty spots for the guesses
that weren't is returned/shown
-display number of guesses left
-prompt user for guess
-
=end

# initial game project
class MasterMind
  @@max_guesses = 12
  @@colors = ['red', 'blue', 'green', 'purple', 'orange', 'yellow']

  attr_accessor :num_guesses_rem,

  def init
    @num_guesses_rem = 0
  end


  def gener_computer_answer
    comp = []
    until comp.length >= 4
      new_color = @@colors[rand(6)]
      comp.push(new_color)
    end
    comp
  end

  def check_guess_format
    puts "----------------------------------------------------------------------"
    puts "What is your guess?(ex. red blue green purple). Possible choices are: #{@@colors}"
    player_guess = gets.chomp
    guess_format = /[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}/
    while (player_guess =~ guess_format) == nil
      puts 'Incorrect guess format! Please check guess & try again'
      player_guess = gets.chomp.downcase
    end
    player_guess = player_guess.split(" ").to_a
    player_guess
  end

  def compare_guess_answer(player, computer)
    feedback_array = []
    player.each_with_index do |p, index|
      if player[index] == computer[index]
        feedback_array.push(p)
      else
        feedback_array.push(' ')
      end
    end
    feedback_array
  end

  def check_answer_position(first_comp, computer, player)
    feedback = first_comp
    compare_hash = create_hash(computer)
    player.each_with_index do |item, index|
      if computer.include?(item) && compare_hash[item] > 0 && feedback[index] == " "
        feedback[index] = 'wp'
        decrement_hash(compare_hash, item)
      end
    end
    puts "Your feedback: #{feedback}"
  end

  def decrement_hash(computer, key)
    if computer.key?(key) == true
      computer[key] -= 1
    end
    computer
  end

end


class ExecuteMasterMind < MasterMind

  def create_hash(computer)
    computer_hash = {}
    computer.each do |item|
      if computer_hash.key?(item) == true
        computer_hash[item] += 1
      else
        computer_hash[item] = 1
      end
    end
    computer_hash
  end

  def play_game(computer_response)
    player_guess = check_guess_format
    first_comparison = compare_guess_answer(player_guess, computer_response)
    second_comparison = check_answer_position(first_comparison, computer_response, player_guess)
  end

  def continue_game(computer_answer)
    game_play = play_game(computer_answer)
    while @@max_guesses > 1
      puts "this is max_guesses: #{@@max_guesses}"
      if game_play == computer_answer
        puts 'You have won the game!'
        exit
      else
        @@max_guesses -= 1
        puts "your number of guesses remaining equals: #{@@max_guesses}"
      end
      game_play = play_game(computer_answer) 
    end
    @@max_guesses -= 1
    if game_play != computer_answer && @@max_guesses == 0
      puts "line 127 - You Lost!"
      exit
    end
  end


end

# Next challenge is integrating the hash into play game and continue game functions
my_game = ExecuteMasterMind.new
computer_answ = my_game.gener_computer_answer
my_game.continue_game(computer_answ)



=begin
my_game = MasterMind.new
player_guess = my_game.check_guess_format
computer_answer = my_game.gener_computer_answer
first_comparison = my_game.compare_guess_answer(player_guess, computer_answer)
second_comparison = my_game.check_answer_position(first_comparison, computer_answer, player_guess)
=end

=begin
compare_guess_answer
check_answer_position
provide_feedback
=end