# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    # GraphQL学習用: CommentType は GraphQL におけるコメントのスキーマ定義です

    field :id, ID, null: false
    field :content, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # GraphQL学習用: 関連するユーザー情報を取得
    field :user, Types::UserType, null: false,
          description: "コメントの作成者"

    # GraphQL学習用: 関連する投稿情報を取得
    field :post, Types::PostType, null: false,
          description: "コメントが属する投稿"
  end
end
