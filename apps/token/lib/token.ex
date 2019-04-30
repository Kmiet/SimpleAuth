defmodule Token do
  use Joken.Config

  @impl Joken.Config
  def token_config do
    default_claims(skip: [:jti, :nbf], default_exp: 12 * 3600)
    |> add_claim("iss", fn -> "https://simpleauth.org" end)
  end

  def create(claims) do
    signer = Cache.Keys.get_signer
    token_config
    |> Joken.generate_and_sign!(claims, signer)
  end

  def validate_and_verify(token, context) do
    with {:ok, %{"kid" => key_id}} = Joken.peek_header(token),
      signer when not is_nil(signer) <- Cache.Keys.get(key_id),
      {:ok, claims} = Joken.verify(token, signer) 
    do
      Map.merge(claims, context)
      |> Map.equal?(claims)
      |> if(do: {:ok, claims}, else: {:error})
    else
      err -> err
    end
  end
end
