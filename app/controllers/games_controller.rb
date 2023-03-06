require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')
    @result = {}

    if included?(@word.upcase, @letters)
      if english_word?(@word)
        @result[:score] = @word.length
        @result[:message] = "Congratulations! #{@word} is a valid English word!"
      else
        @result[:score] = 0
        @result[:message] = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @result[:score] = 0
      @result[:message] = "Sorry, but #{@word} can't be built out of #{@letters}."
    end

    respond_to do |format|
      format.json { render json: @result }
    end
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
