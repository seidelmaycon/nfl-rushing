### Installation and running this solution

#### Dependencies
* [Erlang 23.1.1](https://www.erlang.org/downloads)
* [Elixir 1.11.2](https://elixir-lang.org/install.html)
* [PostgreSQL 10.15+](https://www.postgresql.org/download/)
* [Node 12.19.0+](https://nodejs.org/en/)

- If you use `asdf`, an `asfd install` could be used on the root of this project to install Erlang, Elixir and Node.

#### Instalation

1. Clone this repository: `git clone git@github.com:seidelmaycon/nfl-rushing.git`
2. Go to this folder with `cd nfl-rushing`
3. Fetch the dependencies: `mix deps.get && cd assets && npm install && cd ..`
5. Create the database and run its migrations: `mix ecto.setup`
   - It might take a while the first time to compile the dev app.
   - You could also seed some data with `mix import_players rushing.json`
6. Run the application: `mix phx.server`

Done: app is available in `http://localhost:4000`

#### Tests

There is a mix alias `mix ci` that setup de test database, compile the app, check if the code is formatted and run:
- Unit tests with `ExUnit`
- Coverage report with `ExCoveralls`
- Static code analysis with `credo`
