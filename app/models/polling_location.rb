class PollingLocation < ApplicationRecord
  attr_accessor :poll_numbers_to_validate

  belongs_to :riding
  has_many :polls

  validates :title, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validate :validate_postal_code
  validate :validate_poll_numbers
  validate :validate_unique_to_riding

  after_validation :format_postal_code

  def poll_numbers
    poll_numbers_to_validate ? poll_numbers_to_validate : polls.map(&:number)
  end

  def format_postal_code
    self.postal_code = self.postal_code.upcase.scan(/[A-Z0-9]/).insert(3, ' ').join if self.postal_code.present?
  end

  def validate_postal_code
    unless self.postal_code.present? && /[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ ]?\d[ABCEGHJ-NPRSTV-Z]\d/.match?(self.postal_code.upcase)
      errors.add(:postal_code, "must be valid")
    end
  end

  def validate_unique_to_riding
    if PollingLocation.where.not(id:).exists?(riding:, title:, address:, city:, postal_code:)
      errors.add(:base, "Polling location is not unique")
    end
  end

  def validate_poll_numbers
    if poll_numbers_to_validate
      poll_numbers_set = Set.new(polls.map(&:number))

      poll_numbers_to_validate.each do |poll_number|
        unless poll_number.in?(poll_numbers_set)
          errors.add(:polls, "Poll #{poll_number} is not available")
        end
      end
    end
  end
end
