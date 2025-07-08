# GraphQL学習用サンプルアプリケーション

このアプリケーションは、GraphQLの基本概念を学ぶために作成しました。

## 📖 GraphQLとは？

GraphQLは、APIのためのクエリ言語およびランタイムです。RESTと比較して以下の特徴があります：

- **必要なデータのみを取得**: クライアントが必要なフィールドだけを指定できます
- **1つのエンドポイント**: `/graphql` 1つのエンドポイントですべてのデータにアクセス
- **型システム**: スキーマで定義された型による安全なデータ取得
- **リアルタイム機能**: Subscriptionによるリアルタイム更新（このサンプルでは未実装）

## 🚀 セットアップ

```bash
# 依存関係のインストール
bundle install

# データベースの作成とマイグレーション
rails db:create
rails db:migrate

# サンプルデータの作成
rails db:seed

# サーバーの起動
rails server
```

## 🔍 GraphQLの基本概念

### 1. Schema（スキーマ）
`app/graphql/graphql_sample_app_schema.rb`でアプリケーション全体のスキーマを定義

### 2. Types（型）
- `UserType`: ユーザーのフィールド定義
- `PostType`: 投稿のフィールド定義
- `CommentType`: コメントのフィールド定義

### 3. Query（クエリ）
データの読み取り操作。`app/graphql/types/query_type.rb`で定義

### 4. Mutation（ミューテーション）
データの書き込み操作。`app/graphql/mutations/`で定義

### 5. Resolver（リゾルバー）
フィールドの値を解決するメソッド

## 📝 サンプルクエリ

### 全ユーザー取得
```graphql
query {
  users {
    id
    name
    email
    postsCount
    posts {
      id
      title
      content
      commentsCount
    }
  }
}
```

### 特定ユーザー取得
```graphql
query {
  user(id: "1") {
    id
    name
    email
    posts {
      id
      title
      comments {
        id
        content
        user {
          name
        }
      }
    }
  }
}
```

### 投稿とコメントの取得
```graphql
query {
  posts {
    id
    title
    content
    user {
      name
    }
    comments {
      id
      content
      user {
        name
      }
    }
  }
}
```

## ✏️ サンプルMutation

### ユーザー作成
```graphql
mutation {
  createUser(name: "新しいユーザー", email: "new@example.com") {
    id
    name
    email
  }
}
```

### 投稿作成
```graphql
mutation {
  createPost(title: "新しい投稿", content: "投稿内容", userId: "1") {
    id
    title
    content
    user {
      name
    }
  }
}
```

### コメント作成
```graphql
mutation {
  createComment(content: "素晴らしい投稿ですね！", userId: "2", postId: "1") {
    id
    content
    user {
      name
    }
    post {
      title
    }
  }
}
```

## 🧪 GraphQLクエリのテスト方法

### 1. cURLでのテスト
```bash
curl -X POST http://localhost:3000/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ users { id name email } }"
  }'
```

### 2. GraphiQLアプリ
- [GraphiQL.app](https://github.com/skevy/graphiql-app)をダウンロード
- エンドポイント: `http://localhost:3000/graphql`

### 3. Postman
- POST リクエストで `http://localhost:3000/graphql`
- Body: JSON形式でクエリを送信

https://github.com/user-attachments/assets/4d257f75-6d71-4eb5-8b39-3fde7ab7c38e

※ POST以外のリクエスト方法も可能
1. POST (最も一般的)
- Query、Mutation、Subscriptionすべてに使用可能
- リクエストボディにクエリを含める
- 複雑なクエリや機密データに適している
2. GET (読み取り専用のQueryで使用可能)
- URLパラメータでクエリを送信
- キャッシュが効きやすい
- ブラウザで直接アクセス可能

## 🎯 GraphQL学習のポイント

### 1. RESTとの違い
- **REST**: 複数のエンドポイント、固定のレスポンス形式
- **GraphQL**: 1つのエンドポイント、柔軟なレスポンス形式

### 2. Over-fetching/Under-fetchingの解決
- **Over-fetching**: 不要なデータまで取得してしまう問題
- **Under-fetching**: 必要なデータを取得するために複数のリクエストが必要な問題

### 3. N+1問題の注意
GraphQLでは関連データの取得時にN+1問題が発生しやすい。解決策：
- `graphql-batch` gem の使用
- `includes` を使った事前ロード

## 🔧 実装の詳細

### ファイル構成
```
app/graphql/
├── types/
│   ├── base_*.rb          # 基底クラス
│   ├── user_type.rb       # ユーザー型定義
│   ├── post_type.rb       # 投稿型定義
│   ├── comment_type.rb    # コメント型定義
│   ├── query_type.rb      # クエリ型定義
│   └── mutation_type.rb   # ミューテーション型定義
├── mutations/
│   ├── base_mutation.rb   # ミューテーション基底クラス
│   ├── create_user.rb     # ユーザー作成
│   ├── create_post.rb     # 投稿作成
│   └── create_comment.rb  # コメント作成
└── graphql_sample_app_schema.rb  # スキーマ定義
```

### 重要なコンセプト

1. **型の定義**: `field` で公開するフィールドを定義
2. **引数の定義**: `argument` でクエリの引数を定義
3. **リゾルバー**: フィールドの値を解決するメソッド
4. **エラーハンドリング**: `GraphQL::ExecutionError` でエラーを返す

## 🌟 次のステップ

1. **認証・認可の実装**
2. **サブスクリプションの実装**
3. **キャッシュの実装**
4. **パフォーマンスの最適化**
5. **フロントエンドとの連携**
