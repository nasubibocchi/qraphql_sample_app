# frozen_string_literal: true

module Mutations
  class CreateUser < BaseMutation
    # GraphQL学習用: Mutation は GraphQL でデータを変更する操作です
    # Query は読み取り専用、Mutation は書き込み操作を行います

    description "新しいユーザーを作成"

    # GraphQL学習用: 引数の定義
    # これらの引数はクライアントからのリクエストで必要になります
    argument :name, String, required: true, description: "ユーザー名"
    argument :email, String, required: true, description: "メールアドレス"

    # GraphQL学習用: 戻り値の型を定義
    type Types::UserType

    # GraphQL学習用: resolve メソッドは Mutation が実行されたときに呼び出されます
    def resolve(name:, email:)
      user = User.new(name: name, email: email)

      if user.save
        # 成功時はユーザーオブジェクトを返す
        user
      else
        # GraphQL学習用: エラーハンドリング
        # バリデーションエラーを GraphQL エラーとして返す
        GraphQL::ExecutionError.new("ユーザー作成に失敗しました: #{user.errors.full_messages.join(', ')}")
      end
    end
  end
end
