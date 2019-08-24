require 'bitcoin'
require 'pry'

key = Bitcoin::Key.generate
key.priv
key.pub
key.addr
sig = key.sign("data")


puts "public:  #{key.pub}"
puts "private: #{key.priv}"

