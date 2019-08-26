class Output
  attr_reader :value, :script_pubkey

  def initialize args
    # value: 送信内容（金額）
    # script_pubkey: 宛先の後悔鍵ハッシュ
    @value = args[:value]
    @script_pubkey = args[:script_pubkey]
  end
end
