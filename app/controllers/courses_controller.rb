class CoursesController < ApplicationController

	def new
    @course = Course.new
  end

  def create
    @course = Course.create(course_params)
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    @course.update_attributes(course_params)
  end

  def destroy 
    @course = Course.find(params[:id])
    @course.destroy
  end

  private

  def course_params
    params.require(:course).permit(:name)
  end

end