defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  test "stores values by key" do
    {:ok, bucket} = KV.Bucket.start_link([])
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "stores values by key on a named process", config do
    test_uuid = "1386279e-d508-4de0-a25c-e8aedbe83d2b"

    {:ok, _} = KV.Bucket.start_link(name: config.test)
    assert KV.Bucket.get(config.test, test_uuid) == nil

    KV.Bucket.put(config.test, test_uuid, true)
    assert KV.Bucket.get(config.test, test_uuid) == true

    KV.Bucket.put(config.test, test_uuid, false)
    assert KV.Bucket.get(config.test, test_uuid) == false
  end
end
