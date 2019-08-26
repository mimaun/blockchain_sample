require 'openssl'

require_relative 'block_chain'

class Miner
  attr_reader :name, :block_chain
  def initialize args
      @name = args[:name]
      @rsa = OpenSSL::PKey::RSA.generate(2048)
      @block_chain = BlockChain.new
  end

  # ブロックチェーンにブロックを追加/
  # ブロックチェーンを受け入れるか判断
  #
  # ======= accept condition ======
  # 前のブロックのindexの次のindexと等しい
  # 前のブロックのhashは新しいブロックのprevious_hashと等しい
  # hashの計算方法が誤ってないか確認 ブロックチェーンとして正しいか
  #
  # 最初のブロックから検証していき条件を満たすか確認
  def accept receive_block_chain
      puts "#{@name} checks received block-chain. Size: #{@block_chain.size}"

      if receive_block_chain.size > @block_chain.size
          if BlockChain.is_valid_chain? receive_block_chain
              puts "#{@name} accepted received block-chain."
              @block_chain = receive_block_chain.clone
          else
              puts "Received block-chain is invalid."
          end
      end
  end

  # ブロックを追加
  def add_new_block
      next_block = @block_chain.create_next_block []
      @block_chain.add_block(next_block)
      puts "#{@name} add new block: #{next_block.hash}"
  end
end
