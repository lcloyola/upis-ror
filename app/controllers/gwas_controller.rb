class GwasController < ApplicationController
  before_filter { |c| c.allow_access! 12 } # admin and moderator

  def index
    if params[:gwa].present?
      @mode = params[:gwa][:mode].to_i
      @batch = Batch.find(params[:gwa][:batch_id])
      @schoolyear = Schoolyear.find(params[:gwa][:schoolyear_id])
      
      @gwas = Gwa.search(@schoolyear, @batch, @mode)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gwas }
    end
  end

  def create
    @batch = Batch.find(params[:batch_id])
    @schoolyear = Schoolyear.find(params[:schoolyear_id])
    @mode = params[:mode].to_i

    @batch.students.each do |student|
      gwa = Gwa.find_or_create_by_student_id_and_schoolyear_id_and_gwa_type(student.id, @schoolyear.id, @mode)
      gwa.recompute
    end

    @gwas = Gwa.search(@schoolyear, @batch, @mode)

    respond_to do |format|
      format.html {render :action => 'index.html'}
    end

  end
end