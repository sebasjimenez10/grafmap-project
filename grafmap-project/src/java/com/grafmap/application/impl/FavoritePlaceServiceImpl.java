/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.grafmap.application.impl;

import com.grafmap.application.FavoritePlaceService;
import com.grafmap.domain.FavoritePlace;
import com.grafmap.domain.FavoritePlaceRepository;
import com.grafmap.infrastructure.persistence.FavoritePlaceRepositoryImpl;
import java.util.ArrayList;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Sebastian
 */
@Path("/favorite")
public class FavoritePlaceServiceImpl implements FavoritePlaceService {

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Override
    public Response addNewFavoritePlace(String favoritePlace) {

        try {
            System.out.println("User: " + favoritePlace);
            JSONObject jFavoritePlace = new JSONObject(favoritePlace);

            FavoritePlace favoritePlaceObj = new FavoritePlace();

            favoritePlaceObj.setId(jFavoritePlace.getString("id"));
            favoritePlaceObj.setUserId(jFavoritePlace.getString("user_id"));
            favoritePlaceObj.setName(jFavoritePlace.getString("name"));
            favoritePlaceObj.setCategory(jFavoritePlace.getString("category"));
            favoritePlaceObj.setLatitud(jFavoritePlace.getString("latitud"));
            favoritePlaceObj.setLongitud(jFavoritePlace.getString("longitud"));

            favoritePlaceObj.store();
        } catch (Exception e) {
            return Response.status(500).entity(e).build();
        }

        return Response.status(200).entity(favoritePlace).build();
    }

    @GET
    @Path("/{user}")
    @Produces(MediaType.APPLICATION_JSON)
    @Override
    public String getUserFavoritePlaces(@PathParam("user") String user) {

        try {

            System.out.println("User: " + user);

            FavoritePlaceRepository fpRepo = new FavoritePlaceRepositoryImpl();
            ArrayList<FavoritePlace> retriveAllByUser = fpRepo.retriveAllByUser(user);

            JSONArray responseArray = new JSONArray();

            for (FavoritePlace favoritePlace : retriveAllByUser) {
                JSONObject favObj = new JSONObject();

                favObj.put("user_id", favoritePlace.getUserId());
                favObj.put("id", favoritePlace.getId());
                favObj.put("category", favoritePlace.getCategory());
                favObj.put("latitud", favoritePlace.getLatitud());
                favObj.put("longitud", favoritePlace.getLongitud());
                favObj.put("name", favoritePlace.getName());

                responseArray.put(favObj);

            }
            
            return responseArray.toString();
            
        } catch (Exception e) {
            JSONObject jsonError = new JSONObject();
            jsonError.put("error", e.getMessage());
            return jsonError.toString();
        }
    }
}