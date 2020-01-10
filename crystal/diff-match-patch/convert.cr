len_re = /len\((.*?)\)/

STDIN.each_line("test.py") do |line|
  line_new = line.sub("min(", "Math.min(")
  line_new = line.sub("self.", "@")
  line_new = line_new.sub(len_re, "\\1.size")
  line_new = line_new.sub(/:]/, "..]")
  line_new = line_new.chomp(':')

  if line_new != line
    puts line
    puts line_new
    puts
  end
end
