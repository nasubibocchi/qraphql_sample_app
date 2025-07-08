# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # GraphQL学習用: ルートレベルのクエリフィールド
    # これらはGraphQLクエリのエントリーポイントとなります

    # すべてのユーザーを取得するクエリ
    field :users, [ Types::UserType ], null: false,
          description: "すべてのユーザー一覧を取得"

    # 特定のユーザーを取得するクエリ
    field :user, Types::UserType, null: true,
          description: "IDを指定してユーザーを取得" do
      argument :id, ID, required: true, description: "ユーザーID"
    end

    # すべての投稿を取得するクエリ
    field :posts, [ Types::PostType ], null: false,
          description: "すべての投稿一覧を取得"

    # 特定の投稿を取得するクエリ
    field :post, Types::PostType, null: true,
          description: "IDを指定して投稿を取得" do
      argument :id, ID, required: true, description: "投稿ID"
    end

    # すべてのコメントを取得するクエリ
    field :comments, [ Types::CommentType ], null: false,
          description: "すべてのコメント一覧を取得"

    # GraphQL学習用: リゾルバーメソッド
    # これらのメソッドは対応するフィールドがクエリされたときに実行されます

    def users
      User.all
    end

    def user(id:)
      User.find_by(id: id)
    end

    def posts
      Post.all
    end

    def post(id:)
      Post.find_by(id: id)
    end

    def comments
      Comment.all
    end
  end
end
