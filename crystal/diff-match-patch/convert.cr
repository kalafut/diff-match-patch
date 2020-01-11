len_re = /len\((.*?)\)/

in_comment = false

STDIN.each_line do |line|
  if line.strip.starts_with? %["""]
    in_comment = !in_comment
    if !in_comment
      next
    end
  end

  if in_comment
    puts "# #{line.strip}"
    next
  end

  line_new = line.sub("min(", "Math.min(")
  line_new = line.sub("self.", "@")
  line_new = line_new.sub(len_re, "\\1.size")
  line_new = line_new.chomp(':')
  line_new = line_new.sub(/:/, "..")
  puts line_new
end
