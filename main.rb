require 'pry'
require 'bitcoin'
require_relative 'block_chain'
require_relative 'user'
require_relative 'network'

def get_balance(params)
  user = @network.users[params.first.to_i]
  @network.user_balance(user)
end

def create_transaction(params)
  from = @network.users[params.first.to_i]
  to = @network.users[params[1].to_i]
  amount = params[2].to_i
  if amount < 1 || from == to || from.nil? || to.nil?
    puts 'bad transaction'
    return
  end

  from.add_transaction(amount, to.wallet_address)
  return
end

def mine_the_transactions(params)
  miner = @network.users[params.first&.to_i]
  if miner.nil?
    return 'a user has to perform the mine'
  end

  miner.mine_pending_transactions
  return
end

def get_pending
  trans = @network.pending_transactions
  trans.each { |tran| puts tran}
end

@keep_open = true
block_chain = BlockChain.new
users = []
101.times do
  duped = BlockChain.new(block_chain.chain.first.timestamp)
  users.push(User.new(duped))
end

@network = Network.new(users)

while @keep_open
  puts "\nEnter command: "
  input = gets.chomp
  command, *params = input.split /\s/
  case command
    when 'user'
      get_balance(params)
    when 'transaction'
      create_transaction(params)
    when 'mine'
      mine_the_transactions(params)
    when 'quit'
      @keep_open = false
    when 'pending'
      get_pending
    else
      puts 'Invalid command'
  end
end

# user_1 = network.users.first
# user_2 = network.users[1]
# user_3 = network.users[2]

# user_1.add_transaction(10, user_2.wallet_address)

# user_3.mine_pending_transactions
