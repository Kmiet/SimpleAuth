defmodule AuthServer.Router do
  use Plug.Router

  alias Cache.AuthCodes
  alias Utils.Plugs.{QueryParamsPlug, SessionPlug}
  alias AuthServer.Controllers.{ForgotPasswordController, LogInController, OAuthController, SignUpController}

  plug Plug.Static, at: "/", from: "./priv/assets/login" # from: "../layout/build/login_form"

  plug QueryParamsPlug
  # SessionPlug fetches all cookies into conn stuct
  plug SessionPlug

  plug :match
  plug :dispatch

  forward "/oauth", to: OAuthController 

  forward "/signup", to: SignUpController

  forward "/login", to: LogInController

  forward "/forgot-password", to: ForgotPasswordController

  post "/token" do
    with {:ok, body, conn} <- Plug.Conn.read_body(conn),
      %{
        "code" => code, 
        "client_id" => client_id, 
        "client_secret" => client_secret
      } <- Jason.decode!(body),

      auth_session_data when not is_nil(auth_session_data) <- AuthCodes.get(code),
      {auth_client_id, auth_client_secret, user_scopes, user_id} <- auth_session_data,

      true <- auth_client_id == client_id,
      true <- auth_client_secret == client_secret
    do
      id_token = Token.create(%{
        "aud" => client_id,
        "sub" => user_id,
        "scopes" => user_scopes
      })

      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(%{"id_token" => id_token}))
    else
      _ ->
        conn
        |> send_resp(401, "")
    end
  end

  get "/" do
    with true <- conn.assigns[:logged_in] do
      conn
      |> put_resp_header("content-type", "text/html")
      |> send_file(200, "priv/assets/manager/index.html")
    else
      _ ->
        conn
        |> put_resp_header("location", "http://localhost:4000/login")
        |> send_resp(302, "")
    end
  end

  match _ do
    send_resp(conn, 404, "")
  end

end