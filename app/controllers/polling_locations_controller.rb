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

    poll_numbers, polls = process_poll_numbers
    @other_polling_locations = other_polling_locations(polls)

    if @polling_location.update(
      polling_location_params.merge(
        polls:,
        poll_numbers_to_validate: poll_numbers
      )
    )
      destroy_unused_polling_locations
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @riding = Riding.find(params[:riding_id])

    poll_numbers, polls = process_poll_numbers
    @other_polling_locations = other_polling_locations(polls)

    @polling_location = PollingLocation.new(
      polling_location_params.merge(
        polls:,
        poll_numbers_to_validate: poll_numbers,
        riding: @riding
      )
    )

    if @polling_location.save
      destroy_unused_polling_locations
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def polling_location_params
      params.require(:polling_location).permit(:title, :address, :city, :postal_code)
    end

    def process_poll_numbers
      poll_numbers = params[:poll_numbers].split(',').map(&:strip)
      polls = Poll.where(number: poll_numbers, riding: @riding)

      [poll_numbers, polls]
    end

    def other_polling_locations(polls)
      other_polling_locations = PollingLocation.where(id: polls.map(&:polling_location_id))
      other_polling_locations = other_polling_locations.where.not(id: @polling_location.id) if @polling_location
      other_polling_locations = other_polling_locations.includes(:polls)

      other_polling_locations
    end

    def destroy_unused_polling_locations
      @other_polling_locations.each do |polling_location|
        if polling_location.polls.size == 0
          polling_location.destroy
        end
      end
    end
end
