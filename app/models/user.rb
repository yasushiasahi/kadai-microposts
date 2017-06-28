class User < ApplicationRecord
  before_save {self.email.downcase!}
  validates :name, presence: true, length: {maximum: 50}
  validates :nickname, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: {case_sensitive: false}
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: "Relationship", foreign_key: "follow_id"
  has_many :followers, through: :reverses_of_relationship, source: :user
  has_many :favorites
  has_many :adding_to_favorites, through: :favorites, source: :micropost
  has_many :comments
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(orther_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  def add_to_favorites(micropost)
    unless self.favorites.find_by(micropost_id: micropost.id)
      self.favorites.create(micropost_id: micropost.id)
    end
  end
  
  def release_favorites(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    if favorite
      favorite.destroy
    end
  end
  
  def adding_to_favorites?(micropost)
    self.adding_to_favorites.include?(micropost)
  end
  
end
