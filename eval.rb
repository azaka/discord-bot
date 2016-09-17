# Gives you the ability to execute code on the fly

require 'discordrb'
require 'json'

#my_hash = {:hello => "goodbye"}
#puts JSON.generate(my_hash)# => "{\"hello\":\"goodbye\"}"

require 'dotenv'
Dotenv.load

bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], application_id: 218373395010551808, prefix: '!'

bot.command(:eval, help_available: false) do |event, *code|
  #event.respond 'command'
  #puts "received eval command from userid: #{event.user.id}"
  break unless event.user.id == ENV['UID'].to_i # Replace number with your ID
  
  #puts 'execute'

  begin
    eval code.join(' ')
  rescue
    "An error occured 😞"
  end
end

# ping owner when ready
@priv_chan=nil
@owner_id=nil
@owner_user=nil
bot.ready do |event|
	@owner_id = ENV['UID'].to_i
	@priv_chan = bot.private_channel @owner_id
	
	@owner_user = @priv_chan.recipient
	
	@owner_user.mention
	
	# ready timestamp
end

bot.run
