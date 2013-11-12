/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.grafmap.domain;

import java.util.ArrayList;

/**
 *
 * @author Sebastian
 */
public interface FavoritePlaceRepository {

    public void store(FavoritePlace favoritePlace);

    public ArrayList<FavoritePlace> retriveAllByUser(String userId);
}
