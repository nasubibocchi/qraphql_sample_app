class Comment < ApplicationRecord
  # GraphQL学習用: CommentとUserの関連付け
  # 1つのコメントは1人のユーザーに属する（多対1の関係）
  belongs_to :user

  # GraphQL学習用: CommentとPostの関連付け
  # 1つのコメントは1つの投稿に属する（多対1の関係）
  belongs_to :post

  # バリデーション
  validates :content, presence: true, length: { maximum: 500 }
end
