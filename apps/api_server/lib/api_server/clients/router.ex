defmodule ApiServer.ClientsRouter do
  use Plug.Router

  alias Db.Repo
  alias Db.Models.Client

  @client_secret_length 24

  plug :match
  plug :dispatch

  get "/:client_id/stats" do
    with client_data <- Repo.get(Client, "#{client_id}") |> Repo.preload(:owner_id) 
    do
      IO.inspect(client_data)
      conn
      |> send_resp(200, Jason.encode!(client_data))
    else
      _ -> send_resp(conn, 404, "error")
    end
  end

  get "/:client_id" do
    with client_data <- Repo.get(Client, "#{client_id}") |> Repo.preload(:owner_id) 
    do
      IO.inspect(client_data)
      conn
      |> send_resp(200, Jason.encode!(client_data))
    else
      _ -> send_resp(conn, 404, "error")
    end
  end

  put "/:client_id" do
    with client_data <- Repo.get(Client, "#{client_id}") |> Repo.preload(:owner_id) 
    do
      IO.inspect(client_data)
      conn
      |> send_resp(200, Jason.encode!(client_data))
    else
      _ -> send_resp(conn, 404, "error")
    end
  end

  delete "/:client_id" do
    with client_data <- Repo.get(Client, "#{client_id}") |> Repo.preload(:owner_id) 
    do
      IO.inspect(client_data)
      conn
      |> send_resp(200, Jason.encode!(client_data))
    else
      _ -> send_resp(conn, 404, "error")
    end
  end

  get "/" do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, "Clients get")
  end

  post "/" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    with {:ok, %{"login_redirects" => uris, "owner_id" => oid, "user_scopes" => scopes, "name" => name }} <- Jason.decode(body),
      uid <- conn.assigns[:user_id],
      true <- oid == uid,
      client_secret <- :crypto.strong_rand_bytes(24) |> Base.url_encode64,
      changeset <- Client.changeset(
        %Client{}, 
        %{
          :login_redirects => uris,
          :name => name,
          :owner_id => oid,
          :secret => client_secret,
          :user_scopes => scopes
        }
      ),
      {:ok, client_schema} <- Repo.insert(changeset)
    do
      cid = client_schema.id
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(%{
        "client_id" => cid,
        "client_secret" => client_secret
      }))
    else
      {:error, %{:errors => errors}} -> 
        err = Enum.reduce(errors, %{}, fn {k, v}, acc -> 
          Map.put(acc, k, elem(v, 0))
        end)
        send_resp(conn, 400, Jason.encode!(%{
          "errors" => err
        }))
      {:error, %Jason.DecodeError{}} -> send_file(conn, 400, "priv/assets/bad_request.html")
      err ->
        send_file(conn, 403, "priv/assets/forbidden.html") 
    end
  end

  match _ do
    send_resp(conn, 404, "")
  end

end