require 'mailgun'
require 'csv'
require 'twitter'

# Create CSV 

# CSV.open("my_results.csv", "wb") do |csv|
  # csv << ["animal", "count", "price"]
  # csv << ["fox", "1", "$90.00"]
# end

# Twitter scrape

# Authentication details from twitter, your starting
# point is here: https://dev.twitter.com/apps/new
client = Twitter::REST::Client.new do |config|
  config.consumer_key    = "ACFlHj3xmKSseeQHJ5yprQ"
  config.consumer_secret = "TtqDmi8tloCltsMP7XGVd5jjrb8jjVvgXRtLlmXxN4"
end

# twitter handle to get tweets for
the_twitter_handle = "justwes"

# go through each tweet and print out the text
client.user_timeline(the_twitter_handle).take(10).collect do |tweet|
    # puts tweet.text
    CSV.open("twitter_results.csv", "a+") do |csv|
        csv << [tweet.text]
end 
end 

# Email the CSV

my_file = File.open("twitter_results.csv")
    
    # Initialize your Mailgun object:
Mailgun.configure do |config|
  config.api_key = 'xxxxxxxxxx'
  config.domain  = 'sandbox68648.mailgun.org'
end

@mailgun = Mailgun()

# or alternatively:
@mailgun = Mailgun(:api_key => 'xxxxxxxxxx')

parameters = {
  :to => "email@xyz.com",
  :subject => "missing tps reports",
  :text => "yeah, we're gonna need you to come in on friday...yeah.",
  :from => "lumberg.bill@initech.mailgun.domain",
  :attachment => my_file
}
@mailgun.messages.send_email(parameters)

