defmodule TestModule do
  import StateMachine

  defstruct state: :new

  state_manager :state do
    event :do_stuff do
      transition from: :new, to: :done
      transition from: [:first, :second], to: :last
    end

    event :change_color do
      transition from: :green, to: :red
      transition from: :green, to: :blue
    end

    event :always_match do
      transition from: {:any}, to: :matched
    end

    state :new do
      transition to: :white, on: :towhite
      transition to: :black, on: :toblack
    end

    state :black do
      transition to: :white, on: :towhite
      transition to: :end,   on: :toend
    end

    state :white do
      transition to: :black, on: :toblack
      transition to: :end,   on: :toend
    end

  end
end


defmodule StateMachineTest do
  use ExUnit.Case
  doctest StateMachine

  test "events change the state when use state macro" do
    {:ok, mod} = %TestModule{state: :black} |> TestModule.towhite

    assert mod.state == :white
  end

  test "events change the state of their structs" do
    {:ok, mod} = %TestModule{state: :new} |> TestModule.do_stuff

    assert mod.state == :done
  end

  test "it picks the first matching transition" do
    {:ok, mod} = %TestModule{state: :green} |> TestModule.change_color

    assert mod.state == :red
  end

  test "it matches a transition from a list" do
    {:ok, mod} = %TestModule{state: :first} |> TestModule.do_stuff

    assert mod.state == :last
  end

end
