# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    # GraphQL学習用: PostType は GraphQL における投稿のスキーマ定義です

    field :id, ID, null: false
    field :title, String, null: false
    field :content, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # GraphQL学習用: 関連するユーザー情報を取得
    # belongs_to の関係を GraphQL で表現
    field :user, Types::UserType, null: false,
          description: "投稿の作成者"

    # GraphQL学習用: 関連するコメント一覧を取得
    # has_many の関係を GraphQL で表現
    field :comments, [ Types::CommentType ], null: false,
          description: "投稿に対するコメント一覧"

    # GraphQL学習用: 計算フィールド
    field :comments_count, Integer, null: false,
          description: "投稿に対するコメント数"

    # GraphQL学習用: リゾルバーメソッド
    def comments_count
      object.comments.count
    end
  end
end
