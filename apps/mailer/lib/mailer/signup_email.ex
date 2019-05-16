defmodule Mailer.SignUpEmail do
  import Swoosh.Email

  def prepare(recipent, url_address) do
    new()
    |> to(recipent)
    |> from("noreply@simpleauth.org")
    |> subject("Confirm your email")
    |> text_body("Welcome " <> url_address)
  end
end