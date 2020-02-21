class User < ApplicationRecord
  has_secure_password

  has_many :articles

  has_many :favorites
  has_many :favorite_articles, through: :favorites, source: :article

  has_many :read_articles
  has_many :old_articles, through: :read_articles, source: :article

  def unread_articles
    Article.where.not('id IN (?)', old_articles.pluck(:id))
  end
end
