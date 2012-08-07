class FacultiesController < ApplicationController
  # GET /faculties
  # GET /faculties.json
  def index
    @faculties = Faculty.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @faculties }
    end
  end

  # GET /faculties/1
  # GET /faculties/1.json
  def show
    @faculty = Faculty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @faculty }
    end
  end

  # GET /faculties/new
  # GET /faculties/new.json
  def new
    @faculty = Faculty.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @faculty }
    end
  end

  # GET /faculties/1/edit
  def edit
    @faculty = Faculty.find(params[:id])
  end

  # POST /faculties
  # POST /faculties.json
  def create
    @faculty = Faculty.new(params[:faculty])

    respond_to do |format|
      if @faculty.save
        pass = Devise.friendly_token.first(6)
        details = {
          email: "#{@faculty.id}@temporay.com",
          password: pass
        }
        user = User.create! details
        @faculty.update_attributes(:user_id => user.id)
        notice = "<div class='alert alert-success'>Faculty was successfully created. <br> email: #{@faculty.email}<br>temporary password: #{pass}</div>"
        format.html { redirect_to @faculty, notice: notice }
        format.json { render json: @faculty, status: :created, location: @faculty }
      else
        format.html { render action: "new" }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /faculties/1
  # PUT /faculties/1.json
  def update
    @faculty = Faculty.find(params[:id])
    @faculty.user.update_attribute(:email, params[:email][:email]) if params[:email][:email] != ""

    respond_to do |format|
      if @faculty.update_attributes(params[:faculty])
        format.html { redirect_to @faculty, notice: 'Faculty was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faculties/1
  # DELETE /faculties/1.json
  def destroy
    @faculty = Faculty.find(params[:id])
    @faculty.destroy

    respond_to do |format|
      format.html { redirect_to faculties_url }
      format.json { head :ok }
    end
  end
  def regenerate_password
    @faculty = Faculty.find(params[:id])
    pass = Devise.friendly_token.first(6)
    respond_to do |format|
      if @faculty.user.update_attributes(:password => pass)
        notice = "<div class='alert alert-success'>Faculty was successfully created. <br> email: #{@faculty.email}<br>temporary password: #{pass}</div>"
        format.html { redirect_to @faculty, notice: notice }
      end
    end
  end
end

