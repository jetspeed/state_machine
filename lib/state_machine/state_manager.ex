defmodule StateMachine.StateManager do
  @moduledoc """
  Helpers used by the `state_manager` macro in `StateMachine` module.

  These methods should not be invoked directly.
  """

  def handle_event(struct, property, transitions) do
    current_state = Map.get(struct, property)

    case find_legal_transition(transitions, current_state) do
      {_, target} -> {:ok, Map.put(struct, property, target)}
      nil         -> :error
    end
  end

  def handle_state(struct, property, transitions) do
    current_state = Map.get(struct, property)

    case find_legal_transition(transitions, current_state) do
      {_, target} -> {:ok, Map.put(struct, property, target)}
      nil         -> :error
    end
  end



  def can_handle_event?(struct, property, transitions) do
    current_state = Map.get(struct, property)

    case find_legal_transition(transitions, current_state) do
      {_, target} -> true
      nil         -> false
    end
  end

  def handle_event!(struct, property, transitions) do
    case handle_event(struct, property, transitions) do
      {:ok, struct} -> struct
      :error        -> raise StateMachine.InvalidTransitionError
    end
  end

  defp find_legal_transition(transitions, target) do
    transitions |> Enum.reverse |> Enum.find fn
      {{:any}, _}                      -> true
      {states, _} when is_list(states) -> target in states
      {state, _}                       -> state == target
      _                                -> false
    end
  end
end
