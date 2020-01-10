require "./spec_helper"
require "../src/diff-match-patch"

describe DiffMatchPatch do
  # TODO: Write tests

  it "testDiffCommonPrefix" do
    dmp = DiffMatchPatch::DiffMatchPatch.new
    # Detect any common prefix.
    # Null case.
    dmp.diff_commonPrefix("abc", "xyz").should eq(0)

    dmp.diff_commonPrefix("1234abcdef", "1234xyz").should eq(4)
    dmp.diff_commonPrefix("1234", "1234xyz").should eq(4)
  end

  it "calculates common suffix" do
    dmp = DiffMatchPatch::DiffMatchPatch.new
    # Detect any common suffix.
    # Null case.
    dmp.diff_commonSuffix("abc", "xyz").should eq(0)

    # Non-null case.
    dmp.diff_commonSuffix("abcdef1234", "xyz1234").should eq (4)

    # Whole case.
    dmp.diff_commonSuffix("1234", "xyz1234").should eq (4)
  end
end
