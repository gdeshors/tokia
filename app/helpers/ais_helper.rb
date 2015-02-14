module AisHelper

  
  def command_line_for(ai)
    return case ai.language
      when 'java 1.6' then  "java -cp #{ai.filename} #{ai.firstparam}"
      when 'scala 2.10.3' then  "java -cp /home/tokserver/env/scala_2.10.3/*:#{ai.filename} #{ai.firstparam}"
      when 'php 5' then  "php #{ai.filename} #{ai.firstparam}"
      when 'mono' then "mono #{ai.filename} #{ai.firstparam}"
      when 'python 2.7' then "python2.7 #{ai.filename} #{ai.firstparam}"
    end


  end

end
