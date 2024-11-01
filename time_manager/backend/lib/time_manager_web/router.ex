
defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TimeManagerWeb.AuthPipeline
  end

  # Public routes
  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/register", AuthController, :register
    post "/login", AuthController, :login
    post "/logout", AuthController, :logout
  end

  # Private routes
  scope "/api", TimeManagerWeb do
    # Auth pipeline added to check JWT in this scope
    pipe_through [:api, :auth]

    # Users
    resources "/users", UserController, except: [:new, :edit]

    # WorkingTime
    scope "/workingtime" do
      get "/:userID", WorkingTimeController, :index
      get "/:userID/:id", WorkingTimeController, :one
      post "/:userID", WorkingTimeController, :create
      delete  "/:id", WorkingTimeController, :delete
      put "/:id", WorkingTimeController, :update
    end

    # Clocks
    scope "/clocks" do
      get "/:userID", ClockController, :show
      get "/:userID/last", ClockController, :showLastClock
      post "/:userID", ClockController, :create
    end

    # Manager
    scope "/manager" do
      get "/:manager_id/teams", TeamController, :showMyTeams
    end

    # Chart
    scope "/chartManager" do
      get "/is_working/users", ChartController, :showChartData
      get "/:userID", ChartController, :showHoursWorkedLastWeek
    end

    # Teams
    resources "/teams", TeamController, except: [:new, :edit]
    post "/teams/:id/add_member/:user_id", TeamController, :add_member
    post "/teams/:id/remove_member/:user_id", TeamController, :remove_member
  end
end
