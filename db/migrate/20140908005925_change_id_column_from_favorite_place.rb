class ChangeIdColumnFromFavoritePlace < ActiveRecord::Migration
  def change
    change_column :favorite_places, :id, :bigint
  end
end
