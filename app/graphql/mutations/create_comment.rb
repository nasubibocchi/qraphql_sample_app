# frozen_string_literal: true

module Mutations
  class CreateComment < BaseMutation
    # GraphQL学習用: コメントを作成するMutation

    description "新しいコメントを作成"

    argument :content, String, required: true, description: "コメント内容"
    argument :user_id, ID, required: true, description: "コメント者のユーザーID"
    argument :post_id, ID, required: true, description: "コメント対象の投稿ID"

    type Types::CommentType

    def resolve(content:, user_id:, post_id:)
      # GraphQL学習用: 複数の関連データの存在確認
      user = User.find_by(id: user_id)
      post = Post.find_by(id: post_id)

      unless user
        return GraphQL::ExecutionError.new("指定されたユーザーが見つかりません")
      end

      unless post
        return GraphQL::ExecutionError.new("指定された投稿が見つかりません")
      end

      comment = Comment.new(content: content, user: user, post: post)

      if comment.save
        comment
      else
        GraphQL::ExecutionError.new("コメント作成に失敗しました: #{comment.errors.full_messages.join(', ')}")
      end
    end
  end
end
