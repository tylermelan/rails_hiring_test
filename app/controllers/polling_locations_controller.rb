class PollingLocationsController < ApplicationController
  def edit
    @polling_location = PollingLocation.find(params[:id])
    @riding = @polling_location.riding
  end

  def update
    @polling_location = PollingLocation.find(params[:id])
    @riding = @polling_location.riding

    unless @polling_location.update(polling_location_params)
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def polling_location_params
      params.require(:polling_location).permit(:title, :address, :city, :postal_code)
    end
end