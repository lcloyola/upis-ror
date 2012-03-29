class CoursesController < ApplicationController
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    @students = Student.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @schoolyear = Schoolyear.find(params[:schoolyear_id])
    @course = Course.new("schoolyear_id" => @schoolyear.id);
    @sections = Section.where('schoolyear_id = ?', @schoolyear.id)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  
  def edit
    @course = Course.find(params[:id])
    if !@course.enrollees.nil?
      respond_to do |format|
        format.html{ redirect_to @course, notice: 'Can\'t edit course with enrollees.'}
      end
    end
    @sections = Section.where('schoolyear_id = ?', @course.schoolyear_id)
  end

  # POST /courses
  # POST /courses.json
  def create
    @schoolyear = Schoolyear.find(params[:course][:schoolyear_id])
    params[:course].delete :id
    @course = @schoolyear.courses.new(params[:course])
    @sections = Section.where('schoolyear_id = ?', @schoolyear.id)
    
    respond_to do |format|
      if @course.save
        enroll_section()
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :ok }
    end
  end
  
  def enroll_students
    @course = Course.find(params[:id])
    params[:students].each do |student_id|
      @student = Student.find(student_id)
      #TODO: validate student existence
      enroll_individual_student()
    end
    respond_to do |format|
      format.html {redirect_to Course.find(params[:id]) }
    end
  end
  def unenroll_student
    @student = Student.find(params[:student_id])
    #TODO: validate course, student existence?
    if @student.enrolled?(params[:course_id])
      @enrollee = Enrollee.where('course_id = ? and student_id = ?', params[:course_id], @student.id).first
      unless @enrollee.nil?
        if @enrollee.quartera.nil? || @enrollee.quarterb.nil?
          @enrollee.destroy
        end
      end
    end
    respond_to do |format|
      format.html {redirect_to Course.find(params[:course_id]) }
    end
  end
  
  def grading_sheet
    @course = Course.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: @course }
    end
  end
  
  def update_grades
    @course = Course.find(params[:id])
    params[:enrollee][:enrollee].each do |e|
      @enrollee = Enrollee.find(e[0])
      @enrollee.update_attributes(e[1])
    end
    respond_to do |format|
      format.html {redirect_to @course }
    end
    
  end
private
  def enroll_section
    #TODO: validation--no students yet
    @students = Member.where('section_id = ?', @course.section_id)
    unless @students.nil?
      @students.each do |member|
        @student = member.student
        enroll_individual_student()
      end
    end
  end
  def enroll_individual_student
    unless @student.enrolled?(@course.id)
      @enrollment = Enrollee.new("course_id" => @course.id, "student_id" => @student.id)
      @enrollment.save
    end
  end
end
