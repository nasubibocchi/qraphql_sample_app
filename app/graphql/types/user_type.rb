# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    # GraphQL学習用: UserType は GraphQL におけるユーザーのスキーマ定義です
    # フィールドは GraphQL クエリで取得できるデータを定義します

    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # GraphQL学習用: 関連するデータをフィールドとして定義
    # これにより、1回のクエリでユーザーと関連する投稿を取得できます
    field :posts, [ Types::PostType ], null: false,
          description: "ユーザーの投稿一覧"

    # GraphQL学習用: 関連するコメントも同様に定義
    field :comments, [ Types::CommentType ], null: false,
          description: "ユーザーのコメント一覧"

    # GraphQL学習用: 計算フィールド（データベースにはない仮想的なフィールド）
    field :posts_count, Integer, null: false,
          description: "ユーザーの投稿数"

    # GraphQL学習用: リゾルバーメソッド - カスタムロジックを実装
    def posts_count
      # object は現在のUser インスタンスを指す
      object.posts.count
    end
  end
end
