class Room < ApplicationRecord
  def self.unique_code
    valid = false
    until valid
      possible = ('A'..'Z').to_a
      
      code = (0..5).map { |n| possible.sample }.join

      valid = true if Room.where(:code => code).count == 0
    end

    code
  end

  def self.find_by_code(code)
    code.upcase!
    Room.where(code: code).first
  end
end
