/**
 * This class is generated by jOOQ
 */
package com.grafmap.infrastructure.persistence.tables;

/**
 * This class is generated by jOOQ.
 */
@javax.annotation.Generated(value    = { "http://www.jooq.org", "3.1.0" },
                            comments = "This class is generated by jOOQ")
@java.lang.SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class FavoritePlace extends org.jooq.impl.TableImpl<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord> {

	private static final long serialVersionUID = -206933029;

	/**
	 * The singleton instance of <code>grafmap.favorite_place</code>
	 */
	public static final com.grafmap.infrastructure.persistence.tables.FavoritePlace FAVORITE_PLACE = new com.grafmap.infrastructure.persistence.tables.FavoritePlace();

	/**
	 * The class holding records for this type
	 */
	@Override
	public java.lang.Class<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord> getRecordType() {
		return com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord.class;
	}

	/**
	 * The column <code>grafmap.favorite_place.id</code>. 
	 */
	public final org.jooq.TableField<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord, java.lang.String> ID = createField("id", org.jooq.impl.SQLDataType.VARCHAR.length(45), this);

	/**
	 * The column <code>grafmap.favorite_place.user_id</code>. 
	 */
	public final org.jooq.TableField<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord, java.lang.String> USER_ID = createField("user_id", org.jooq.impl.SQLDataType.VARCHAR.length(45), this);

	/**
	 * The column <code>grafmap.favorite_place.name</code>. 
	 */
	public final org.jooq.TableField<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord, java.lang.String> NAME = createField("name", org.jooq.impl.SQLDataType.VARCHAR.length(45), this);

	/**
	 * The column <code>grafmap.favorite_place.category</code>. 
	 */
	public final org.jooq.TableField<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord, java.lang.String> CATEGORY = createField("category", org.jooq.impl.SQLDataType.VARCHAR.length(45), this);

	/**
	 * The column <code>grafmap.favorite_place.latitud</code>. 
	 */
	public final org.jooq.TableField<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord, java.lang.String> LATITUD = createField("latitud", org.jooq.impl.SQLDataType.VARCHAR.length(45), this);

	/**
	 * The column <code>grafmap.favorite_place.longitud</code>. 
	 */
	public final org.jooq.TableField<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord, java.lang.String> LONGITUD = createField("longitud", org.jooq.impl.SQLDataType.VARCHAR.length(45), this);

	/**
	 * Create a <code>grafmap.favorite_place</code> table reference
	 */
	public FavoritePlace() {
		super("favorite_place", com.grafmap.infrastructure.persistence.Grafmap.GRAFMAP);
	}

	/**
	 * Create an aliased <code>grafmap.favorite_place</code> table reference
	 */
	public FavoritePlace(java.lang.String alias) {
		super(alias, com.grafmap.infrastructure.persistence.Grafmap.GRAFMAP, com.grafmap.infrastructure.persistence.tables.FavoritePlace.FAVORITE_PLACE);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public org.jooq.UniqueKey<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord> getPrimaryKey() {
		return com.grafmap.infrastructure.persistence.Keys.KEY_FAVORITE_PLACE_PRIMARY;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public java.util.List<org.jooq.UniqueKey<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord>> getKeys() {
		return java.util.Arrays.<org.jooq.UniqueKey<com.grafmap.infrastructure.persistence.tables.records.FavoritePlaceRecord>>asList(com.grafmap.infrastructure.persistence.Keys.KEY_FAVORITE_PLACE_PRIMARY);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public com.grafmap.infrastructure.persistence.tables.FavoritePlace as(java.lang.String alias) {
		return new com.grafmap.infrastructure.persistence.tables.FavoritePlace(alias);
	}
}