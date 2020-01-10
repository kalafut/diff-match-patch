# TODO: Write documentation for `Diff::Match::Patch`
module DiffMatchPatch
  VERSION = "0.1.0"

  class DiffMatchPatch
    # Inits a diff_match_patch object with default settings.
    # Redefine these in your program to override the defaults.
    def initialize
      # Number of seconds to map a diff before giving up (0 for infinity).
      @Diff_Timeout = 1.0
      # Cost of an empty edit operation in terms of edit characters.
      @Diff_EditCost = 4
      # At what point is no match declared (0.0 = perfection, 1.0 = very loose).
      @Match_Threshold = 0.5
      # How far to search for a match (0 = exact location, 1000+ = broad match).
      # A match this many characters away from the expected location will add
      # 1.0 to the score (0.0 is a perfect match).
      @Match_Distance = 1000
      # When deleting a large block of text (over ~64 characters), how close do
      # the contents have to be to match the expected contents. (0.0 = perfection,
      # 1.0 = very loose).  Note that Match_Threshold controls how closely the
      # end points of a delete need to match.
      @Patch_DeleteThreshold = 0.5
      # Chunk size for context length.
      @Patch_Margin = 4

      # The number of bits in an int.
      # Python has no maximum, thus to disable patch splitting set to 0.
      # However to avoid long patches in certain pathological cases, use 32.
      # Multiple short patches (using native ints) are much faster than long ones.
      @Match_MaxBits = 32
      #      Find the differences between two texts.  Simplifies the problem by
      #       stripping any common prefix or suffix off the texts before diffing.
      #
      #     Args:
      #       text1: Old string to be diffed.
      #       text2: New string to be diffed.
      #       checklines: Optional speedup flag.  If present and false, then don't run
      #         a line-level diff first to identify the changed areas.
      #         Defaults to true, which does a faster, slightly less optimal diff.
      #       deadline: Optional time when the diff should be complete by.  Used
      #         internally for recursive calls.  Users should set DiffTimeout instead.
      #
      #     Returns:
      #       Array of changes.
      #
    end

    def diff_main(text1, text2, checklines = True, deadline = None)
      # Set a deadline by which time the diff must be complete.
      if deadline == None
        # Unlike in most languages, Python counts time in seconds.
        if @Diff_Timeout <= 0
          deadline = sys.maxsize
        else
          deadline = time.time + @Diff_Timeout
        end

        # Check for null inputs.
        if text1 == None || text2 == None
          raise "Null inputs. (diff_main)"
        end

        # Check for equality (speedup).
        if text1 == text2
          if text1
            return [{@DIFF_EQUAL, text1}]
          end
          return [] of String
        end

        # Trim off common prefix (speedup).
        commonlength = diff_commonPrefix(text1, text2)
        commonprefix = text1[:commonlength]
        text1 = text1[commonlength..]
        text2 = text2[commonlength..]

        # Trim off common suffix (speedup).
        commonlength = diff_commonSuffix(text1, text2)
        if commonlength == 0
          commonsuffix = ""
        else
          commonsuffix = text1[-commonlength..]
          text1 = text1[...-commonlength]
          text2 = text2[...-commonlength]

          # Compute the diff on the middle block.
          diffs = diff_compute(text1, text2, checklines, deadline)

          # Restore the prefix and suffix.
          if commonprefix
            diffs[...0] = [{DIFF_EQUAL, commonprefix}]
            if commonsuffix
              diffs.append({DIFF_EQUAL, commonsuffix})
              diff_cleanupMerge(diffs)
              return diffs
            end
          end
        end
      end
    end

    #      Determine the common prefix of two strings.

    #  Args:
    #    text1: First string.
    #    text2: Second string.

    #  Returns:
    #    The number of characters common to the start of each string.
    #
    def diff_commonPrefix(text1, text2)
      # Quick check for common null cases.
      if text1 == "" || !text2 || text1[0] != text2[0]
        return 0
        # Binary search.
        # Performance analysis: https://neil.fraser.name/news/2007/10/09/
      end
      len(text1)
      pointermin = 0
      pointermax = Math.min(text1.size, text2.size)
      pointermid = pointermax
      pointerstart = 0
      while pointermin < pointermid
        if text1[pointerstart...pointermid] == text2[pointerstart...pointermid]
          pointermin = pointermid
          pointerstart = pointermin
        else
          pointermax = pointermid
        end
        pointermid = (pointermax - pointermin) // 2 + pointermin
      end
      return pointermid
    end
  end
end
