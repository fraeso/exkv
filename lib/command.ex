defmodule KV.Command do
  @doc """
  Runs the given command
  """
  def run(command, socket) do
    :gen_tcp.send(socket, "OK\r\n")
    :ok
  end

  @doc ~S"""
  Parses the given `line` into a command

  ## Examples

    iex> KV.Command.parse "CREATE namespace\r\n"
    {:ok, {:create, "namespace"}}

    iex> KV.Command.parse "CREATE namespace \r\n"
    {:ok, {:create, "namespace"}}

    iex> KV.Command.parse "PUT namespace key value\r\n"
    {:ok, {:put, "namespace", "key", "value"}}

    iex> KV.Command.parse "GET namespace key\r\n"
    {:ok, {:get, "namespace", "key"}}

    iex> KV.Command.parse "DELETE namespace key\r\n"
    {:ok, {:delete, "namespace", "key"}}

  Unknown commands or commands with the wrong number of
  arguments return an error:

    iex> KV.Command.parse "UNKNOWN arg1 arg2\r\n"
    {:error, :unknown_command}

    iex> KV.Command.parse "GET namespace\r\n"
    {:error, :unknown_command}

  """
  def parse(line) do
    case String.split(line) do
      ["CREATE", namespace] ->
        {:ok, {:create, namespace}}

      ["GET", namespace, key] ->
        {:ok, {:get, namespace, key}}

      ["PUT", namespace, key, value] ->
        {:ok, {:put, namespace, key, value}}

      ["DELETE", namespace, key] ->
        {:ok, {:delete, namespace, key}}

      _invalid ->
        {:error, :unknown_command}
    end
  end
end
