require 'date'
require_relative 'block'
require_relative 'transaction'

class BlockChain
  attr_accessor :chain, :difficulty, :pending_transactions, :reward

  def initialize(timestamp = nil)
    self.difficulty = 4
    self.reward = 100
    self.pending_transactions = []
    self.chain = [generate_genesis(timestamp)]
  end

  def block(hash)
    chain.find { |block| block.hash == hash }
  end

  def generate_genesis(timestamp = nil)
    timestamp = DateTime.new.to_s if timestamp.nil?
    Block.new(timestamp, ['Genesis'])
  end

  def latest_block
    chain.last
  end

  def mine_pending_transactions(reward_address, network_pending)
    network_pending.push(Transaction.new(nil, reward_address, reward))
    new_block = Block.new(DateTime.new.to_s, network_pending, chain.last.hash)
    new_block.mine(difficulty)
    puts 'Block mined successfully'

    chain.push(new_block)
  end

  def add_transaction(transaction)
    raise 'Transaction must include to and from' unless transaction.from && transaction.to

    raise 'Transaction is not valid' unless transaction.valid?

    pending_transactions.push(transaction)
  end

  def balance_for_address(address)
    balance = 0

    chain.each do |block|
      block.transactions.each do |trans|
        next if trans == 'Genesis'

        if trans.from == address
          balance -= trans.amount
        end

        if trans.to == address
          balance += trans.amount
        end
      end
    end

    balance
  end


  def print
    chain.each { |block| puts block.print }
    puts "Chain is valid: #{valid?}"
  end

  def valid?
    chain.each_with_index do |curr_block, index|
      next if index == 0

      return false unless curr_block.has_valid_transactions?

      return false if curr_block.hash != curr_block.calculate_hash

      prev = chain[index - 1]
      return false if curr_block.previous_hash != prev.hash
    end

    return true
  end
end