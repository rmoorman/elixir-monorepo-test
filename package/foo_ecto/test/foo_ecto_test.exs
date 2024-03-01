defmodule FooEctoTest do
  use ExUnit.Case
  doctest FooEcto

  test "greets the world" do
    assert FooEcto.hello() == :world
  end
end
