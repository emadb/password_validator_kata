defmodule PasswordValidatorKata do

  def validate(pwd) do
    String.length(pwd) > 8
    && Regex.match?(~r/[A-Z]+/, pwd)
    && Regex.match?(~r/[a-z]+/, pwd)
    && Regex.match?(~r/[0-9]+/, pwd)
    && String.contains?(pwd, "_")
  end

  def more_than_8_chars() do
    fn pwd -> String.length(pwd) > 8 end
  end

  def contains_a_capital_letter() do
    fn pwd -> Regex.match?(~r/[A-Z]+/, pwd) end
  end

  def contains_a_lowercase_letter() do
    fn pwd -> Regex.match?(~r/[a-z]+/, pwd) end
  end

  def contains_a_number() do
    fn pwd -> Regex.match?(~r/[0-9]+/, pwd) end
  end

  def contains_an_underscore() do
    fn pwd -> String.contains?(pwd, "_") end
  end

  def build([]), do: fn _ -> true end
  def build(rules) do
    fn pwd ->
      apply_rules(pwd, rules)
    end
  end

  def apply_rules(_, []), do: true
  def apply_rules(pwd, [rule | t]) do
    apply_rules(pwd, t) && rule.(pwd)
  end


end
