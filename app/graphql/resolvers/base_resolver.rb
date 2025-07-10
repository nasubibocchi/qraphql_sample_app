# frozen_string_literal: true

# このクラスをリゾルバートして使う場合は、各クエリで指定する
# 例：
# field :user, resolver: Resolvers::UserResolver (UserResolverはBaseResolverを継承)
# Mutationクラスを参考にするとわかりやすい

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
  end
end
