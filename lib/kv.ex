defmodule KV do
  use Application

  @impl true
  def start(_start_type, _start_args) do
    children = [
      {Registry, keys: :unique, name: KV.Registry}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: KV.Supervisor)
  end
end
