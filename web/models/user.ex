defmodule Asciinema.User do
  use Asciinema.Web, :model
  alias Asciinema.User

  schema "users" do
    field :username, :string
    field :temporary_username, :string
    field :email, :string
    field :name, :string
    field :auth_token, :string
    field :theme_name, :string
    field :asciicasts_private_by_default, :boolean, default: true

    timestamps(inserted_at: :created_at)

    has_many :asciicasts, Asciinema.Asciicast
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :username, :auth_token, :theme_name, :asciicasts_private_by_default])
    |> validate_required([:auth_token])
  end

  def temporary_changeset(temporary_username) do
    %User{}
    |> change(%{temporary_username: temporary_username})
    |> generate_auth_token
  end

  defp generate_auth_token(changeset) do
    put_change(changeset, :auth_token, Crypto.random_token(20))
  end
end
