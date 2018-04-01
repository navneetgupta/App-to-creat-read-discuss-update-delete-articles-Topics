defmodule Discuss.AuthController do
  use Discuss.Web, :controller

  plug Ueberauth
  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn,%{"provider" => provider} = params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: provider}
    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome Back")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error Signing In")
        |> redirect(to: topic_path(conn, :index))
    end
  end
  defp insert_or_update(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
       nil ->
          Repo.insert(changeset)
       user -> {:ok, user}
    end
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Successfully Signed Out")
    |> redirect(to: topic_path(conn, :index))
  end
end
