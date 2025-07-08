class User < ApplicationRecord
  # GraphQL学習用: UserとPostの関連付け
  # 1人のユーザーは複数の投稿を持つことができる（1対多の関係）
  has_many :posts, dependent: :destroy

  # GraphQL学習用: UserとCommentの関連付け
  # 1人のユーザーは複数のコメントを持つことができる（1対多の関係）
  has_many :comments, dependent: :destroy

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
