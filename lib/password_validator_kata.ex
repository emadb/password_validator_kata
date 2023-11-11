defmodule PasswordValidatorKata do

  def validate(pwd) do
    String.length(pwd) > 8
    && Regex.match?(~r/[A-Z]+/, pwd)
    && Regex.match?(~r/[a-z]+/, pwd)
    && Regex.match?(~r/[0-9]+/, pwd)
    && String.contains?(pwd, "_")
  end

  def more_than_8_chars() do
    fn pwd ->
      if String.length(pwd) > 8,
        do: {:ok, ""},
        else: {:error, "Password must be at least 8 chars"}
    end
  end

  def contains_a_capital_letter() do
    fn pwd ->
      if Regex.match?(~r/[A-Z]+/, pwd),
        do: {:ok, ""},
        else: {:error, "Password must contains a capital letter"}
    end
  end

  def contains_a_lowercase_letter() do
    fn pwd ->
      if Regex.match?(~r/[a-z]+/, pwd),
        do: {:ok, ""},
        else: {:error, "Password must contains a lowercase letter"}
      end
  end

  def contains_a_number() do
    fn pwd ->
      if Regex.match?(~r/[0-9]+/, pwd),
        do: {:ok, ""},
        else: {:error, "Password must contains a number"}
    end
  end

  def contains_an_underscore() do
    fn pwd ->
      if String.contains?(pwd, "_"),
        do: {:ok, ""},
        else: {:error, "Password must contains an underscore"}
      end
  end

  def build([]), do: fn _ -> true end
  def build(rules) do
    fn pwd ->
      pwd
      |> apply_rules(rules, [])
      |> build_result({:ok, []})
    end
  end

  defp apply_rules(_, [], errs), do: errs
  defp apply_rules(pwd, [rule | t], errs) do
    res = rule.(pwd)
    apply_rules(pwd, t, [res | errs])
  end

  def build_result([], res), do: res
  def build_result([{:ok, ""} | tail], acc), do: build_result(tail, acc)
  def build_result([{:error, msg} | tail], {_, err_list}), do: build_result(tail, {:error, [msg | err_list]})

end
