require 'slim'
require 'sinatra'
require 'stretcher'

configure do
  ES = Stretcher::Server.new('http://localhost:9200')
end

class Tweets
  def self.match(text: 'elasticsearch', size: 1000)
    ES.index(:tweets).search size: size, query: {
      match: { text: text }
    }
  end
end

get "/" do
  redirect "/elasticsearch"
end

get "/:word" do
  slim :index, locals: {
    tweets: Tweets.match(text: params[:word])
  }
end

__END__
@@ layout
doctype html
html
  body== yield

@@ index
h1= "#{tweets.total} tweets matching “#{params[:word]}”"
ul
  - tweets.results.each do |tweet|
    li= tweet.text
