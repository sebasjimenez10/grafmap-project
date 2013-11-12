/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.grafmap.application;

import javax.ws.rs.core.Response;

/**
 *
 * @author Sebastian
 */
public interface FavoritePlaceService {
    
    public Response addNewFavoritePlace( String favoritePlace );
    
    public String getUserFavoritePlaces( String user );
    
}
