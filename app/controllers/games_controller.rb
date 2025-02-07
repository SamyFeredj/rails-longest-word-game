require 'open-uri'
require 'json'
class GamesController < ApplicationController
  LETTERS = ('A'..'Z').to_a
  def new
    @letters = []
    10.times { |_| @letters << LETTERS[rand(LETTERS.size)] }
  end

  def score
    @word = params[:answer]
    @letters = params[:letters]
    if grid_word?
      congratulations = "Congratulations! #{@word.upcase} is a valid English word!"
      not_english_word = "Sorry but #{@word.upcase} does not seem to be an English word..."
      @result = exists? ? congratulations : not_english_word
    else
      @result = "Sorry but #{@word.upcase} cannot be built with: #{@letters.gsub(' ', '').chars.join(', ')}"
    end
  end

  private

  def api_data(word)
    url = 'https://dictionary.lewagon.com/'
    JSON.parse(URI.parse("#{url}#{word.downcase}").open.read)
  end

  def grid_word?
    @word.chars.each { |letter| return false unless @letters.chars.include?(letter) }
    true
  end

  def exists?
    api_data(@word)['found']
  end
end
