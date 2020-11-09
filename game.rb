# frozen_string_literal: true

# Contains flow of a game and game operations
class Game
  attr_reader :secret_code
  COLORS = %w(blue green brown yellow orange black).freeze
  def initialize
    create_players
    @secret_code = define_secret_code
  end

  # Create both players
  def create_players
    human = Human.new('codebreaker')
    machine = Machine.new('codemaker')
  end

  # Create the secret code based on available colors
  def define_secret_code
    [COLORS.sample, COLORS.sample, COLORS.sample, COLORS.sample]
  end
end
