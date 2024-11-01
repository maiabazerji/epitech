#!/bin/bash 
mix ecto.create
mix ecto.migrate
mix deps.compile
mix phx.server