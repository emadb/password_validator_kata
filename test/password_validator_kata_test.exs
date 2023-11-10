defmodule PasswordValidatorKataTest do
  use ExUnit.Case
  doctest PasswordValidatorKata

  @valid_password "has_more_than_8_chars_and_One_capital"

  test "The valid password" do
    assert PasswordValidatorKata.validate(@valid_password)
  end

  test "Have more than 8 characters" do
    refute PasswordValidatorKata.validate("short")
  end

  test "Contains a capital letter" do
    refute PasswordValidatorKata.validate("has_more_than_8_chars_but_no_capitals")
  end

  test "Contains a lowercase" do
    refute PasswordValidatorKata.validate("HAS_MORE_THAN_8_CHARS_BUT_NO_LOWERCASE")
  end

  test "Contains a number" do
    refute PasswordValidatorKata.validate("has_more_than eight_chars_and_One_capital_lowercase_chars_nbut_no_numbers")
  end

  test "Contains an underscore" do
    refute PasswordValidatorKata.validate("has-more-than-8-chars-and-One-capital-lowercase-chars")
  end

end
