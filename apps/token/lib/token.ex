defmodule Token do
  use Joken.Config

  def token_config(exp) do
    default_claims(skip: [:jti, :nbf], default_exp: exp)
    |> add_claim("iss", fn -> "https://simpleauth.org" end)
    |> add_claim("auth_time", fn -> Joken.current_time end)
  end

  def create(claims, exp \\ 900) do
    signer = Cache.Keys.get_signer
    token_config(exp)
    |> Joken.generate_and_sign!(claims, signer)
  end

  def validate_and_verify(token, context) do
    with {:ok, %{"kid" => key_id}} = Joken.peek_header(token),
      signer when not is_nil(signer) <- Cache.Keys.get(key_id),
      {:ok, %{"exp" => exp}=claims} = Joken.verify(token, signer),
      false <- expired?(exp) 
    do
      Map.merge(claims, context)
      |> Map.equal?(claims)
      |> if(do: {:ok, claims}, else: {:error})
    else
      err -> err
    end
  end

  defp expired?(exp) do
    Joken.current_time >= exp 
  end
end
