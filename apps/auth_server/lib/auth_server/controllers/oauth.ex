defmodule AuthServer.Controllers.OAuthController do
  use Plug.Router

  alias Db.Repo
  alias Db.Models.{Client, ClientUser, User}

  plug :match
  plug :dispatch

  get "/authorize" do
    conn = Plug.Conn.fetch_query_params(conn)
    |> handle_authorize
  end

  defp handle_authorize(%{:query_params => %{"client_id" => _, "grant_type" => _, "redurect_uri" => _, "state" => _}} = conn) do
    send_resp conn, 200, "OAuth authorize"
  end

  defp handle_authorize(%{:query_params => %{"client_id" => _, "grant_type" => _, "redirect_uri" => _}} = conn) do
    send_resp conn, 400, "State param is missing"
  end

  defp handle_authorize(%{:query_params => %{"client_id" => _, "grant_type" => _}} = conn) do
    send_resp conn, 400, "RedirectURI param is missing"
  end

  defp handle_authorize(%{:query_params => %{"client_id" => _}} = conn) do
    send_resp conn, 400, "GrantType param is missing"
  end

  defp handle_authorize(conn) do
    send_resp conn, 400, "ClientID param is missing"
  end
end