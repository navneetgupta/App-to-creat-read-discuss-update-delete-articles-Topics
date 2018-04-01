defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  #init for Doing the setup the plug
  def init(_params) do

  end
  # every time called for any route
  # here _params is value returned from init method. Since we do not have any initiaization work we donot care about params here
  def call(conn, _params) do
    user_id = get_session(conn, "user_id")

    cond do
       user = user_id && Repo.get(User, user_id) ->
         assign(conn, :user, user)
         # conn.assigns.user => user_struct
       true ->
         assign(conn, :user, nil)
    end
  end
end
