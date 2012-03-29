class GradesController < ApplicationController
  def deficiency
    if !params['schoolyear_id'].nil?
      @schoolyear = Schoolyear.find(params['schoolyear_id'])
      @quarter = params['quarter']
      @type = params['type']
      @id = params['id']
    else
      @schoolyears = Schoolyear.all
    end      
    respond_to do |format|
      format.html
    end
  end

  def schoolyear
    if !params['schoolyear_id'].nil?
      @schoolyear = Schoolyear.find(params['schoolyear_id'])
    else
      @schoolyears = Schoolyear.all
    end
  end
  
  def transcript
    if !params['batch_id'].nil?
      @batch = Batch.find(params['batch_id'])
    else
      @batches = Batch.all
    end
  end
  
  def classlist
    @course = Course.find(params['course_id'])
    @students = @course.yearmode_students
  end
end
