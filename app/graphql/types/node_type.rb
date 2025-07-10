# frozen_string_literal: true

# --relayオプション（デフォルトで有効）で作成される
#
# 役割:
#   - 全てのオブジェクトに共通のidフィールドを提供
#   - GraphQL RelayのGlobal Object Identificationを実現
#   - 異なるタイプのオブジェクトを統一的に扱う

#   使用例:
#   class UserType < Types::BaseObject
#     implements GraphQL::Types::Relay::Node  # NodeTypeを実装

#     field :id, ID, null: false  # 自動的に提供される
#     field :name, String, null: false
#   end

module Types
  module NodeType
    include Types::BaseInterface
    # Add the `id` field
    include GraphQL::Types::Relay::NodeBehaviors
  end
end
