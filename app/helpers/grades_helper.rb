module GradesHelper

  def elevenpt(average)
    final = case average
      when 96..100 then 1.0
      when 91..95.99 then 1.25
      when 86..90.99 then 1.50
      when 80..85.99 then 1.75
      when 74..79.99 then 2.00
      when 68..73.99 then 2.25
      when 62..67.99 then 2.50
      when 56..61.99 then 2.50
      when 50..55.99 then 3.00
      when 40..49.99 then 4.00
      else 5.00
    end
    return final
  end
  
end
