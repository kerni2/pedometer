class Shoe < ApplicationRecord
  belongs_to :activity, optional: true
  belongs_to :user
end
