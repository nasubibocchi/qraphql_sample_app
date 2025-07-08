# frozen_string_literal: true

module Mutations
  class CreatePost < BaseMutation
    # GraphQL学習用: 投稿を作成するMutation

    description "新しい投稿を作成"

    argument :title, String, required: true, description: "投稿タイトル"
    argument :content, String, required: true, description: "投稿内容"
    argument :user_id, ID, required: true, description: "投稿者のユーザーID"

    type Types::PostType

    def resolve(title:, content:, user_id:)
      # GraphQL学習用: 関連するユーザーの存在確認
      user = User.find_by(id: user_id)
      unless user
        return GraphQL::ExecutionError.new("指定されたユーザーが見つかりません")
      end

      post = Post.new(title: title, content: content, user: user)

      if post.save
        post
      else
        GraphQL::ExecutionError.new("投稿作成に失敗しました: #{post.errors.full_messages.join(', ')}")
      end
    end
  end
end
