class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_ownership!, only: %i(destroy)

  def index
    @document = Document.new
    @documents = Document.where(user: current_user)
  end

  def create
    @document = Document.new(document_params)

    if @document.save
      redirect_to documents_path, notice: "The file #{@document.filename} has been uploaded."
    else
      render 'index'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to documents_path, notice: "The file #{@document.filename} has been deleted."
  end

  private

  def document_params
    filtered = params.require(:document).permit(:attachment)
    filtered.merge(user: current_user)
  end

  def check_ownership!
    unless current_user && current_user.documents.find_by_id(params[:id])
      render_404
    end
  end
end
