FROM elixir:1.17.3-otp-27

RUN apt-get update && apt-get install -y postgresql 
    # && apt-get install -y ntpdate

# RUN ntpdate pool.ntp.org

WORKDIR /app

COPY . .

RUN mix local.hex --force 
    # mix local.rebar --force

# RUN mix archive.install hex phx_new 1.5.12 --force


RUN mix deps.get 

EXPOSE 4000
# run run.sh
CMD ["sh", "run.sh"]