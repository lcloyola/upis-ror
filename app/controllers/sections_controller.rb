class SectionsController < ApplicationController
  # GET /sections
  # GET /sections.json
  def index
    @schoolyear = Schoolyear.current_schoolyear.first
    @sections = Section.where("schoolyear_id = ?", @schoolyear.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sections }
    end
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
    @section = Section.find(params[:id])
    @students = Student.where('batch_id = ?', @section[:batch_id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @section }
      format.pdf do
        render :pdf => "show.pdf", :layout => "pdf.html"
      end
    end
  end

  # GET /sections/new
  # GET /sections/new.json
  def new
    @section = Section.new(:schoolyear_id => Schoolyear.current_schoolyear.first.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @section }
    end
  end

  # GET /sections/1/edit
  def edit
    @section = Section.find(params[:id])
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(params[:section])

    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
        format.json { render json: @section, status: :created, location: @section }
      else
        format.html { render action: "new" }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sections/1
  # PUT /sections/1.json
  def update
    @section = Section.find(params[:id])

    respond_to do |format|
      if @section.update_attributes(params[:section])
        format.html { redirect_to "/sections", notice: 'Section was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section = Section.find(params[:id])
    @section.destroy

    respond_to do |format|
      format.html { redirect_to sections_url }
      format.json { head :ok }
    end
  end

  def year
    @schoolyear = Schoolyear.find(params[:schoolyear_id])
    @sections = Section.where("schoolyear_id = ?", @schoolyear.id)

    respond_to do |format|
      format.html
    end
  end

  def enroll_to_section
    @section = Section.find(params[:id])
    params[:students].each do |student_id|
       @student = Student.find(student_id)
       #TODO: validate existence
       enroll_individual_student()
    end
    respond_to do |format|
      format.html {redirect_to Section.find(@section.id) }
    end
  end

  def unenroll_student
    @section = Section.find(params[:id])
    @student = Student.find(params[:student_id])
    #TODO: validate course, student existence?
    if @student.member?(@section.id)
      @member = Member.where('section_id = ? and student_id = ?', @section.id, @student.id).first
      unless @member.nil?
        @member.destroy
      end
    end
    respond_to do |format|
      format.html {redirect_to @section}
    end
  end
  def for_sectionid
    @sections = Section.find( :all, :conditions => [" schoolyear_id = ?", params[:id]]  ).sort_by{ |k| k['name'] }
    respond_to do |format|
      format.json  { render :json => @sections }
    end
  end
private
  def enroll_individual_student
    unless @student.member?(@section.id)
      @membership = Member.new("section_id" => @section.id, "student_id" => @student.id)
      @membership.save
    end
  end
end

