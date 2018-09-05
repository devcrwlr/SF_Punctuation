require 'fileutils'

txtgridfiles = Dir.glob("Textgrid/*")
txtgridfiles.each do |textgrid|
  files = Dir.glob("#{textgrid}/*")


#  files = Dir.glob("TextGridFile/*")
  file = ""

  files.each do |filename|
    data = []
     file = File.read(filename)

         file = file.encode("UTF-16be", :invalid=>:replace, :replace=>"?@?").encode('UTF-8')
         file = file.split("\n")
         begin
           file.each do |txt|

               splittxt = txt.inspect.gsub("\\u0000","")

               unless splittxt.size.to_i <= 10

                  splittxt = splittxt.gsub(" u001C","")

                  splittxt = splittxt.gsub(" u001D","")

                  splittxt = splittxt.gsub(" u0019","\'")

                  splittxt = splittxt.gsub(" \\u001C","")
                  splittxt = splittxt.gsub(" \\u001D","")
                  splittxt = splittxt.gsub(" \\u0019","\'")

                  if splittxt.include? ",\\\""

                    split_coma =  splittxt.split(",\\\"")
                    splitted1 = "#{split_coma[0]}"
                    splitted2 = split_coma[1].to_s.gsub("r\"","")
                    splitted2 = splitted2.to_s.gsub("\\r\"","")
                    splitted2 = splitted2.to_s.gsub("\"","")
                    splitted2 = splitted2.gsub("\\ ","")
                    splitted2 = splitted2.gsub("\\","")
                    if splitted2.size >= 5
                      frstchr = splitted2.chars.first
                      upcase = frstchr.chars.first.upcase
                      slicetxt = splitted2.slice!(1, splitted2.size)
                       newtxt = "#{splitted1}. #{upcase}#{slicetxt}"

                    else
                        newtxt = "#{splitted1} #{splitted2}"

                    end

                  elsif splittxt.include? ", \\\""
                    split_coma =  splittxt.split(", \\\"")
                    splitted1 = "#{split_coma[0]}"
                    splitted2 = split_coma[1].to_s.gsub("r\"","")
                    splitted2 = splitted2.to_s.gsub("\\r\"","")
                    splitted2 = splitted2.to_s.gsub("\"","")
                    splitted2 = splitted2.gsub("\\ ","")
                    splitted2 = splitted2.gsub("\\","")
                    if splitted2.size >= 5
                      frstchr = splitted2.chars.first
                      upcase = frstchr.chars.first.upcase
                      slicetxt = splitted2.slice!(1, splitted2.size)
                      newtxt = "#{splitted1}. #{upcase}#{slicetxt}"
                    else
                      newtxt = "#{splitted1} #{splitted2 }"
                    end
                  else
                     newtxt = splittxt.gsub("\\r\"","")

                  end
                  #puts "Check TXT #{newtxt}"
                  newtxt = newtxt.gsub("\\r\"","")
                  newtxt = newtxt.gsub("\" ","")
                  newtxt = newtxt.gsub("\"","")
                  newtxt = newtxt.gsub("\\","")


                  if newtxt.include? "?@?"

                    newtxt = newtxt.gsub("?@?","")
                    if newtxt.include? "Q[B"
                      newtxt = newtxt.gsub("Q[B","内容层")
                    elsif newtxt.include? "҂rB"
                      newtxt = newtxt.gsub("҂rB","角色层")
                    end
                  end
                  if newtxt.include? "text ="
                    text = newtxt.gsub("\\\"","")
                    finaltext = text.gsub("\\","")
                    textsplit = finaltext.split(" = ")
                    fixtext =  "#{textsplit[0]} = \"#{textsplit[1]}\""
                    data << "#{fixtext}\r\n"
                  elsif newtxt.include? "type ="
                    text = newtxt.gsub("\\\"","")
                    finaltext = text.gsub("\\","")
                    textsplit = finaltext.split(" = ")
                    fixtext =  "#{textsplit[0]} = \"#{textsplit[1]}\""
                    data << "#{fixtext}\r\n"
                  elsif newtxt.include? "class ="
                    text = newtxt.gsub("\\\"","")
                    finaltext = text.gsub("\\","")
                    textsplit = finaltext.split(" = ")
                    fixtext =  "#{textsplit[0]} = \"#{textsplit[1]}\""
                    data << "#{fixtext}\r\n"
                  elsif newtxt.include? "name ="
                    text = newtxt.gsub("\\\"","")
                    finaltext = text.gsub("\\","")
                    textsplit = finaltext.split(" = ")
                    fixtext =  "#{textsplit[0]} = \"#{textsplit[1]}\""
                    data << "#{fixtext}\r\n"
                  else
                    data << "#{newtxt}\r\n"
                  end

               else
                   splittxt.size
               end
  		            puts "#{newtxt}"
             end

         rescue => error
           puts error
         end
       path = filename.split("/")
       newpath = "CorrectedFile/#{path[0]}/#{path[1]}"
       FileUtils.mkdir_p newpath
       #filename = filename.gsub("TextGridFile/","")
       File.open("#{newpath}/#{path[2]}","w:UTF-8"){ |f|
         f.puts(data)
       }

  end
end
