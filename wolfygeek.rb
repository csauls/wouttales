#!/usr/bin/env ruby

require 'rubygems'
require 'curl'
require 'chatterbot/dsl'


HASHTAG     = '#WoutTales'
WOUT_USER   = 'wout123456'

MAX_QUOTE_ATTEMPTS  = 10
MAX_QUOTE_LENGTH    = 140 - HASHTAG.length
QUOTE_SOURCES       = %w(math prog_style).join '+'
QUOTE_URL           = "http://www.iheartquotes.com/api/v1/random?source=#{QUOTE_SOURCES}"


$curl = CURL.new
def get_quote
    result = ''
    attempts = 0
    loop do
        quote = $curl.get(QUOTE_URL).squeeze(" \n").split("\n")
        quote = quote.slice(0, quote.length - 1).join(' ')

        if quote.length <= MAX_QUOTE_LENGTH then
            result = quote
            break
        end

        attempts += 1
        break if attempts >= MAX_QUOTE_ATTEMPTS
    end
    return result
end


# remove this to send out tweets
#debug_mode


# remove this to update the db
#no_update


# remove this to get less output when running
verbose


# here's a list of users to ignore
#blacklist "abc", "def"


# here's a list of things to exclude from searches
#exclude "hi", "spammer", "junk"


loop do
    search "from:#{WOUT_USER} '[1]' -'[2]'" do |tweet|
    #search "from:wolfygeek" do |tweet|
        quote = get_quote
        reply "#{HASHTAG} #{quote}", tweet
    end

    update_config

    sleep 120
end
