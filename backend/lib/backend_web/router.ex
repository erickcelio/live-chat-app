defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  pipeline :auth do
    plug BackendWeb.Auth.Pipeline
  end

  scope "/api", BackendWeb do
    pipe_through(:api)
    post "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin
  end

  scope "/api", BackendWeb do
    pipe_through([:api, :auth])
    patch "/users/update", UserController, :update
    resources "/channels", ChannelController
    resources "/messages", MessageController
  end

  scope "/", BackendWeb do
    pipe_through([:browser, :auth])
    get("/", DefaultController, :index)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: BackendWeb.Telemetry)
    end
  end
end
