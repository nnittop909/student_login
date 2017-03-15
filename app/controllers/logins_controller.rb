class LoginsController < ApplicationController

  def index
    @logins = Login.order("created_at desc").all
  end

  def destroy
    @login = Login.find(params[:id])
    @login.set_status
    @login.destroy
    respond_to do |format|
      format.html { redirect_to logins_path, notice: 'Student has been signed out.' }
      format.json { head :no_content }
    end
  end

  private
    def login_params
      params.require(:login).permit(:student_id)
    end
end
