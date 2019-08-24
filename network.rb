require_relative 'user'

class Network
  attr_accessor :users

  def initialize(users)
    self.users = users
    users.each { |user|  user.network = self }
  end

  def pending_transactions
    transactions = users.map(&:pending_transactions).flatten
    users.each { |user| user.block_chain.pending_transactions = [] }
    return transactions
  end

  def user_balance(user)
    block_chain = users.first.block_chain
    count = block_chain.chain.count
    users.each do |net_user|
      if count != net_user.block_chain.chain.count
        puts 'Balance unavailable, system processing pending transaction'
        raise 'Bad Juju'
      end
    end

    puts "Balance for user is: #{block_chain.balance_for_address(user.wallet_address)}"
  end

  def ask_for_consensus(user_mined)
    users.each do |user|
      next if user == user_mined

      agree = 0
      user.block_chain.chain.each_with_index do |block, index|
        exit if agree > (users.count / 2)

        valid = block.equals_block(user_mined.block_chain.chain[index])
        agree += 1 if valid
      end
    end


    block_to_add = user_mined.block_chain.chain.last
    users.each do |user|
      next if user == user_mined

      user.block_chain.chain.push(block_to_add)
    end

    return true
  end
end