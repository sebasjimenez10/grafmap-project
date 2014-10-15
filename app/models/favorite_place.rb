# == Schema Information
#
# Table name: favorite_places
#
#  id         :integer          not null, primary key
#  user_id    :string(255)
#  category   :string(255)
#  latitud    :string(255)
#  longitud   :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class FavoritePlace < ActiveRecord::Base
end
