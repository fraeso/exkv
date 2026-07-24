defmodule KV.Bucket do
  use Agent

  @doc """
  Starts a new bucket - defines init state
  """
  def start_link(opts) do
    Agent.start_link(fn -> %{} end, opts)
  end

  @doc """
  Gets a value from the `bucket` by `key`
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts K/V to the bucket
  """
  def put(bucket, k, v) do
    Agent.update(bucket, &Map.put(&1, k, v))
  end

  @doc """
  Deletes `k` from `bucket` along with it's associated value.
  
  Returns the current value of `key` if it exists.
  """
  def delete(bucket, k) do
    Agent.get_and_update(bucket, &Map.pop(&1, k))
  end
end
