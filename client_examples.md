# GraphQL API クライアント実装例

このドキュメントでは、FlutterとReactからGraphQL APIを呼び出す方法を説明します。

## Flutter でのGraphQL API呼び出し例

### 1. HTTP パッケージを使用した基本的な方法

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class GraphQLClient {
  final String endpoint = 'http://localhost:3000/graphql';
  
  Future<Map<String, dynamic>> query(String query) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );
    
    return jsonDecode(response.body);
  }
}

// 使用例
void fetchUsers() async {
  final client = GraphQLClient();
  final result = await client.query('''
    query {
      users {
        id
        name
        email
        posts {
          id
          title
        }
      }
    }
  ''');
  
  print(result['data']['users']);
}
```

### 2. graphql_flutter パッケージを使用

```dart
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  final HttpLink httpLink = HttpLink('http://localhost:3000/graphql');
  
  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );
  
  runApp(GraphQLProvider(client: client, child: MyApp()));
}

class UsersList extends StatelessWidget {
  final String getUsersQuery = '''
    query {
      users {
        id
        name
        email
        postsCount
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(getUsersQuery)),
      builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text('Error: ${result.exception.toString()}');
        }
        
        if (result.isLoading) {
          return CircularProgressIndicator();
        }
        
        final users = result.data?['users'] as List;
        
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user['name']),
              subtitle: Text(user['email']),
            );
          },
        );
      },
    );
  }
}
```

### 3. Mutation の例

```dart
class CreateUserMutation extends StatelessWidget {
  final String createUserMutation = '''
    mutation CreateUser(\$name: String!, \$email: String!) {
      createUser(name: \$name, email: \$email) {
        id
        name
        email
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(createUserMutation),
        onCompleted: (data) {
          print('User created: ${data?['createUser']}');
        },
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        return ElevatedButton(
          onPressed: () {
            runMutation({
              'name': 'Flutter User',
              'email': 'flutter@example.com'
            });
          },
          child: Text('Create User'),
        );
      },
    );
  }
}
```

## React でのGraphQL API呼び出し例

### 1. fetch を使用した基本的な方法

```javascript
// GraphQLクライアントクラス
class GraphQLClient {
  constructor(endpoint) {
    this.endpoint = endpoint;
  }

  async query(query, variables = {}) {
    const response = await fetch(this.endpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        query,
        variables,
      }),
    });

    const result = await response.json();
    return result;
  }
}

// React コンポーネントでの使用
import React, { useState, useEffect } from 'react';

function UsersList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const client = new GraphQLClient('http://localhost:3000/graphql');

  useEffect(() => {
    const fetchUsers = async () => {
      const result = await client.query(`
        query {
          users {
            id
            name
            email
            postsCount
          }
        }
      `);
      
      setUsers(result.data.users);
      setLoading(false);
    };

    fetchUsers();
  }, []);

  if (loading) return <div>Loading...</div>;

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>
          {user.name} ({user.email}) - {user.postsCount} posts
        </li>
      ))}
    </ul>
  );
}
```

### 2. Apollo Client を使用

```javascript
import { ApolloClient, InMemoryCache, ApolloProvider, gql, useQuery, useMutation } from '@apollo/client';

// Apollo Client のセットアップ
const client = new ApolloClient({
  uri: 'http://localhost:3000/graphql',
  cache: new InMemoryCache(),
});

function App() {
  return (
    <ApolloProvider client={client}>
      <UsersList />
      <CreateUserForm />
    </ApolloProvider>
  );
}

// クエリの例
const GET_USERS = gql`
  query GetUsers {
    users {
      id
      name
      email
      posts {
        id
        title
      }
    }
  }
`;

function UsersList() {
  const { loading, error, data } = useQuery(GET_USERS);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div>
      {data.users.map(user => (
        <div key={user.id}>
          <h3>{user.name}</h3>
          <p>{user.email}</p>
          <ul>
            {user.posts.map(post => (
              <li key={post.id}>{post.title}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
}
```

### 3. Mutation の例

```javascript
const CREATE_USER = gql`
  mutation CreateUser($name: String!, $email: String!) {
    createUser(name: $name, email: $email) {
      id
      name
      email
    }
  }
`;

function CreateUserForm() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [createUser, { loading, error, data }] = useMutation(CREATE_USER);

  const handleSubmit = (e) => {
    e.preventDefault();
    createUser({
      variables: { name, email },
      // キャッシュを更新してリストを再描画
      refetchQueries: [{ query: GET_USERS }],
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        placeholder="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />
      <button type="submit" disabled={loading}>
        {loading ? 'Creating...' : 'Create User'}
      </button>
      {error && <p>Error: {error.message}</p>}
      {data && <p>User created: {data.createUser.name}</p>}
    </form>
  );
}
```

### 4. カスタムフックを使用

```javascript
import { useState, useEffect } from 'react';

function useGraphQL(query, variables = {}) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetch('http://localhost:3000/graphql', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ query, variables }),
        });
        
        const result = await response.json();
        setData(result.data);
      } catch (err) {
        setError(err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [query, variables]);

  return { data, loading, error };
}

// 使用例
function PostsList() {
  const { data, loading, error } = useGraphQL(`
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
  `);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div>
      {data.posts.map(post => (
        <article key={post.id}>
          <h2>{post.title}</h2>
          <p>By: {post.user.name}</p>
          <p>{post.content}</p>
          <div>
            <h4>Comments:</h4>
            {post.comments.map(comment => (
              <div key={comment.id}>
                <strong>{comment.user.name}:</strong> {comment.content}
              </div>
            ))}
          </div>
        </article>
      ))}
    </div>
  );
}
```

## 推奨アプローチ

**Flutter**: `graphql_flutter` パッケージ
**React**: `@apollo/client` ライブラリ

これらの専用ライブラリを使用することで、キャッシュ機能、エラーハンドリング、リアルタイム更新などの高度な機能を簡単に利用できます。

## 必要な依存関係

### Flutter
```yaml
dependencies:
  graphql_flutter: ^5.1.2
  http: ^0.13.5
```

### React
```json
{
  "dependencies": {
    "@apollo/client": "^3.8.0",
    "graphql": "^16.8.0"
  }
}
```