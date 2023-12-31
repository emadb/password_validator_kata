defmodule PasswordValidatorKata do
  def validate(pwd) do
    String.length(pwd) > 8 &&
      Regex.match?(~r/[A-Z]+/, pwd) &&
      Regex.match?(~r/[a-z]+/, pwd) &&
      Regex.match?(~r/[0-9]+/, pwd) &&
      String.contains?(pwd, "_")
  end

  def more_than_8_chars() do
    build_validator(&(String.length(&1) > 8), "Password must be at least 8 chars")
  end

  def contains_a_capital_letter() do
    build_validator(&Regex.match?(~r/[A-Z]+/, &1), "Password must contains a capital letter")
  end

  def contains_a_lowercase_letter() do
    build_validator(&Regex.match?(~r/[a-z]+/, &1), "Password must contains a lowercase letter")
  end

  def contains_a_number() do
    build_validator(&Regex.match?(~r/[0-9]+/, &1), "Password must contains a number")
  end

  def contains_an_underscore() do
    build_validator(&String.contains?(&1, "_"), "Password must contains an underscore")
  end

  defp build_validator(exp, message) do
    fn pwd ->
      case exp.(pwd) do
        true -> {:ok, ""}
        false -> {:error, message}
      end
    end
  end

  def build([]), do: fn _ -> true end

  def build(rules) do
    fn pwd ->
      pwd
      |> apply_rules(rules, [])
      |> build_res({:ok, []})
      |> relax_constraint()
    end
  end

  defp relax_constraint({:error, [err]}), do: {:ok, [err]}
  defp relax_constraint(res), do: res

  defp apply_rules(_, [], errs), do: errs
  defp apply_rules(pwd, [rule | t], errs), do: apply_rules(pwd, t, [rule.(pwd) | errs])

  def build_res([], res), do: res
  def build_res([{:ok, ""} | tail], acc), do: build_res(tail, acc)

  def build_res([{:error, msg} | tail], {_, err_list}),
    do: build_res(tail, {:error, [msg | err_list]})
end
