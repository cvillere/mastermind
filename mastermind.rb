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

  attr_accessor :num_guesses_rem

  def init
    @num_guesses_rem = num_guesses_rem
  end

  def gener_computer_answer
    computer_answer = []
    until computer_answer.length >= 4 do
      new_color = @@colors[rand(6)]
      computer_answer.push(new_color)
    end
    computer_answer
  end

  $comp_answer = gener_computer_answer()
  $player_guess = check_guess_format()
  


  def check_guess_format
    puts 'What is your guess?(ex. red blue green purple)'
    player_guess = gets.chomp
    guess_format = /[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}/
    while (player_guess =~ guess_format) == nil
      puts 'Incorrect guess format! Please check guess & try again'
      player_guess = gets.chomp.downcase
    end
    player_guess.split(" ")
  end



  def compare_guess_answer
    feedback_array = []
    $player_guess.each_with_index do |p, index|
      if $player_guess[index] == $comp_answer[index]
        $comp_answer[index] == " "
        feedback_array.push(p)
      else
        feedback_array.push(" ")
      end
    end
    feedback_array
  end


  def check_answer_position
    feedback = compare_guess_answer()
    comp_answer_copy = $comp_answer
    $player_guess.each_with_index do |item, index|
      if comp_answer_copy.include?(item)
        index_val = comp_answer_copy.index(item)
        comp_answer_copy[index_val] = " "
        if feedback[index] == " "
          feedback[index] = "wp"
        end
      end
    end
    feedback
  end

  def provide_feedback
    p check_answer_position
    @num_guesses_rem = @@max_guesses - 1
    p @num_guesses_rem
  end
end

class ExecuteMasterMind < MasterMind
  def play_game
    @@max_guesses.zero?
      gener_computer_answer
      check_guess_format
      compare_guess_answer
      check_answer_position
      provide_feedback
  end

end

my_game = ExecuteMasterMind.new
my_game.play_game

