class PollingLocationsController < ApplicationController
  def new
    @polling_location = PollingLocation.new
    @riding = Riding.find(params[:riding_id])
  end

  def edit
    @polling_location = PollingLocation.find(params[:id])
    @riding = Riding.find(params[:riding_id])
  end

  def update
    @polling_location = PollingLocation.find(params[:id])
    @riding = Riding.find(params[:riding_id])

    poll_numbers, polls = poll_data

    if @polling_location.update(
      polling_location_params.merge(
        polls:,
        poll_numbers_to_validate: poll_numbers
      )
    )
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @riding = Riding.find(params[:riding_id])

    poll_numbers, polls = poll_data

    @polling_location = PollingLocation.new(
      polling_location_params.merge(
        polls:,
        poll_numbers_to_validate: poll_numbers,
        riding: @riding
      )
    )

    if @polling_location.save
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def polling_location_params
      params.require(:polling_location).permit(:title, :address, :city, :postal_code)
    end

    def poll_data
      poll_numbers = params[:poll_numbers].split(',').map(&:strip)
      polls = Poll.where(number: poll_numbers, riding: @riding)

      [poll_numbers, polls]
    end
end
