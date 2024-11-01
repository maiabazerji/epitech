defmodule TimeManager.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(params) do
    query = User
    query = if params["email"] do
      from u in query, where: u.email == ^params["email"]
    else
      query
    end
    query = if params["username"] do
      from u in query, where: u.username == ^params["username"]
    else
      query
    end
    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_user_role(%User{} = user, new_role) when new_role in ["user", "manager", "admin", "super_admin"] do
    user
    |> User.changeset(%{role: new_role})
    |> Repo.update()
  end

  def list_users_by_role(role) do
    User
    |> where([u], u.role == ^role)
    |> Repo.all()
  end

  def is_admin?(%User{role: role}) do
    role in ["admin", "super_admin"]
  end

  def is_manager?(%User{role: role}) do
    role in ["manager", "admin", "super_admin"]
  end
end
