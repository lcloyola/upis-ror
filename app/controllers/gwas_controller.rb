class GwasController < ApplicationController
  # GET /gwas
  # GET /gwas.json
  def index
    if params[:gwa].present?
      @mode = params[:gwa][:mode]
      @batch = Batch.find(params[:gwa][:batch_id])
      @schoolyear = Schoolyear.find(params[:gwa][:schoolyear_id])
      
      Gwa.search(@schoolyear, @batch, @mode)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gwas }
    end
  end

  # GET /gwas/1
  # GET /gwas/1.json
  def show
    @gwa = Gwa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gwa }
    end
  end

  # GET /gwas/new
  # GET /gwas/new.json
  def new
    @gwa = Gwa.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gwa }
    end
  end

  # GET /gwas/1/edit
  def edit
    @gwa = Gwa.find(params[:id])
  end

  # POST /gwas
  # POST /gwas.json
  def create
    @gwa = Gwa.new(params[:gwa])

    respond_to do |format|
      if @gwa.save
        format.html { redirect_to @gwa, notice: 'Gwa was successfully created.' }
        format.json { render json: @gwa, status: :created, location: @gwa }
      else
        format.html { render action: "new" }
        format.json { render json: @gwa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gwas/1
  # PUT /gwas/1.json
  def update
    @gwa = Gwa.find(params[:id])

    respond_to do |format|
      if @gwa.update_attributes(params[:gwa])
        format.html { redirect_to @gwa, notice: 'Gwa was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @gwa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gwas/1
  # DELETE /gwas/1.json
  def destroy
    @gwa = Gwa.find(params[:id])
    @gwa.destroy

    respond_to do |format|
      format.html { redirect_to gwas_url }
      format.json { head :ok }
    end
  end
end
