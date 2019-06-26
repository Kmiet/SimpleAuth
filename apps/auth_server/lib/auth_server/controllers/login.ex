defmodule AuthServer.Controllers.LogInController do
  use Plug.Router

  plug Plug.Static, at: "/", from: "priv/assets/login" 

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> handle_login
  end

  defp handle_login(%{:query_params => %{"client_id" => _client_id, "grant_type" => _grant_type, "redirect_uri" => _redirect_uri, "state" => _state}} = conn) do
    with true <- conn.assigns[:logged_in] do
      conn
      |> put_resp_header("location", "http://localhost:4000/oauth/authorize?" <> conn.query_string)
      |> send_resp(302, "")
    else
      _ -> send_login_form(conn)
    end
  end

  defp handle_login(%{:query_string => ""} = conn) do
    with true <- conn.assigns[:logged_in] do
      conn
      |> put_resp_header("location", "http://localhost:4000/")
      |> send_resp(302, "")
    else
      _ -> send_login_form(conn)
    end
  end

  defp handle_login(conn) do
    conn
    |> send_file(400, "priv/assets/bad_request.html")
  end

  match _ do
    send_file(conn, 404, "priv/assets/not_found.html") 
  end
  
  # Helpers

  defp send_login_form(conn) do
    form_token = :crypto.strong_rand_bytes(24) |> Base.url_encode64
    conn
    |> Utils.Cookies.put_csrf_cookie(form_token)
    |> put_resp_header("content-type", "text/html")
    |> send_resp(200, EEx.eval_file(
        "priv/assets/login/index.html.eex",
        [csrf_token: form_token]
      ))
  end
end