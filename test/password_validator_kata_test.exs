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

  test "Rule: Have more than 8 characters" do
    rule = PasswordValidatorKata.more_than_8_chars()
    assert rule.("pwd_with_more_than_eight_chars")
    refute rule.("pwd")
  end

  test "Rule: Contains a capital letter" do
    rule = PasswordValidatorKata.contains_a_capital_letter()
    assert rule.("pWd")
    refute rule.("pwd")
  end

  test "Rule: Contains a lowercase letter" do
    rule = PasswordValidatorKata.contains_a_lowercase_letter()
    assert rule.("pW")
    refute rule.("PW")
  end

  test "Rule: Contains a number" do
    rule = PasswordValidatorKata.contains_a_number()
    assert rule.("8")
    refute rule.("P")
  end

  test "Rule: Contains an underscore" do
    rule = PasswordValidatorKata.contains_an_underscore()
    assert rule.("_")
    refute rule.("P")
  end

  test "build a password validator with no rules" do
    validator = PasswordValidatorKata.build([])
    assert validator.("pwd")
  end

  test "build a password validator with one rule" do
    rule = PasswordValidatorKata.more_than_8_chars()
    validator = PasswordValidatorKata.build([rule])
    assert validator.("pwd_with_more_than_eight_chars")
    refute validator.("short")
  end

  test "build a password validator with two rules" do
    rule1 = PasswordValidatorKata.more_than_8_chars()
    rule2 = PasswordValidatorKata.contains_a_capital_letter()
    validator = PasswordValidatorKata.build([rule1, rule2])

    assert validator.("Pwd_with_more_than_eight_chars")
    refute validator.("short")
    refute validator.("pwd_with_more_than_eight_chars")
  end

  test "build a password validator with three rules" do
    rule1 = PasswordValidatorKata.more_than_8_chars()
    rule2 = PasswordValidatorKata.contains_a_capital_letter()
    rule3 = PasswordValidatorKata.contains_an_underscore()
    validator = PasswordValidatorKata.build([rule1, rule2, rule3])

    assert validator.("Pwd_with_more_than_eight_chars")
    refute validator.("short_")
    refute validator.("pwd_with_more_than_eight_chars")
    refute validator.("pwd-with-more-than-eight-chars")
  end
end
