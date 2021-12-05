# Project to build the mastermind game for Odin Project

# initial game project
class MasterMind
  @@max_guesses = 12
  @@colors = ['red', 'blue', 'green', 'purple', 'orange', 'yellow']

  attr_accessor :computer_guesses, :comp_response

  def initialize
    @computer_guesses = []
    @comp_response = []
  end


  def gener_computer_answer
    comp = []
    until comp.length >= 4
      new_color = @@colors[rand(6)]
      comp.push(new_color)
    end
    comp
  end

  def gener_computer_guess
    comp = []
    until comp.length >= 4
      new_color = @@colors[rand(6)]
      comp.push(new_color)
    end
    @computer_guesses.push(comp)
    comp
  end

  def start_game
    puts "Would you like to guess the correct color combination. Answer Y or N"
    determining_result = gets.chomp
    check_result = /Y{1}|N{1}/
    while (determining_result =~ check_result) == nil || determining_result.length != 1
      puts "incorrect input! Please check guess & try again. Answer Y or N"
      determining_result = gets.chomp
    end
    if determining_result == "Y"
      continue_game(gener_computer_answer)
    else
      compguess_game(check_answer_format)
    end
  end

  def check_guess_format
    puts "----------------------------------------------------------------------"
    puts "What is your guess?(ex. red blue green purple). Possible choices are: #{@@colors}"
    player_guess = gets.chomp
    player_guess = player_guess.split(" ").to_a
    while player_guess.length != 4
      puts 'Incorrect answer format! Please check input & try again'
      player_guess = gets.chomp.downcase
      player_guess = player_guess.split(" ").to_a
    end
    player_guess
  end

  def check_answer_format 
    puts "----------------------------------------------------------------------"
    puts "Please give an answer for computer to guess.(ex. red blue green purple). Possible choices are: #{@@colors}"
    player_guess = gets.chomp
    player_guess = player_guess.split(" ").to_a
    while player_guess.length != 4
      puts 'Incorrect answer format! Please check input & try again'
      player_guess = gets.chomp.downcase
      player_guess = player_guess.split(" ").to_a
    end
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
    @computer_guesses.push(player)
    compare_hash = create_hash(computer)
    dec_initial_hash(compare_hash, player, computer)
    player.each_with_index do |item, index|
      if computer.include?(item) && compare_hash[item] > 0 && feedback[index] == " "
        feedback[index] = 'wp'
        decrement_hash(compare_hash, item)
      end
    end
    puts "Your feedback: #{feedback}"
    feedback
  end

  def provide_new_color(num_index)
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

  def create_new_compguess(feedback, guess)
    wp_hash = {}
    feedback.each_with_index do |item, index|
      if wp_hash.key?(guess[index]) == false && feedback[index] == "wp"
        wp_hash[guess[index]] = []
        wp_hash[guess[index]].push(index)
      elsif wp_hash.key?(guess[index]) == true && feedback[index] == "wp"
        wp_hash[guess[index]].push(index)
      end
    end
    feedback.each_with_index do |item, index|
      diff_wp_color = wp_hash.select { |_key, value| value.include?(index) == false }
      if (feedback[index] == "wp" || feedback[index] == " ") && diff_wp_color.length > 0
        new_color_poss = diff_wp_color.keys
        new_color = new_color_poss[rand(new_color_poss.length)]
        feedback[index] = new_color 
        wp_hash[new_color].shift
        if wp_hash[new_color].length == 0
          wp_hash.delete(new_color)
        end
      elsif (feedback[index] == "wp" || feedback[index] == " ") && diff_wp_color.length == 0
        feedback[index] = provide_new_color(index)
      end
    end
    puts "new_comp_guess: #{feedback}"
    feedback
  end

  def dec_initial_hash(hash, player, computer)
    player.each_with_index do |item, index|
      if hash.key?(item) == true && player[index] == computer[index]
        hash[item] -= 1
      end 
    end
    hash 
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

  def make_comp_guesser(player_answer)
    @comp_response = gener_computer_guess
    first_comparison = compare_guess_answer(@comp_response, player_answer)
    second_comparison = check_answer_position(first_comparison, player_answer, @comp_response)
    second_comparison
  end

  def make_second_compguess(player_answer, compguess)
    @comp_response = create_new_compguess(compguess, @comp_response)
    first_comparison = compare_guess_answer(@comp_response, player_answer)
    second_comparison = check_answer_position(first_comparison, player_answer, @comp_response)
    second_comparison
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
      puts "Computer has lost!"
      exit
    end
  end

  def continue_game(computer_answer)
    game_play = play_game(computer_answer)
    while @@max_guesses > 1
      if game_play == computer_answer
        puts 'You have won the game!'
        exit
      else
        @@max_guesses -= 1
        puts '-----------------------------------------------------------'
        puts "your number of guesses remaining equals: #{@@max_guesses}"
      end
      game_play = play_game(computer_answer) 
    end
    @@max_guesses -= 1
    if game_play != computer_answer && @@max_guesses == 0
      puts "You Lost!"
      exit
    end
  end
end


my_game = ExecuteMasterMind.new
my_game.start_game
