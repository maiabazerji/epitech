defmodule TimeManagerWeb.ChartControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.ClocksFixtures

  alias TimeManager.Clocks.Chart

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all charts", %{conn: conn} do
      conn = get(conn, ~p"/api/charts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create chart" do
    test "renders chart when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/charts", chart: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/charts/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/charts", chart: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update chart" do
    setup [:create_chart]

    test "renders chart when data is valid", %{conn: conn, chart: %Chart{id: id} = chart} do
      conn = put(conn, ~p"/api/charts/#{chart}", chart: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/charts/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, chart: chart} do
      conn = put(conn, ~p"/api/charts/#{chart}", chart: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete chart" do
    setup [:create_chart]

    test "deletes chosen chart", %{conn: conn, chart: chart} do
      conn = delete(conn, ~p"/api/charts/#{chart}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/charts/#{chart}")
      end
    end
  end

  defp create_chart(_) do
    chart = chart_fixture()
    %{chart: chart}
  end
end
