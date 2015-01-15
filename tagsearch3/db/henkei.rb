fwrite = open("kakikomi.csv",	 "w")
open("sample1.csv") {|f|
  f.each_line do |line|
    line.gsub!("\,", "\n#{f.lineno},")
    fwrite.puts "#{f.lineno},#{line}"
  end
}