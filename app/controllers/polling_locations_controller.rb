class PollingLocationsController < ApplicationController
  def edit
    @polling_location = PollingLocation.find(params[:id])
  end

  def update
    @polling_location = PollingLocation.find(params[:id])

    poll_numbers = params[:poll_numbers].split(',').map(&:strip)

    @polling_location.poll_numbers_to_validate = poll_numbers

    polls = Poll.where(number: poll_numbers, riding: @polling_location.riding)

    if @polling_location.update(polling_location_params.merge(polls:))
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def polling_location_params
      params.require(:polling_location).permit(:title, :address, :city, :postal_code)
    end
end