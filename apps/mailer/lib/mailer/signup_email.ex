defmodule Mailer.SignUpEmail do
  import Swoosh.Email

  def prepare(recipient, url_address) do
    new()
    |> to(recipient)
    |> from("noreply@simpleauth.org")
    |> subject("Confirm your email")
    |> text_body("Welcome " <> url_address)
  end
end