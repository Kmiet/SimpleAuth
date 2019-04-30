defmodule AuthServer.Router do
  use Plug.Router

  alias AuthServer.Controllers.OAuthController
  alias AuthServer.Controllers.SignUpController

  plug Plug.Static, at: "/", from: "../layout/build/login_form"

  plug :match
  plug :dispatch

  forward "/oauth", to: OAuthController 

  forward "/signup", to: SignUpController

  get "/" do
    conn
    |> put_resp_header("location", "http://localhost:4000/login")
    |> send_resp(302, "")
  end

  get "/token" do
    res = Token.create(%{
      "sub" => "user",
      "aud" => "client"
    })
    send_resp conn, 200, res
  end

  post "/token" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    with %{"token" => token} <- Jason.decode!(body) do
      with {:ok, claims} <- Token.validate_and_verify(token, %{
        "aud" => "client",
        "sub" => "user",
        "iss" => "https://simpleauth.org"
      }) 
      do
        send_resp conn, 200, Jason.encode!(claims)
      else
        _ -> send_resp conn, 401, "401 Unauthorized"
      end
    else
      _ -> send_resp conn, 400, "400 Bad Message"
    end
  end

  get "/login" do
    send_file(conn, 200, "../layout/build/login_form/index.html")
  end

  match _ do
    send_resp(conn, 404, "")
  end

end