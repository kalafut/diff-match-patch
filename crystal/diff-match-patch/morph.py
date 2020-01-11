
    def diff_linesToCharsMunge(text):
      """Split a text into an array of strings.  Reduce the texts to a string
      of hashes where each Unicode character represents one line.
      Modifies linearray and linehash through being a closure.

      Args:
        text: String to encode.

      Returns:
        Encoded string.
      """
      chars = []
      # Walk the text, pulling out a substring for each line.
      # text.split('\n') would would temporarily double our memory footprint.
      # Modifying text would create many large strings to garbage collect.
      lineStart = 0
      lineEnd = -1
      while lineEnd < len(text) - 1:
        lineEnd = text.find('\n', lineStart)
        if lineEnd == -1:
          lineEnd = len(text) - 1
        line = text[lineStart:lineEnd + 1]

        if line in lineHash:
          chars.append(chr(lineHash[line]))
        else:
          if len(lineArray) == maxLines:
            # Bail out at 1114111 because chr(1114112) throws.
            line = text[lineStart:]
            lineEnd = len(text)
          lineArray.append(line)
          lineHash[line] = len(lineArray) - 1
          chars.append(chr(len(lineArray) - 1))
        lineStart = lineEnd + 1
      return "".join(chars)

    # Allocate 2/3rds of the space for text1, the rest for text2.
    maxLines = 666666
    chars1 = diff_linesToCharsMunge(text1)
    maxLines = 1114111
    chars2 = diff_linesToCharsMunge(text2)
    return (chars1, chars2, lineArray)
