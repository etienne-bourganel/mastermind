# frozen_string_literal: true

# Class for all analyzing operations
module Analyze
  # Count the number of correct guessed colors
  def count_correct_colors(secret_code, guess_code)
    secret_hash = transform_code_array_into_hash(secret_code)
    guess_hash = transform_code_array_into_hash(guess_code)
    difference_hash = create_difference_hash(secret_hash, guess_hash)
    secret_colors = secret_hash.keys # Create an array with the correct color codes
    difference_hash_with_secret_colors = create_new_hash_with_correct_colors(difference_hash, secret_colors)
    sum = 0
    difference_hash_with_secret_colors.each { |_k, v| sum += v if v.positive? } # Only positive differences are kept
    correct_colors = 4 - sum # sum is all the colors from secrets that have not been guessed
    correct_colors
  end

  # Count the number of correctly postionned colors
  def count_correct_positions(guess_code, secret_code)
    correct_positions = 0
    (0..3).each do |i|
      correct_positions += 1 if guess_code[i] == secret_code[i]
    end
    correct_positions
  end

  # Transform the array of colors into an hash with color id number as the key
  def transform_code_array_into_hash(ary)
    ary.group_by(&:itself).map { |k, v| [k, v.length] }.to_h
  end

  # Create a new hash with values calculated from difference between two hashes to spot differences
  def create_difference_hash(secret, guess)
    secret.merge(guess) { |_k, secret_color, guess_color| (secret_color - guess_color) }
  end

  # Create a new hash with only the secret code colors as keys
  def create_new_hash_with_correct_colors(hash, colors_ary)
    hash.delete_if { |k, _v| k unless colors_ary.include? k }
  end
end
