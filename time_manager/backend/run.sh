#!/bin/bash 
mix ecto.create
mix ecto.migrate
# Seed the database
mix run priv/repo/seeds.exs
mix deps.compile
mix phx.server