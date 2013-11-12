/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.grafmap.infrastructure.persistence;

import com.grafmap.domain.FavoritePlace;
import com.grafmap.domain.FavoritePlaceRepository;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jooq.DSLContext;
import org.jooq.Record;
import org.jooq.Result;
import org.jooq.SQLDialect;
import org.jooq.SelectConditionStep;
import org.jooq.impl.DSL;

/**
 *
 * @author Sebastian
 */
public class FavoritePlacePersistence implements FavoritePlaceRepository {

    private Connection conn;
    private DSLContext create;

    public FavoritePlacePersistence() {
        try {
            conn = getConnection();
            create = DSL.using(conn, SQLDialect.MYSQL);
        } catch (IOException e) {
            Logger.getLogger(FavoritePlacePersistence.class.getName()).log(Level.SEVERE,
                    "It was not possible to instance DB Driver", e);
        }

    }

    @Override
    public void store(FavoritePlace favoritePlace) {

        create.insertInto(com.grafmap.infrastructure.persistence.tables.FavoritePlace.FAVORITE_PLACE)
                .set(com.grafmap.infrastructure.persistence.tables.FavoritePlace.FAVORITE_PLACE.ID, favoritePlace.getId())
                .set(com.grafmap.infrastructure.persistence.tables.FavoritePlace.FAVORITE_PLACE.USER_ID, favoritePlace.getUserId())
                .set(com.grafmap.infrastructure.persistence.tables.FavoritePlace.FAVORITE_PLACE.LATITUD, favoritePlace.getLatitud())
                .set(com.grafmap.infrastructure.persistence.tables.FavoritePlace.FAVORITE_PLACE.LONGITUD, favoritePlace.getLongitud())
                .execute();

        System.out.println("Favorite place inserted");

    }

    @Override
    public ArrayList<FavoritePlace> retriveAllByUser(String userId) {
        Result<Record> fetch = create.select()
                .from(com.grafmap.infrastructure.persistence.tables.FavoritePlace.FAVORITE_PLACE)
                .where(com.grafmap.infrastructure.persistence.tables.FavoritePlace.FAVORITE_PLACE.USER_ID.equal(userId))
                .fetch();
        
        System.out.println("Size: " + fetch.size());
        
        ArrayList<FavoritePlace> favList = new ArrayList<>();
        
        for (int i = 0; i < fetch.size(); i++) {
            Record record = fetch.get(i);
            
            FavoritePlace fp = new FavoritePlace();
            fp.setId(record.getValue("id").toString());
            fp.setUserId(record.getValue("user_id").toString());
            fp.setLatitud(record.getValue("latitud").toString());
            fp.setLongitud(record.getValue("longitud").toString());
            
            favList.add(fp);
            
        }

        return favList;
    }

    private Connection getConnection() throws IOException {

        if (conn == null) {

            String db_host = "localhost";
            String db_name = "grafmap";
            String db_user = "root";
            String db_password = "root";

            String url = "jdbc:mysql://" + db_host + ":3306/" + db_name;

            try {
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                conn = (Connection) DriverManager.getConnection(url, db_user, db_password);
            } catch (InstantiationException | IllegalAccessException | ClassNotFoundException | SQLException e) {
                Logger.getLogger(FavoritePlacePersistence.class.getName()).log(Level.SEVERE,
                        "It was not possible to instance DB Driver", e);
            }
        }

        return conn;
    }
}
