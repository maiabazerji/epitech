defmodule TimeManagerWeb.ChartController do
  use TimeManagerWeb, :controller

  alias TimeManager.Clocks

  action_fallback TimeManagerWeb.FallbackController

  def showChartData(conn, _params) do
    data = Clocks.chart_is_working_users()
    render(conn, :showChartData, data: data)
  end

  def showHoursWorkedLastWeek(conn, params) do
    data = Clocks.chart_hours_worked_last_week(params["userID"])
    render(conn, :showHoursWorkedLastWeek, data: data)
  end
end
