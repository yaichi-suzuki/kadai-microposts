class User < ApplicationRecord
  before_save { self.email.downcase! }  #レコードセーブ前にself(Userインスタンス)のemailをdowncase(全て小文字にする)　！は自分自身を直接変換すること
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, #正しいメールアドレス記法かどうか
                    uniqueness: { case_sensitive: false } #uniqueness: 重複許さない　case~大文字小文字を区別しない
  has_secure_password
  
  has_many :microposts
end
