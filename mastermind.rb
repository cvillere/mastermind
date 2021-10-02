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

  attr_accessor :num_guesses_rem :player_guess :computer_answer

  def init
    @num_guesses_rem = num_guesses_rem
    @player_guess = player_guess
    @computer_answer = computer_answer
  end

  def computer_answer
    computer_answer = []
    until computer_answer.length >= 4 do
      new_color = @@colors[rand(6)]
      if computer_answer.include?(new_color) === false
        computer_answer.push(new_color)
      end
    end
  end

  def get_player_guess
    puts 'What is your guess?(ex. red blue green purple)'
    player_guess = gets.chomp
  end

  def check_guess_format
    guess_for_mat = /[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}/
    if player_guess =~ guess_for_mat
      # execute a turn
    else
      puts 'Incorrect guess format! Please check guess & try again'
      player_guess = gets.chomp
    end
  end

  def display_guesses_rem
    puts num_guesses_rem
  end



end
