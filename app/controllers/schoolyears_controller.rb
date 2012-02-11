class SchoolyearsController < ApplicationController
  # GET /schoolyears
  # GET /schoolyears.json
  def index
    @schoolyears = Schoolyear.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schoolyears }
    end
  end

  # GET /schoolyears/1
  # GET /schoolyears/1.json
  def show
    @schoolyears = Schoolyear.all
    @schoolyear = Schoolyear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @schoolyear }
    end
  end

  # GET /schoolyears/new
  # GET /schoolyears/new.json
  def new
    @schoolyear = Schoolyear.new
    @departments = Department.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @schoolyear }
    end
  end

  # GET /schoolyears/1/edit
  def edit
    @schoolyear = Schoolyear.find(params[:id])
  end

  # POST /schoolyears
  # POST /schoolyears.json
  def create
    @schoolyear = Schoolyear.new(params[:schoolyear])

    respond_to do |format|
      if @schoolyear.save
        if @schoolyear[:id] == 1
          @schoolyear[:current] = true
          @schoolyear.save
        end
        format.html { redirect_to @schoolyear, notice: 'Schoolyear was successfully created.' }
        format.json { render json: @schoolyear, status: :created, location: @schoolyear }
      else
        format.html { render action: "new" }
        format.json { render json: @schoolyear.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /schoolyears/1
  # PUT /schoolyears/1.json
  def update
    @schoolyear = Schoolyear.find(params[:id])

    respond_to do |format|
      if @schoolyear.update_attributes(params[:schoolyear])
        format.html { redirect_to @schoolyear, notice: 'Schoolyear was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @schoolyear.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schoolyears/1
  # DELETE /schoolyears/1.json
  def destroy
    @schoolyear = Schoolyear.find(params[:id])
    @schoolyear.destroy

    respond_to do |format|
      format.html { redirect_to schoolyears_url }
      format.json { head :ok }
    end
  end
  
  def make_current
    @schoolyear = Schoolyear.find(params[:id])
    
    unless(@schoolyear[:current])
      Schoolyear.update_all(:current => false)
      @schoolyear[:current] = true
      @schoolyear.save
    end
    respond_to do |format|
      format.html { redirect_to schoolyears_url }
      format.json { head :ok }
    end
  end
end
