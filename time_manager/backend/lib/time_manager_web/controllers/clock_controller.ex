defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, params) do
    clocks = Clocks.list_clocks(params)
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    clock_params = Map.put(clock_params, "user_id", conn.params["userID"])
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def showChartData(conn ) do
    data = Clocks.chart_is_working_users()
    render(conn, :showChartData, data: data)
  end

  def showLastClock(conn, params) do
    clock = Clocks.get_last_clock(params["userID"])
    render(conn, :show, clock: clock)
  end
end
