require "./spec_helper"
require "../src/diff-match-patch"

describe DiffMatchPatch do
  # TODO: Write tests

  it "testDiffCommonPrefix" do
    dmp = DiffMatchPatch.new
    # Detect any common prefix.
    # Null case.
    dmp.diff_commonPrefix("abc", "xyz").should eq(0)

    dmp.diff_commonPrefix("1234abcdef", "1234xyz").should eq(4)
    dmp.diff_commonPrefix("1234", "1234xyz").should eq(4)
  end

  it "calculates common suffix" do
    dmp = DiffMatchPatch.new
    # Detect any common suffix.
    # Null case.
    dmp.diff_commonSuffix("abc", "xyz").should eq(0)

    # Non-null case.
    dmp.diff_commonSuffix("abcdef1234", "xyz1234").should eq (4)

    # Whole case.
    dmp.diff_commonSuffix("1234", "xyz1234").should eq (4)
  end

  it "testDiffLinesToChars" do
    dmp = DiffMatchPatch.new
    # Convert lines down to characters.
    dmp.diff_linesToChars("alpha\nbeta\nalpha\n", "beta\nalpha\nbeta\n").should eq({"\x01\x02\x01", "\x02\x01\x02", ["", "alpha\n", "beta\n"]})
    dmp.diff_linesToChars("", "alpha\r\nbeta\r\n\r\n\r\n").should eq({"", "\x01\x02\x03\x03", ["", "alpha\r\n", "beta\r\n", "\r\n"]})
    dmp.diff_linesToChars("a", "b").should eq({"\x01", "\x02", ["", "a", "b"]})

    # More than 256 to reveal any 8-bit limitations.
    n = 300
    lineList = [] of String
    charList = [] of Char
    (1...n + 1).each do |i|
      lineList << "#{i}\n"
      charList << i.chr
    end

    n.should eq(lineList.size)
    lines = lineList.join
    chars = charList.join
    n.should eq(chars.size)
    lineList.insert(0, "")
    dmp.diff_linesToChars(lines, "").should eq({chars, "", lineList})
  end
end
