defmodule KV.Bucket do
  use GenServer

  @doc """
  Starts a new bucket - defines init state
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  @doc """
  Gets a value from the `bucket` by `key`
  """
  def get(bucket, key) do
    GenServer.call(bucket, {:get, key})
  end

  @doc """
  Puts K/V to the bucket
  """
  def put(bucket, k, v) do
    GenServer.call(bucket, {:put, k, v})
  end

  @doc """
  Deletes `k` from `bucket` along with it's associated value.

  Returns the current value of `key` if it exists.
  """
  def delete(bucket, k) do
    GenServer.call(bucket, {:delete, k})
  end

  ### GenServer Callbacks
  @impl true
  def init(bucket) do
    state = %{
      bucket: bucket
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    value = get_in(state.bucket[key])
    {:reply, value, state}
  end

  def handle_call({:put, key, value}, _from, state) do
    state = put_in(state.bucket[key], value)
    {:reply, :ok, state}
  end

  def handle_call({:delete, key}, _from, state) do
    {value, state} = pop_in(state.bucket[key])
    {:reply, value, state}
  end
    

  
end
