require 'spec_helper'
require 'text_util'

describe TextUtil do
  it "convert string to regular expression" do
    str = "Password123"
    regexpr = TextUtil.to_regexpr(str)

    expect(regexpr =~ str).to be_truthy
    expect(regexpr =~ str + "a").to be_falsey
    expect(regexpr =~ "a" + str).to be_falsey
    expect(regexpr =~ "PaswordX123").to be_falsey
    expect(regexpr =~ "P3").to be_falsey
  end
end
