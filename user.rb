require 'bitcoin'
require_relative 'block_chain'

class User
  attr_accessor :block_chain, :key, :wallet_address, :network

  def initialize(chain)
    self.block_chain = chain
    self.key = Bitcoin::Key.generate
    self.wallet_address = key.pub
  end

  def add_transaction(amount, other_public_key)
    transaction = Transaction.new(wallet_address, other_public_key, amount)
    transaction.sign_transaction(key)
    block_chain.add_transaction(transaction)
  end

  def pending_transactions
    block_chain.pending_transactions
  end

  def mine_pending_transactions
    to_process = network.pending_transactions
    block_chain.mine_pending_transactions(wallet_address, to_process)
    network.ask_for_consensus(self)
    puts 'finished mining'
  end
end
