require 'pry'
require 'digest'

class Block
  attr_accessor :timestamp, :transactions, :previous_hash, :hash, :noonce

  def initialize(timestamp, transactions, previous_hash = '')
    self.timestamp = timestamp
    self.transactions = transactions
    self.previous_hash = previous_hash
    self.hash = calculate_hash
    self.noonce = 0
  end

  def calculate_hash
    sha = Digest::SHA256.new
    sha.update(timestamp.to_s + transactions.to_s + previous_hash + noonce.to_s)
    sha.hexdigest
  end

  def mine(difficulty)
    diff = []
    difficulty.times { diff << 0 }
    diff = diff.join('')
    while(hash[0, difficulty] != diff)
      self.noonce += 1
      self.hash = calculate_hash
    end
  end

  def has_valid_transactions?
    transactions.each { |tran| return false unless tran.valid? }

    return true
  end

  def equals_block(block)
    return hash == block.hash && timestamp == block.timestamp && transactions == block.transactions && previous_hash == block.previous_hash && noonce == block.noonce
  end

  def print
    puts "index #{self.index}"
    puts "timestamp #{self.timestamp}"
    puts "data #{self.data}"
    puts "prev #{self.previous_hash}"
    puts "hash #{self.hash}"
  end
end