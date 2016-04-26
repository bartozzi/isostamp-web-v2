class TagfinderExecutionsController < ApplicationController
  before_action :set_tagfinder_execution, only: [:show, :edit, :update, :destroy]

  # GET /tagfinder_executions
  # GET /tagfinder_executions.json
  def index
    @data_files     = Document.where(user: current_user, kind: Document.kinds['Mass Spec Data'])
    @param_files    = Document.where(user: current_user, kind: Document.kinds['Parameters'])
    @default_params = [[ nil, 'Use Default Configuration' ]]

    @tagfinder_executions = TagfinderExecution.where(user: current_user)
  end

  # GET /tagfinder_executions/1
  # GET /tagfinder_executions/1.json
  def show
  end

  # POST /tagfinder_executions
  # POST /tagfinder_executions.json
  def create
    ap tagfinder_execution_params
    @tagfinder_execution = TagfinderExecution.new(tagfinder_execution_params.merge(user:current_user))

    respond_to do |format|
      if @tagfinder_execution.save
        format.html { redirect_to tagfinder_executions_path, notice: 'Tagfinder execution was successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @tagfinder_execution.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /tagfinder_executions/1
  # DELETE /tagfinder_executions/1.json
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
      @tagfinder_execution = TagfinderExecution.find(params[:id])
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
