defmodule Utils.Plugs.QueryParamsPlug do
  use Plug.Builder

  def init([]), do: false
  def call(conn, _opts), do: Plug.Conn.fetch_query_params(conn)
end