alias TimeManager.Repo
alias TimeManager.Accounts.User
alias TimeManager.Workingtimes
alias TimeManager.Clock
# import Bycrypt

# Function to insert users
defp insert_user(username, email, password, role) do
  Repo.insert!(%User{
    username: username,
    email: email,
    password_hash: Bcrypt.hash_pwd_salt(password),
    role: role
  })
end

# Insert mock users
insert_user("alice", "alice@example.com", "password123", "user")
insert_user("bob", "bob@example.com", "password456", "manager")
insert_user("charlie", "charlie@example.com", "password789", "user")
insert_user("dave", "dave@example.com", "password101", "user")
insert_user("eve", "eve@example.com", "password202", "manager")

# Function to insert working times
defp insert_working_time(user_id, start_time, end_time) do
  Repo.insert!(%Workingtimes{
    user_id: user_id,
    start: start_time,
    end: end_time
  })
end

# Insert mock working times for each user
insert_working_time(1, ~N[2020-01-01 08:00:00], ~N[2020-01-01 16:00:00])
insert_working_time(1, ~N[2020-01-02 08:00:00], ~N[2020-01-02 16:00:00])
insert_working_time(2, ~N[2020-01-01 08:00:00], ~N[2020-01-01 16:00:00])
insert_working_time(2, ~N[2020-01-02 08:00:00], ~N[2020-01-02 16:00:00])
insert_working_time(3, ~N[2020-01-01 09:00:00], ~N[2020-01-01 17:00:00])
insert_working_time(3, ~N[2020-01-02 09:00:00], ~N[2020-01-02 17:00:00])
insert_working_time(4, ~N[2020-01-01 10:00:00], ~N[2020-01-01 18:00:00])
insert_working_time(4, ~N[2020-01-02 10:00:00], ~N[2020-01-02 18:00:00])
insert_working_time(5, ~N[2020-01-01 11:00:00], ~N[2020-01-01 19:00:00])
insert_working_time(5, ~N[2020-01-02 11:00:00], ~N[2020-01-02 19:00:00])

# Function to insert clocks
defp insert_clock(user_id, time, status) do
  Repo.insert!(%Clock{
    user_id: user_id,
    time: time,
    status: status
  })
end

# Insert mock clocks for each user
insert_clock(1, ~N[2020-01-01 08:00:00], true)
insert_clock(1, ~N[2020-01-02 08:00:00], true)
insert_clock(2, ~N[2020-01-01 08:00:00], true)
insert_clock(2, ~N[2020-01-02 08:00:00], true)
insert_clock(3, ~N[2020-01-01 09:00:00], true)
insert_clock(3, ~N[2020-01-02 09:00:00], true)
insert_clock(4, ~N[2020-01-01 10:00:00], true)
insert_clock(4, ~N[2020-01-02 10:00:00], true)
insert_clock(5, ~N[2020-01-01 11:00:00], true)
insert_clock(5, ~N[2020-01-02 11:00:00], true)
