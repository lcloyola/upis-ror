class CoursesController < ApplicationController
  before_filter :only => [:new, :create, :edit, :update] { |c| c.allow_access! 14 } # everyone except faculty
  before_filter :only => [:destroy] { |c| c.allow_access! 12 } # admin and moderator
  before_filter :only => [:enroll_students, :unenroll_students, :unenroll_student] { |c| c.allow_access! 14 } # everyone except faculty
  before_filter :only => [:grading_sheet, :update_grades, :removal] { |c| c.allow_access! 9 } # admin and faculty
  before_filter :only => [:grading_sheet, :update_grades,:request_unlock,:removal] { |c| c.allow_access! 9 and c.class_owned?} # faculty
  before_filter :only => [:process_request] { |c| c.allow_access! 8 }

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
    @students = Batch.find(@course.section.batch.id).students
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
      format.pdf do
        render :pdf => "show.pdf", :layout => "pdf.html", :margin => {:top => 7, :bottom => 3}
      end
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
    @sections = Section.where('schoolyear_id = ?', @course.schoolyear_id)
  end

  # POST /courses
  # POST /courses.json
  def create
    @schoolyear = Schoolyear.find(params[:course][:schoolyear_id])
    if params[:yearsem] == "0"
      params[:course][:yearlong] = true
    else # if yearsem == 1, 2, 3 or 4
      params[:course][:yearlong] = false
      params[:course][:sem] = params[:yearsem]
    end
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
    @course = Course.find(params[:course_id])
    @student = Student.find(params[:student_id])
    #TODO: validate course, student existence?
    if @student.enrolled?(@course.id) && !@student.course_has_grade(@course.id)
      @grades = @student.course_grades(@course.id)
      @grades.each do |g|
        g.destroy
      end
    end
    respond_to do |format|
      format.html {redirect_to Course.find(params[:course_id]) }
    end
  end
  def unenroll_students
    @course = Course.find(params[:course_id])
    @course.unenroll_students
    redirect_to @course
  end
  def grading_sheet
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @course }
    end
  end

  def update_grades
    #warning: possible race condition -- when faculty and admin edits at the same time.
    @course = Course.find(params[:id])
    params[:course][:grade].each do |e|
      @grade = Grade.find(e[0])
      # refactor? find rails option which only updates "dirty attributes"
      if @grade.value != e[1][:value].to_i
        @grade.update_attributes(e[1])
        @grade.update_attributes(:updated_by => current_user.id) unless (e[1][:value] == "" and @grade.value.nil?)
      end
    end
    @course.update_attributes ({:is_locked => CourseStatus::Close})
    respond_to do |format|
      format.html {redirect_to @course }
    end

  end

  def removal
    @course = Course.find(params[:id])
    @student = Student.find(params[:student_id])
    @removal = Removal.where('student_id = ? AND course_id = ?', @student.id, @course.id).first
    if !@removal.nil? && !@course.is_closed?                                    # no removal grade yet and grading sheet is open
      if params[:verdict] == "pass"
        @removal.update_attributes({:pass => true, :updated_by => current_user.id})
      else
        @removal.update_attributes({:pass => false, :updated_by => current_user.id})
      end
    elsif @removal.nil?                                                         # no removal grade yet
      if params[:verdict] == "pass"
        @newremove = Removal.new("student_id" => @student.id, "course_id" => @course.id, "pass" => true, :updated_by => current_user.id)
      else
        @newremove = Removal.new("student_id" => @student.id, "course_id" => @course.id, "pass" => false, :updated_by => current_user.id)
      end
      @newremove.save
    end
    @course.update_attributes(:is_locked => true)
    redirect_to @course
  end
  def my_classes
    @schoolyear = Schoolyear.current_schoolyear.first
    @courses = current_user.my_classes

    respond_to do |format|
      format.html { render 'courses/index' }
    end
  end
  def request_unlock
    @course = Course.find(params[:id])
    if @course.is_locked == CourseStatus::Close
      @course.update_attributes(:is_locked => CourseStatus::Pending)
      notice = "<div class='alert alert-info'>Request sent.</div>"
    elsif @course.is_locked == CourseStatus::Pending
      @course.update_attributes(:is_locked => CourseStatus::Close)
      notice = "<div class='alert alert-info'>Request cancelled.</div>"
    end
    redirect_to @course, notice: notice
  end
  def class_owned?
    @course = Course.find(params[:id])
    return true if @course.faculty.user_id == current_user.id or current_user.role == Role::Admin
    redirect_to @course, notice: RESTRICTED_NOTICE
  end
  def process_request
    @course = Course.find(params[:id])
    if params[:decision] == 'approve'
      @course.update_attributes(:is_locked => CourseStatus::Open)
    elsif params[:decision] == 'deny'
      @course.update_attributes(:is_locked => CourseStatus::Close)
    end
    redirect_to root_url
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
      if @course.yearlong
        quarters = [1..4]
      elsif @course.sem == 1
        quarters = [1, 2]
      elsif @course.sem == 2
        quarters = [3, 4]
      elsif @course.sem == 3
        quarters = [1, 3]
      elsif @course.sem == 4
        quarters = [2, 4]
      end

      for j in quarters
        @enrollment = Grade.new("course_id" => @course.id, "student_id" => @student.id, "quarter" => j)
        @enrollment.save
      end
    end
  end

end

