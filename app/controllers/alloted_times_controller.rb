class AllotedTimesController < ApplicationController

	def new
    @alloted_time = AllotedTime.new
  end

  def create
    @alloted_time = AllotedTime.create(alloted_time_params)
  end

  def edit
    @alloted_time = AllotedTime.find(params[:id])
  end

  def update
    @alloted_time = AllotedTime.find(params[:id])
    @alloted_time.update_attributes(alloted_time_params)
  end

  def destroy 
    @alloted_time = AllotedTime.find(params[:id])
    @alloted_time.destroy
  end

  private

  def alloted_time_params
    params.require(:alloted_time).permit(:duration)
  end

end