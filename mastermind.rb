require 'pry'
# Project to build the mastermind game for Odin Project

# initial game project
class MasterMind
  @@max_guesses = 12
  @@colors = ['red', 'blue', 'green', 'purple', 'orange', 'yellow']

  attr_accessor :computer_guesses

  def init
    @computer_guesses = []
  end


  def gener_computer_answer
    comp = []
    until comp.length >= 4
      new_color = @@colors[rand(6)]
      comp.push(new_color)
    end
    comp
  end

  def start_game
    puts "Would you like to guess the correct color combination. Answer Y or N"
    determining_result = gets.chomp
    check_result = /Y{1}|N{1}/
    while (determining_result =~ check_result) == nil && determining_result.length != 1
      puts "incorrect input! Please check guess & try again. Answer Y or N"
      determining_result = gets.chomp
    end
    if determining_result == "Y"
      gener_computer_answer
    else
      check_answer_format
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

  def check_answer_format
    puts "----------------------------------------------------------------------"
    puts "Please give an answer for computer to guess.(ex. red blue green purple). Possible choices are: #{@@colors}"
    player_guess = gets.chomp
    guess_format = /[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}\s[a-zA-Z]{3,6}/
    while (player_guess =~ guess_format) == nil
      puts 'Incorrect answer format! Please check guess & try again'
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
    puts "----------------------------------------"
    puts "Your feedback: #{feedback}"
  end

  def figure_comp_wp(num_index)
    colors = ["red", "blue", "green", "purple", "orange", "yellow"]
    previous_guesses = []
    @computer_guesses.each_with_index do |item, index|
      previous_guesses.push(@computer_guesses[index][num_index])
    end
    potential_guess = colors - previous_guesses
    if potential_guess.length == 0
      comp_color_new = colors[rand(6)]
    else
      comp_color_new = potential_guess[rand(potential_guess.length)]
    end
    comp_color_new
  end

  def create_new_compguess(feedback)
    new_guess = []
    feedback.each_with_index do |item, index|
      if feedback[index] == " "
        new_guess.push(@@colors[rand(6)])
  
      elsif feedback[index] == "wp"
        new_guess.push(figure_comp_wp(index))
  
      elsif @@colors.includes?(item)
        new_guess.push(item)
      end
    end
    @computer_guesses.push(new_guess)
    new_guess
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

  #for the computer guessing
  def make_comp_guesser(player_answer)
    computer_response = gener_computer_answer
    first_comparison = compare_guess_answer(computer_response, player_answer)
    second_comparison = check_answer_position(first_comparison, player_answer, computer_response)
  end

  def make_second_compguess(player_answer, compguess)
    computer_response = create_new_compguess(compguess)
    first_comparison = compare_guess_answer(computer_response, player_answer)
    second_comparison = check_answer_position(first_comparison, player_answer, computer_response)
  end

  def compguess_game(player_answer)
    game_play = make_comp_guesser(player_answer)
    while @@max_guesses > 1
      puts "this is max_guesses: #{@@max_guesses}"
      if game_play == player_answer
        puts 'The computer has won the game!'
        exit
      else
        @@max_guesses -= 1
        puts "computer's number of guesses remaining equals: #{@@max_guesses}"
      end
      game_play = make_second_compguess(player_answer, game_play) 
    end
    @@max_guesses -= 1
    if game_play != player_answer && @@max_guesses == 0
      puts "line 127 - Computer has lost!"
      exit
    end
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

my_game = ExecuteMasterMind.new
computer_answ = my_game.gener_computer_answer
my_game.continue_game(computer_answ)


=begin
my_game = ExecuteMasterMind.new
my_game.either_or(the function to give comp_answer or player_answer & put it into
the correct function continue_game OR compguess_game)


=end
