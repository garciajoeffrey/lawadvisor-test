defmodule Lawadvisor.Utility do
  @moduledoc """
  The Utility context.
  """

  def transform_error_message(%{valid?: false} = changeset) do
    errors = Enum.map(changeset.errors, fn({key, {message, _}}) ->
      %{key => transform_message(key, message)}
    end)

    Enum.reduce(errors, fn(head, tail) ->
      Map.merge(head, tail)
    end)
  end
  def transform_error_message(_changeset), do: "Error encountered. PLease try again."

  defp transform_message(:task_no, "is invalid"), do: "Task number is invalid"
  defp transform_message(:new_task_no, "is invalid"), do: "New task number is invalid"
  defp transform_message(_key, message), do: message

  def is_valid_changeset?(%{valid?: false} = changeset), do: {:error, changeset}
  def is_valid_changeset?(%{changes: changes}), do: changes
  def is_valid_changeset?(_changeset), do: :invalid

  def struct_to_map(struct, fields) do
    struct
    |> Map.from_struct()
    |> Map.take(fields)
    |> Enum.into(%{}, fn {key, val} -> {Atom.to_string(key), val} end)
  end

end