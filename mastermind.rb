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
    comp_answer = []
    until comp_answer.length >= 4
      new_color = @@colors[rand(6)]
      comp_answer.push(new_color)
    end
    comp_answer
  end

  def check_guess_format
    puts 'What is your guess?(ex. red blue green purple)'
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
        computer[index] == ' '
        feedback_array.push(p)
      else
        feedback_array.push(' ')
      end
    end
    feedback_array
  end

  def check_answer_position(first_comp, computer, player)
    feedback = first_comp
    comp_answer_copy = computer
    player_guess = player
    player_guess.each_with_index do |item, index|
      if comp_answer_copy.include?(item)
        index_val = comp_answer_copy.index(item)
        comp_answer_copy[index_val] = ' '
        if feedback[index] == ' '
          feedback[index] = 'wp'
        end
      end
    end
    p feedback
  end

  def provide_feedback(player, computer)
    if player == computer
      puts 'You have won the game'
      exit
    else
      @num_guesses_rem = @@max_guesses - 1
      p "your number of guesses remaining equals: #{@num_guesses_rem}"
    end
  end
end


class ExecuteMasterMind < MasterMind

  def get_computer_answer
    comp_answer = gener_computer_answer
  end

  def play_game(computer)
    player_guess = check_guess_format
    first_comparison = compare_guess_answer(player_guess, computer)
    second_comparison = check_answer_position(first_comparison, computer, player_guess)
  end

  def continue_game(feedback, computer_answer)
    play_game(computer_answer)
    if feedback == computer_answer
      puts 'You have won the game'
      exit
    elsif feedback != computer_answer
      @num_guesses_rem = @@max_guesses - 1
      puts "your number of guesses remaining equals: #{@num_guesses_rem}"
      play_game(computer_answer)
    elsif feedback != computer_answer && @@max_guesses = 0
      puts "You Lost!"
    end
  end
end


my_game = ExecuteMasterMind.new
computer_answ = my_game.get_computer_answer
game = my_game.play_game(computer_answ)
=begin
my_game.continue_game(game, computer_answ)
=end


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