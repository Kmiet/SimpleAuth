defmodule Utils.Cookies do
  import Plug.Conn

  @csrf_cookie_key "ftk"

  def fetch_cookie(%{:req_cookies => cookies} = _conn, key) do
    cookies
    |> Map.get(key)
  end

  def delete_csrf_cookie(conn) do
    conn
    |> delete_resp_cookie(@csrf_cookie_key, [http_only: true]) #, secure: true])
  end

  def fetch_csrf_cookie(%{:req_cookies => cookies} = _conn) do
    cookies
    |> Map.get(@csrf_cookie_key)
  end

  def put_csrf_cookie(conn, form_token) do
    conn
    |> put_resp_cookie(@csrf_cookie_key, form_token, [http_only: true]) #,secure: true])
  end
end