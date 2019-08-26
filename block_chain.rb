require 'digest/sha2'
require 'json'

require_relative 'block'

class BlockChain
    attr_reader :blocks

    def initialize
        # ブロックチェーン格納用リスト
        @blocks = []
        # ジェネシス・ブロック追加
        @blocks << BlockChain.get_genesis_block()
    end

    # ブロックチェーンの最後のブロックを返す
    def last_block
        @blocks.last
    end

    # 新しいブロックを作る
    def create_next_block transactions
        height = last_block.height + 1
        timestamp = Time.now.to_i
        previous_hash = last_block.hash
        pow = ProofOfWork.new(
            timestamp: timestamp,
            previous_hash: previous_hash,
            transactions: transactions
        )

        nonce, hash = pow.do_proof_of_work

        block = Block.new(
            hash: hash,
            height: height,
            transactions: transactions,
            timestamp: timestamp,
            nonce: nonce,
            previous_hash: previous_hash
        )
    end

    # 作ったブロックをチェーンに追加する
    def add_block new_block
        if is_valid_new_block?(new_block, last_block)
            @blocks << new_block
        end
    end

    # ======= accept condition ======
    # 前のブロックのindexの次のindexと等しい
    # 前のブロックのhashは新しいブロックのprevious_hashと等しい
    # hashの計算方法が誤ってないか確認 ブロックチェーンとして正しいか
    def is_valid_new_block? new_block, previous_block
        if previous_block.height + 1 != new_block.height
            puts "Invalid height."
            return false
        elsif previous_block.hash != new_block.previous_hash
            puts "Invalid hash: previous_hash."
        elsif calculate_hash_for_block(new_block) != new_block.hash
            puts "Invalid hash: hash."
            puts "Valid hash -> " + calculate_hash_for_block(new_block)
            puts "Your hash -> " + new_block.hash
            return false
        end
        true
    end

    def size
        @blocks.size
    end 

    private
    def calculate_hash_for_block block
        Digest::SHA256.hexdigest({
            timestamp: block.timestamp,
            transactions: block.transactions,
            previous_hash: block.previous_hash,
            nonce: block.nonce
        }.to_json)
    end 

    class << self
        def is_valid_chain? block_chain_to_validate
            return false if block_chain_to_validate.blocks[0] != BlockChain.get_genesis_block()
            tmp_blocks = [block_chain_to_validate.blocks[0]]
            block_chain_to_validate.blocks[1..-1].each.with_index(1) do |block, i|
                if block_chain_to_validate.is_valid_new_block?(block, tmp_blocks[i - 1])
                    tmp_blocks << block
                else 
                    return false
                end
            end
        end 

        def get_genesis_block
            Block.create_genesis_block
        end 
    end 
end
