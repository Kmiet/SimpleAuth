defmodule AuthServer.Controllers.SignUpController do
  use Plug.Router

  import Ecto.Query

  alias Db.Repo
  alias Db.Models.User
  alias Cache.EmailConfirmations
  alias Mailer.SignUpEmail

  plug :match
  plug :dispatch

  get "/confirm" do
    with %{:query_params => %{"id" => confirmation_id}} = conn,
      uid when not is_nil(uid) <- EmailConfirmations.get(confirmation_id)
    do
      EmailConfirmations.delete(confirmation_id)
      Repo.update_all(
        (from u in User,
          where: u.id == ^uid), 
        set: [verified_email: true])
      send_file(conn, 200, "priv/assets/other/email_confirmed.html")
    else
      %{} -> send_file(conn, 400, "priv/assets/bad_request.html")
      _ -> send_file(conn, 404, "priv/assets/not_found.html")  
    end
  end

  get "/" do
    form_token = :crypto.strong_rand_bytes(24) |> Base.url_encode64
    conn
    |> Utils.Cookies.put_csrf_cookie(form_token)
    |> put_resp_header("content-type", "text/html")
    |> send_resp(200, EEx.eval_file(
        "priv/assets/login/index.html.eex",
        [csrf_token: form_token]
      ))
  end

  post "/" do
    {:ok, body, conn} = 
      conn
      |> Plug.Conn.read_body
    with {:ok, %{ "csrf_token" => csrf_token, "email" => email, "password" => password }} = Jason.decode(body),
      form_token when not is_nil(form_token) <- Utils.Cookies.fetch_csrf_cookie(conn),
      true <- form_token == csrf_token
    do
      with changeset <- User.changeset(
          %User{}, 
          %{
            :email => email, 
            :password => password
          }
        ),
        {:ok, user_schema} <- Repo.insert(changeset)
      do
        uid = user_schema.id
        confirmation_id = :crypto.strong_rand_bytes(24) |> Base.url_encode64
        EmailConfirmations.insert(confirmation_id, uid)
        Task.start(fn ->
          SignUpEmail.prepare(email, "http://localhost:4000/signup/confirm?id=" <> confirmation_id)
          |> Mailer.deliver
        end)
        conn
        |> Utils.Cookies.delete_csrf_cookie
        |> send_resp(201, "")
      else
        {:error, %{:errors => errors}} -> 
          err = Enum.reduce(errors, %{}, fn {k, v}, acc -> 
            Map.put(acc, k, elem(v, 0))
          end)
          send_resp(conn, 500, Jason.encode!(%{
            "errors" => err
            })
          )
        _ -> send_resp(conn, 500, "Unknown")
      end
    else
      _ -> send_resp(conn, 403, "")
    end
  end

  match _ do
    send_resp(conn, 404, "")
  end
end