# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    # GraphQL学習用: CommentType は GraphQL におけるコメントのスキーマ定義です

    field :id, ID, null: false
    field :content, String, null: false

    # GraphQL::Types::ISO8601DateTimeは、GraphQL Ruby gemが提供する標準的な日時型です。
    # 特徴:
    # - ISO 8601形式の日時文字列（例: "2023-12-25T10:30:00Z"）として入出力
    # - RubyのTimeやDateTimeオブジェクトと自動変換
    # - タイムゾーン情報を含む
    # - GraphQLスキーマでフィールドやargumentの型として使用
    #
    # クライアント側では"2023-12-25T10:30:00Z"のような文字列として扱われ、サーバー側では自動的にRubyの日時オブジェクトに変換されます。

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
