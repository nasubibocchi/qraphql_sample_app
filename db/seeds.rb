# GraphQL学習用: サンプルデータの作成
# このファイルは rails db:seed コマンドで実行されます

# 既存のデータをクリア（開発環境のみ）
if Rails.env.development?
  Comment.destroy_all
  Post.destroy_all
  User.destroy_all
end

# ユーザーの作成
puts "Creating users..."
user1 = User.create!(
  name: "田中太郎",
  email: "tanaka@example.com"
)

user2 = User.create!(
  name: "山田花子",
  email: "yamada@example.com"
)

user3 = User.create!(
  name: "佐藤次郎",
  email: "sato@example.com"
)

# 投稿の作成
puts "Creating posts..."
post1 = Post.create!(
  title: "GraphQLの基本",
  content: "GraphQLはAPIのためのクエリ言語です。RESTよりも効率的にデータを取得できます。",
  user: user1
)

post2 = Post.create!(
  title: "Railsとの統合",
  content: "RailsアプリケーションにGraphQLを統合する方法について説明します。",
  user: user1
)

post3 = Post.create!(
  title: "フロントエンドとの連携",
  content: "React.jsやVue.jsなどのフロントエンドフレームワークとGraphQLを組み合わせる方法。",
  user: user2
)

# コメントの作成
puts "Creating comments..."
Comment.create!(
  content: "とても参考になりました！GraphQLの概念が理解できました。",
  user: user2,
  post: post1
)

Comment.create!(
  content: "RESTとの違いについてもっと詳しく知りたいです。",
  user: user3,
  post: post1
)

Comment.create!(
  content: "実装例があると理解しやすいですね。",
  user: user3,
  post: post2
)

Comment.create!(
  content: "フロントエンドの実装例も見てみたいです。",
  user: user1,
  post: post3
)

Comment.create!(
  content: "Apollo Clientとの組み合わせはどうでしょうか？",
  user: user1,
  post: post3
)

puts "Sample data created successfully!"
puts "Users: #{User.count}"
puts "Posts: #{Post.count}"
puts "Comments: #{Comment.count}"
