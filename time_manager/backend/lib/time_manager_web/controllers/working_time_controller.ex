defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Working
  alias TimeManager.Working.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, params) do
    workingtime = Working.list_workingtime(params)
    render(conn, :index, workingtime: workingtime)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    working_time_params = Map.put(working_time_params, "user_id", conn.params["userID"])
    with {:ok, %WorkingTime{} = working_time} <- Working.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Working.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Working.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Working.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Working.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Working.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
