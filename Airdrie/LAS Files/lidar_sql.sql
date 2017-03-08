copy elevation(x,y,z) FROM 'C:/0_5681.txt' DELIMITER ',';

SELECT AddGeometryColumn ('elevation','the_geom',3402,'POINT',2);

UPDATE elevation SET the_geom = ST_GeomFromText('POINT(' || x || ' ' || y || ')',3402);

CREATE INDEX elev_gix ON elevation USING GIST(the_geom);
