/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.grafmap.domain;

import com.grafmap.infrastructure.persistence.FavoritePlaceRepositoryImpl;

/**
 *
 * @author Sebastian
 */
public class FavoritePlace {
    
    private String userId;
    private String category;
    private String id;
    private String latitud;
    private String longitud;
    private String name;
    
    private FavoritePlaceRepository fpRepo;

    public FavoritePlace() {
        fpRepo = new FavoritePlaceRepositoryImpl();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLatitud() {
        return latitud;
    }

    public void setLatitud(String latitud) {
        this.latitud = latitud;
    }

    public String getLongitud() {
        return longitud;
    }

    public void setLongitud(String longitud) {
        this.longitud = longitud;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void store() {
        fpRepo.store(this);
    }
    
}
