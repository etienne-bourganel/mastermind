# frozen_string_literal: true

require 'pry'
require 'colorize'

require_relative 'game'
require_relative 'player'
require_relative 'display'

game = Game.new
game.flow

binding.pry