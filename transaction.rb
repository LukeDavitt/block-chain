require 'digest'
require 'bitcoin'


class Transaction
  attr_accessor :from, :to, :amount, :signature, :hash

  def initialize(from, to, amount)
    self.from = from
    self.to = to
    self.amount = amount
  end

  def calculate_hash
    sha = Digest::SHA256.new
    sha.update(from + to + amount.to_s)
    sha.hexdigest
  end

  def sign_transaction(signing_key)
    raise 'You cannot sign transactions for other wallets' unless signing_key.pub == from

    self.hash = calculate_hash
    self.signature = signing_key.sign(hash)
  end

  def valid?
    return true if from.nil?

    raise 'No signature in this transaction' if self.signature.nil? || self.signature.length == 0

    Bitcoin.verify_signature(hash, signature, from)
  end
end