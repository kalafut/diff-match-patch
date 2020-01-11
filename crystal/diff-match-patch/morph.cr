    # """Split two texts into an array of strings.  Reduce the texts to a string
    # of hashes where each Unicode character represents one line.

    # Args:
    #   text1: First string.
    #   text2: Second string.

    # Returns:
    #   Three element tuple, containing the encoded text1, the encoded text2 and
    #   the array of unique strings.  The zeroth element of the array of unique
    #   strings is intentionally blank.
    # """
  def diff_linesToChars(self, text1, text2):
    lineArray = []  # e.g. lineArray[4] == "Hello\n"
    lineHash = {}   # e.g. lineHash["Hello\n"] == 4

    # "\x00" is a valid character, but various debuggers don't like it.
    # So we'll insert a junk entry to avoid generating a null character.
    lineArray.append('')

    def diff_linesToCharsMunge(text)
      chars = []
      # Walk the text, pulling out a substring for each line.
      # text.split('\n') would would temporarily double our memory footprint.
      # Modifying text would create many large strings to garbage collect.
      lineStart = 0
      lineEnd = -1
      while lineEnd < text.size - 1
        lineEnd = text.find('\n', lineStart)
        if lineEnd == -1
          lineEnd = text.size - 1
        end
        line = text[lineStart..lineEnd + 1]

        if line in lineHash
          chars.append(chr(lineHash[line]))
        else
          if lineArray.size == maxLines
            # Bail out at 1114111 because chr(1114112) throws.
            line = text[lineStart..]
            lineEnd = text.size
          end
          lineArray.append(line)
          lineHash[line] = lineArray.size - 1
          chars.append(chr(lineArray.size - 1))
        end
        lineStart = lineEnd + 1
      end
      return "".join(chars)

    # Allocate 2/3rds of the space for text1, the rest for text2.
    maxLines = 666666
    chars1 = diff_linesToCharsMunge(text1)
    maxLines = 1114111
    chars2 = diff_linesToCharsMunge(text2)
    return (chars1, chars2, lineArray)
