defmodule PasswordValidatorKata do

  def validate(pwd) do
    String.length(pwd) > 8
    && Regex.match?(~r/[A-Z]+/, pwd)
    && Regex.match?(~r/[a-z]+/, pwd)
    && Regex.match?(~r/[0-9]+/, pwd)
    && String.contains?(pwd, "_")
  end

end
