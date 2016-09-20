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
@priv_chan = nil
@owner_id = nil
@owner_user = nil
bot.ready do |event|
	@owner_id = ENV['UID'].to_i
	@priv_chan = bot.private_channel @owner_id
	
	@owner_user = @priv_chan.recipient
	
	event.respond @owner_user.mention
	
	# ready timestamp
end

# get recent issues for repos that matches keyword
# as array of title strings

require 'octokit'
@last_updated = nil
def recent_issue_titles(name)
	#@@recent_issues = []
	#@@last_updated = nil
	
	issues = Octokit.search_issues name, {:sort => :updated, :per_page => 10}
	
	# filter for newer issues
	issues.items.reject!{|issue_item| issue_item.updated_at < @last_updated} unless @last_updated.nil?
	@last_updated = issues.items.first.updated_at
	
	issues.items.map{|issue_item| issue_item.title}
end

# get recent updated repos that matches keyword
# as array of title strings

def recent_updated_titles(name)
	issues = Octokit.search_repositories name, {:sort => :updated}
	
	# filter for newer issues
	issues.items.reject!{|issue_item| issue_item.updated_at < @last_updated} unless @last_updated.nil?
	@last_updated = issues.items.first.updated_at
	
	issues.items.map{|issue_item| issue_item.name}
	
end

bot.run
