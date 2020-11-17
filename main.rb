# frozen_string_literal: true

require 'pry'
require 'colorize'

require_relative 'game'
require_relative 'player'

game = Game.new
game.game_flow
