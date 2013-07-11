class GradesController < ApplicationController
  before_filter :only => [:quarterreport] { |c| c.allow_access! 14 } # admin
  
  def deficiency
    @quarter = params['quarter']
    @def = Grade.deficiencies(params['quarter'], Schoolyear.current)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @section }
      format.pdf do
        render :pdf => "deficiency.pdf", :layout => "pdf.html"
      end
    end
  end
  def quarterreport
    params[:orientation] == "landscape" ? @orientation = "landscape" : @orientation = "portrait"
    @orientation == "landscape" ? @per_page = 2 : @per_page = 4
    @sy = Schoolyear.current

    if params[:type] == "batch"
      @students = Batch.find(params[:id]).students
    elsif params[:type] == "section"
      @students = Section.find(params[:id]).students
    elsif params[:type] == "student"
      @students = Student.where(:id => params[:id])
    end

    respond_to do |format|
      format.pdf do
        render :pdf => "show.pdf", :margin => {:top => 7, :bottom => 3}, :orientation => @orientation
      end
    end
  end
end