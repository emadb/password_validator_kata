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
    refute PasswordValidatorKata.validate(
             "has_more_than eight_chars_and_One_capital_lowercase_chars_nbut_no_numbers"
           )
  end

  test "Contains an underscore" do
    refute PasswordValidatorKata.validate("has-more-than-8-chars-and-One-capital-lowercase-chars")
  end

  test "Rule: Have more than 8 characters" do
    rule = PasswordValidatorKata.more_than_8_chars()
    assert rule.("pwd_with_more_than_eight_chars") == {:ok, ""}
    assert rule.("pwd") == {:error, "Password must be at least 8 chars"}
  end

  test "Rule: Contains a capital letter" do
    rule = PasswordValidatorKata.contains_a_capital_letter()
    assert rule.("pWd") == {:ok, ""}
    assert rule.("pwd") == {:error, "Password must contains a capital letter"}
  end

  test "Rule: Contains a lowercase letter" do
    rule = PasswordValidatorKata.contains_a_lowercase_letter()
    assert rule.("pW") == {:ok, ""}
    assert rule.("PW") == {:error, "Password must contains a lowercase letter"}
  end

  test "Rule: Contains a number" do
    rule = PasswordValidatorKata.contains_a_number()
    assert rule.("8") == {:ok, ""}
    assert rule.("P") == {:error, "Password must contains a number"}
  end

  test "Rule: Contains an underscore" do
    rule = PasswordValidatorKata.contains_an_underscore()
    assert rule.("_") == {:ok, ""}
    assert rule.("P") == {:error, "Password must contains an underscore"}
  end

  test "build a password validator with no rules" do
    validator = PasswordValidatorKata.build([])
    assert validator.("pwd")
  end

  test "build a password validator with one rule" do
    rule = PasswordValidatorKata.more_than_8_chars()
    validator = PasswordValidatorKata.build([rule])
    assert validator.("pwd_with_more_than_eight_chars") == {:ok, []}
    assert validator.("short") == {:ok, ["Password must be at least 8 chars"]}
  end

  test "build a password validator with two rules" do
    rule1 = PasswordValidatorKata.more_than_8_chars()
    rule2 = PasswordValidatorKata.contains_a_capital_letter()
    validator = PasswordValidatorKata.build([rule1, rule2])

    assert validator.("Pwd_with_more_than_eight_chars") == {:ok, []}

    assert validator.("short") ==
             {:error,
              ["Password must be at least 8 chars", "Password must contains a capital letter"]}
  end

  test "build a password validator with three rules" do
    rule1 = PasswordValidatorKata.more_than_8_chars()
    rule2 = PasswordValidatorKata.contains_a_capital_letter()
    rule3 = PasswordValidatorKata.contains_an_underscore()
    validator = PasswordValidatorKata.build([rule1, rule2, rule3])

    assert validator.("Pwd_with_more_than_eight_chars") == {:ok, []}

    assert validator.("short_") ==
             {:error,
              ["Password must be at least 8 chars", "Password must contains a capital letter"]}

    assert validator.("pwd_with_more_than_eight_chars") ==
             {:ok, ["Password must contains a capital letter"]}
  end

  test "Relax: build a password validator with three rules" do
    rule1 = PasswordValidatorKata.more_than_8_chars()
    rule2 = PasswordValidatorKata.contains_a_capital_letter()
    rule3 = PasswordValidatorKata.contains_an_underscore()
    validator = PasswordValidatorKata.build([rule1, rule2, rule3])

    assert validator.("pwd_with_more_than_eight_chars_and_underscore") ==
             {:ok, ["Password must contains a capital letter"]}

    assert validator.("S_hort") ==
              {:ok, ["Password must be at least 8 chars"]}
  end
end
