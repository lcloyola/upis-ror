class StudentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter do
    redirect_to new_user_session_path unless current_user && current_user.admin?
  end
  def get_students_list
    @students = Batch.find(params[:id]).students unless params[:id].blank?
    render :partial => "students_list", :locals => { :students => @students }
  end
  def index
    @batch = Batch.find(params[:batch_id])
    @students = Student.where('batch_id = ?', params[:batch_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @batch = Batch.find(params[:batch_id])
    @student = Student.new()


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
    @batch = Batch.find(@student.batch_id)
  end

  # POST /students
  # POST /students.json
  def create
    @batch = Batch.find(params[:batch_id])
    @student = @batch.students.new(params[:student])
    assign_student_no()

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :ok }
    end
  end
  def transcript
    @student = Student.find(params[:student_id])
    @schoolyear = @student.schoolyears.group('schoolyear_id').order('start ASC')
    respond_to do |format|
      format.html
    end
  end
  def honorroll
    @student = Student.find(params[:student_id])
    @schoolyear = @student.schoolyears.group('schoolyear_id').order('start ASC')
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "honorroll.pdf", :layout => "pdf.html"
      end
    end
  end
private
  def assign_student_no
    @batchmate = Student.where('batch_id = ?', @batch.id).order('student_no ASC')
    if @batchmate.empty?
      @student.student_no = @batch.year * 100000 + 1
    else
      @student.student_no = @batchmate.last.student_no + 1
    end
  end
end

