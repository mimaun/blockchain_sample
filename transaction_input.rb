class Input
  attr_reader :tx_id, :v_out, :script_sig

  def initialize args
    # tx_id: 前の出力の参照
    # v_out: トランザクション内の出力のインデックスを格納
    # script_sig: ScriptPubKeyで使われるデータを提供する 送信側の公開鍵、電子署名
    @tx_id = args[:tx_id]
    @v_out = args[:v_out]
    @script_sig = args[:script_sig] 
  end
end
