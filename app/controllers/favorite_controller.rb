class FavoriteController < ApplicationController

  def create
    @favorite = FavoritePlace.new(favorite_params)

    if @favorite.save
      respond_to do |format|
        format.json { render status: 200, json: @favorite.to_json }
      end
    else
      respond_to do |format|
        format.json { render status: 500, json: "{ \"error\": 500 }" }
      end
    end
  end

  def get
    @favorite_places = FavoritePlace.where(user_id: params[:id])
    respond_to do |format|
      format.json { render :json => @favorite_places.to_json }
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:id, :user_id, :latitud, :longitud)
  end
end
