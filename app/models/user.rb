class User < ApplicationRecord
  before_save { self.email.downcase! }  #レコードセーブ前にself(Userインスタンス)のemailをdowncase(全て小文字にする)　！は自分自身を直接変換すること
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, #正しいメールアドレス記法かどうか
                    uniqueness: { case_sensitive: false } #uniqueness: 重複許さない　case~大文字小文字を区別しない
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relatuonship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relatuonship, source: :user
  
  has_many :favorites
  has_many :favorite_microposts, through: :favorites, source: :micropost
  
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  def favorite(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end
  
  def unfavorite(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def favorite?(micropost)
    self.favorite_microposts.include?(micropost)
  end
  
end
