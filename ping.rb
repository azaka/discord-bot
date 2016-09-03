# This simple bot responds to every "Ping!" message with a "Pong!"

require 'dotenv'
require 'discordrb'

Dotenv.load

bot = Discordrb::Bot.new token: ENV['TOKEN'], application_id: 218373395010551808


# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run

