ALTER TABLE buildings2m ADD COLUMN my_geom geometry(MultiPolygon,3776);
UPDATE buildings2m SET my_geom = ST_makevalid(ST_Force2D(geom));

UPDATE buildings2m SET my_geom = buffer FROM (
SELECT y.gid, st_multi(ST_DIFFERENCE(st_multi(ST_Buffer(y.my_geom, 2)), st_multi(ST_buffer(y.my_geom, 1)))) As buffer
FROM buildings2m y
WHERE y.gid > 0
) t
WHERE buildings2m.gid = t.gid;

UPDATE buildings2m SET height = minheight FROM (
SELECT y.gid, min(x.z) As minheight
FROM elevation x, buildings2m y
WHERE ST_within(x.the_geom, y.geom) GROUP BY y.gid
) t
WHERE buildings2m.gid = t.gid;

ALTER TABLE buildings ADD COLUMN gheight double precision NULL;

UPDATE buildings x SET gheight = y.height FROM buildings2m y WHERE x.gid = y.gid;

ALTER TABLE buildings ADD COLUMN buildheight double precision NULL;

UPDATE buildings set buildheight = (height - gheight);

SELECT ST_Extent(the_geom) from elevation;