# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # GraphQL学習用: Mutationフィールドの定義
    # これらはデータを作成・更新・削除するためのオペレーションです

    field :create_user, mutation: Mutations::CreateUser,
          description: "新しいユーザーを作成"

    field :create_post, mutation: Mutations::CreatePost,
          description: "新しい投稿を作成"

    field :create_comment, mutation: Mutations::CreateComment,
          description: "新しいコメントを作成"
  end
end
