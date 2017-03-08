CREATE TABLE buildings3d AS SELECT * FROM buildings ORDER by buildheight;
ALTER TABLE buildings3d

ALTER TABLE buildings3d ADD COLUMN my_geom geometry(MultiPolygon,3776);
ALTER TABLE buildings3d ADD COLUMN my_geom1 geometry(MultiPolygon,900913);
UPDATE buildings3d SET my_geom = ST_Force2D(geom);
UPDATE buildings3d SET my_geom1 = ST_Transform(my_geom,900913);