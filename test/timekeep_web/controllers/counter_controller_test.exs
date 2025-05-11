defmodule TimekeepWeb.CounterControllerTest do
  use TimekeepWeb.ConnCase

  import Timekeep.CountersFixtures

  alias Timekeep.Counters.Counter

  @create_attrs %{
    name: "some name",
    period: :daily,
    time_objective: 42
  }
  @update_attrs %{
    name: "some updated name",
    period: :weekly,
    time_objective: 43
  }
  @invalid_attrs %{name: nil, period: nil, time_objective: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all counters", %{conn: conn} do
      conn = get(conn, ~p"/api/counters")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create counter" do
    test "renders counter when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/counters", counter: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/counters/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "period" => "daily",
               "time_objective" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/counters", counter: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update counter" do
    setup [:create_counter]

    test "renders counter when data is valid", %{conn: conn, counter: %Counter{id: id} = counter} do
      conn = put(conn, ~p"/api/counters/#{counter}", counter: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/counters/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "period" => "weekly",
               "time_objective" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, counter: counter} do
      conn = put(conn, ~p"/api/counters/#{counter}", counter: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete counter" do
    setup [:create_counter]

    test "deletes chosen counter", %{conn: conn, counter: counter} do
      conn = delete(conn, ~p"/api/counters/#{counter}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/counters/#{counter}")
      end
    end
  end

  defp create_counter(_) do
    counter = counter_fixture()
    %{counter: counter}
  end
end
