defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller

  alias TimeManager.Users.Auth

  def register(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, user} ->
        {:ok, token, _claims} = TimeManager.Guardian.encode_and_sign(user)
        IO.inspect(token)
        conn
        |> put_status(:created)
        |> render("auth.json", %{jwt: token})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = TimeManager.Guardian.encode_and_sign(user)
        conn
        |> put_status(:ok)
        |> json(%{jwt: token, userid: user.id, email: user.email, username: user.username, role: user.role})
        # |> render("auth.json", %{jwt: token, userid: user.id})
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end

  def logout(conn, _) do
    jwt = Guardian.Plug.current_token(conn)
    Guardian.revoke(TimeManager.Guardian, jwt)
    conn
    |> put_status(:ok)
    |> json(%{ok: true})
  end
end
