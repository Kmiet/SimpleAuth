defmodule Utils.Plugs.SessionPlug do
  use Plug.Builder

  import Plug.Conn

  alias Cache.Sessions

  def init([]), do: false
  def call(conn, _opts), do: logged_in?(conn)

  def logged_in?(conn) do
    conn = fetch_cookies(conn)
    with id_token when not is_nil(id_token) <- Utils.Cookies.fetch_cookie(conn, "id"),
      {:ok, %{"sid" => session_id, "sub" => sub}} <- Token.validate_and_verify(id_token, %{
        "aud" => "https://simpleauth.org",
        "iss" => "https://simpleauth.org"
      }),
      session_data when not is_nil(session_data) <- Sessions.get(session_id)
    do
      conn
      |> assign(:logged_in, true)
      |> assign(:session_id, session_id)
      |> assign(:user_id, sub)
    else
      _ ->
        conn
        |> assign(:logged_in, false)
    end
  end
end