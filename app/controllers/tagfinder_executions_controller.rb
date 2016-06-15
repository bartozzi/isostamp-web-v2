class TagfinderExecutionsController < ApplicationController
  before_action :set_tagfinder_execution, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
  end

  def index
    @user           = current_user
    @data_files     = current_user.documents
    @param_files    = current_user.documents
    @tagfinder_executions = TagfinderExecution.where(user: current_user).decorate.reverse
  end

  def create
    @execution = TagfinderExecution.new(tagfinder_execution_params.merge(user: current_user))
    if @execution.save
      RunExecution.enqueue(@execution.id)
      redirect_to tagfinder_executions_path, notice: 'Tagfinder execution was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @tagfinder_execution.destroy
    respond_to do |format|
      format.html { redirect_to tagfinder_executions_url, notice: 'Tagfinder execution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tagfinder_execution
      @tagfinder_execution = TagfinderExecution.find(params[:id]).decorate
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tagfinder_execution_params
      filtered = params.require(:tagfinder_execution).permit(:user_id, :data_file_id, :params_file_id, :email_sent, :success)

      filtered['data_file_id'] = filtered['data_file_id'].to_i

      if filtered['params_file_id'] == 'on'
        filtered.delete('params_file_id')
      else
        filtered['params_file_id'] = filtered['params_file_id'].to_i
      end

      filtered
    end
end
