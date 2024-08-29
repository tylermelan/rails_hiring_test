class RidingsController < ApplicationController
  before_action :set_riding, only: %i[ show edit update destroy ]

  # GET /ridings or /ridings.json
  def index
    @ridings = Riding
                .select("ridings.*", "COUNT(polls.id) AS polls_count")
                .left_joins(:polls)
                .group(:id)
                .order(:riding_code)
  end

  # GET /ridings/1 or /ridings/1.json
  def show
    @polling_locations = @riding.polling_locations.includes(:polls)
  end

  # GET /ridings/new
  def new
    @riding = Riding.new
  end

  # GET /ridings/1/edit
  def edit
  end

  # POST /ridings or /ridings.json
  def create
    @riding = Riding.new(riding_params)

    respond_to do |format|
      if @riding.save
        format.html { redirect_to riding_url(@riding), notice: "Riding was successfully created." }
        format.json { render :show, status: :created, location: @riding }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @riding.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ridings/1 or /ridings/1.json
  def update
    respond_to do |format|
      if @riding.update(riding_params)
        format.html { redirect_to riding_url(@riding), notice: "Riding was successfully updated." }
        format.json { render :show, status: :ok, location: @riding }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @riding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ridings/1 or /ridings/1.json
  def destroy
    @riding.destroy!

    respond_to do |format|
      format.html { redirect_to ridings_url, notice: "Riding was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_riding
      @riding = Riding.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def riding_params
      params.require(:riding).permit(:name, :riding_code, :province)
    end
end
