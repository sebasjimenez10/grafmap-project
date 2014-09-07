class CreateFavoritePlaces < ActiveRecord::Migration
  def change
    create_table :favorite_places do |t|
      t.string :user_id
      t.string :category
      t.string :latitud
      t.string :longitud
      t.string :name

      t.timestamps
    end
  end
end
