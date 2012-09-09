class GradesController < ApplicationController
  before_filter :only => [:index, :show, :new, :create, :edit, :update, :destroy] { |c| c.allow_access! 8 } # admin
  before_filter :only => [:quarterreport] { |c| c.allow_access! 14 } # admin
  def index
    @grades = Grade.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grades }
    end
  end

  # GET /grades/1
  # GET /grades/1.json
  def show
    @grade = Grade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grade }
    end
  end

  # GET /grades/new
  # GET /grades/new.json
  def new
    @grade = Grade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grade }
    end
  end

  # GET /grades/1/edit
  def edit
    @grade = Grade.find(params[:id])
  end

  # POST /grades
  # POST /grades.json
  def create
    @grade = Grade.new(params[:grade])

    respond_to do |format|
      if @grade.save
        format.html { redirect_to @grade, notice: 'Grade was successfully created.' }
        format.json { render json: @grade, status: :created, location: @grade }
      else
        format.html { render action: "new" }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grades/1
  # PUT /grades/1.json
  def update
    @grade = Grade.find(params[:id])

    respond_to do |format|
      if @grade.update_attributes(params[:grade])
        format.html { redirect_to @grade, notice: 'Grade was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1
  # DELETE /grades/1.json
  def destroy
    @grade = Grade.find(params[:id])
    @grade.destroy

    respond_to do |format|
      format.html { redirect_to grades_url }
      format.json { head :ok }
    end
  end
  def deficiency
    @quarter = params['quarter']
    @courses = Schoolyear.current_schoolyear.first.courses.with_deficiency(@quarter)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @section }
      format.pdf do
        render :pdf => "deficiency.pdf", :layout => "pdf.html"
      end
    end
  end
  def quarterreport
    @per_page = 4
    @sy = Schoolyear.current_schoolyear.first
    if params[:type] == "batch"
      @students = Batch.find(params[:id]).students
    elsif params[:type] == "section"
      section = Section.find(params[:id])
      @students = section.students
      if section.year < 4
        @per_page = 6
      end
    elsif params[:type] == "student"
      @students = Student.where(:id => params[:id])
    end

    respond_to do |format|
      format.pdf do
        render :pdf => "show.pdf", :margin => {:top => 7, :bottom => 3}, :font_size => 10
      end
    end
  end
end

