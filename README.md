# exkv

A distributed in-memory key/value store that communicates over plain TCP.

- Keys live in named **buckets**, created on demand at runtime.
- Buckets are shared across the cluster - create one on any node, read and write it from every other node.
- Subscribe to a bucket and every put and delete provides notifications in real time.
- Buckets restart automatically if they crash.

Built following the [Elixir "Mix and OTP" guide](https://hexdocs.pm/elixir/introduction-to-mix.html).

## Demo

https://github.com/user-attachments/assets/81d06579-b97d-4d47-9a4e-d22bb2d11151 

## Running

Single node:

```sh
mix deps.get

# listening on port 4050
iex -S mix          
```

A three-node cluster - one block per terminal:

```sh
# terminal 1
export NODES=a@127.0.0.1,b@127.0.0.1,c@127.0.0.1
PORT=4050 iex --name a@127.0.0.1 -S mix

# terminal 2
export NODES=a@127.0.0.1,b@127.0.0.1,c@127.0.0.1
PORT=4051 iex --name b@127.0.0.1 -S mix

# terminal 3
export NODES=a@127.0.0.1,b@127.0.0.1,c@127.0.0.1
PORT=4052 iex --name c@127.0.0.1 -S mix
```

Each node gets the same list, itself included - a node connecting to itself is harmless. `Node.list()` shows the peers.

## Using it

```sh
$ nc 127.0.0.1 4050
CREATE sessions
OK
PUT sessions 8f3a91c2 user_4471
OK
GET sessions 8f3a91c2
user_4471
OK
```

Now connect to a *different* node and read the same data back:

```sh
$ nc 127.0.0.1 4052
GET sessions 8f3a91c2
user_4471
OK
```

`SUBSCRIBE` turns a connection into a live feed of writes to a bucket - useful for cache
invalidation, or watching a rate-limit counter climb:

```sh
$ nc 127.0.0.1 4051
SUBSCRIBE ratelimit
203.0.113.42 SET TO 17
203.0.113.42 SET TO 18
198.51.100.9 DELETED
```

Elixir clients can skip TCP entirely - join the cluster and call `KV.lookup_bucket/1` for a
pid you can talk to directly.

## Protocol

Commands are `\r\n`-terminated. Every command answers `OK`, `NOT FOUND`, or `UNKNOWN COMMAND`.

| Command | Response |
| --- | --- |
| `CREATE <bucket>` | `OK` |
| `PUT <bucket> <key> <value>` | `OK` |
| `GET <bucket> <key>` | value line, then `OK` |
| `DELETE <bucket> <key>` | `OK` |
| `SUBSCRIBE <bucket>` | streams `<key> SET TO <value>` / `<key> DELETED` until closed |

## Configuration

| Variable | Default | Purpose |
| --- | --- | --- |
| `PORT` | `4050` (`4040` in test) | TCP listener |
| `NODES` | none | Comma-separated peers to connect on boot |

## Limitations

>[!WARNING]
> This project is an educational project I built for fun.
> I doubt this warning is even needed, but don't use it, just go use Redis lol
