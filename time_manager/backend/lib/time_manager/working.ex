defmodule TimeManager.Working do
  @moduledoc """
  The Working context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Working.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtime(params) do

    query = from w in WorkingTime,
      where: w.user_id == ^params["userID"]

    query = if params["start"] do
      {:ok, start_date} = Date.from_iso8601(params["start"])
      {:ok, start_date_time} = NaiveDateTime.from_iso8601("#{Date.to_string(start_date)}T00:00:00Z")
      where(query, [w], w.start >= ^start_date_time)
    else
      query
    end

    query = if params["end"] do
      {:ok, end_date} = Date.from_iso8601(params["end"])
      {:ok, end_date_time} = NaiveDateTime.from_iso8601("#{Date.to_string(end_date)}T23:59:59Z")
      where(query, [w], w.end <= ^end_date_time)
    else
      query
    end

    Repo.all(query)
  end

  def get_working_time!(userID, id) do
    query = from w in WorkingTime,
      where: w.id == ^id,
      where: w.user_id == ^userID,
      select: w
     Repo.one(query)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
