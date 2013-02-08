module GwasHelper
  def gwalabel(gwatype)
    gwatype = gwatype.to_i
    if gwatype == GwaMode::Schoolyear then return "Current Schoolyear"
    elsif gwatype == GwaMode::Cumulative then return "Cumulative"
    elsif gwatype == GwaMode::Semester1 then return "1st Semester"
    elsif gwatype == GwaMode::Semester2 then return "2nd Semester"
    end
  end
end
