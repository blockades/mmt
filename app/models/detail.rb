class Detail < ApplicationRecord
  scope :plan, ->{ where type: 'Plan' }
end
