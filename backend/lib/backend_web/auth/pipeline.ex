defmodule BackendWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :backend,
    module: BackendWeb.Auth.Guardian,
    error_handler: BackendWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
