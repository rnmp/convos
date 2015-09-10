class ConvosController < ApplicationController
  before_action :set_convo, only: [:show, :edit, :update, :destroy]

  # GET /convos
  # GET /convos.json
  def index
    @convos = Convo.all
  end

  # GET /convos/1
  # GET /convos/1.json
  def show
    @comments = @convo.comments.all
    @comment = @convo.comments.build
  end

  # GET /convos/new
  def new
    @convo = Convo.new
  end

  # GET /convos/1/edit
  def edit
  end

  # POST /convos
  # POST /convos.json
  def create
    @convo = Convo.new(convo_params)

    respond_to do |format|
      if @convo.save
        format.html { redirect_to @convo, notice: 'Convo was successfully created.' }
        format.json { render :show, status: :created, location: @convo }
      else
        format.html { render :new }
        format.json { render json: @convo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /convos/1
  # PATCH/PUT /convos/1.json
  def update
    respond_to do |format|
      if @convo.update(convo_params)
        format.html { redirect_to @convo, notice: 'Convo was successfully updated.' }
        format.json { render :show, status: :ok, location: @convo }
      else
        format.html { render :edit }
        format.json { render json: @convo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /convos/1
  # DELETE /convos/1.json
  def destroy
    @convo.destroy
    respond_to do |format|
      format.html { redirect_to convos_url, notice: 'Convo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_convo
      @convo = Convo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def convo_params
      params.require(:convo).permit(:title, :author, :votes, :url, :comment)
    end
end
