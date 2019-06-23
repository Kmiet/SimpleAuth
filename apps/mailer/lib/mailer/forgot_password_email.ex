defmodule Mailer.ForgotPasswordEmail do
  import Swoosh.Email

  def prepare(recipient, url_address) do
    new()
    |> to(recipient)
    |> from("noreply@simpleauth.org")
    |> subject("Forgot Password")
    |> text_body("Reset your password here: " <> url_address)
  end
end