defmodule TimekeepWeb.Router do
  use TimekeepWeb, :router

  import TimekeepWeb.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TimekeepWeb do
    pipe_through [:api, :fetch_current_user, :require_authenticated_user]

    resources "/counters", CounterController do
      resources "/sessions", SessionController
      post "/sessions/start", SessionController, :start
      post "/sessions/stop", SessionController, :stop
      get "/trackers", CounterController, :tracker
    end

    get "/users/me", UserController, :show
    patch "/users/me", UserController, :update
    delete "/users/me", UserController, :delete
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timekeep, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimekeepWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
