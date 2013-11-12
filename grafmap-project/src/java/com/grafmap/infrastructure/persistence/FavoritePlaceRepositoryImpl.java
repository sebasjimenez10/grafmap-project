/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.grafmap.infrastructure.persistence;

import com.grafmap.domain.FavoritePlace;
import com.grafmap.domain.FavoritePlaceRepository;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Sebastian
 */
public class FavoritePlaceRepositoryImpl implements FavoritePlaceRepository {

    private static final Set<FavoritePlace> favoritePlaces = Collections.synchronizedSet(new HashSet<FavoritePlace>());

    @Override
    public void store(FavoritePlace favoritePlace) {

        boolean exists = false;
        for (FavoritePlace favItem : favoritePlaces) {
            if (favItem.getUserId().equals(favoritePlace.getUserId()) && favItem.getId().equals(favoritePlace.getId())) {
                exists = true;
                break;
            }
        }


        if (!exists) {

            favoritePlaces.add(favoritePlace);
            System.out.println("Favorite place added: " + favoritePlace.getName() + " in position: " + favoritePlaces.size());
        } else {

            System.out.println("User already has that place as favorite");
        }

    }

    @Override
    public ArrayList<FavoritePlace> retriveAllByUser(String userId) {

        ArrayList<FavoritePlace> userFavPlaces = new ArrayList<>();

        for (FavoritePlace favoritePlace : favoritePlaces) {
            if (favoritePlace.getUserId().equals(userId)) {
                userFavPlaces.add(favoritePlace);
            }
        }

        return userFavPlaces;
    }
}
