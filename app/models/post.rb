class Post < ApplicationRecord
  # GraphQL学習用: PostとUserの関連付け
  # 1つの投稿は1人のユーザーに属する（多対1の関係）
  belongs_to :user

  # GraphQL学習用: PostとCommentの関連付け
  # 1つの投稿は複数のコメントを持つことができる（1対多の関係）
  has_many :comments, dependent: :destroy

  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }
end
