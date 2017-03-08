ALTER TABLE buildings ADD COLUMN height double precision Null;

UPDATE buildings SET height = avgheight FROM (
SELECT b.gid, avg(e.z) as avgheight 
FROM elevation e, buildings b
WHERE ST_within(e.the_geom, b.geom) GROUP BY b.gid
) t
WHERE buildings.gid = t.gid;

CREATE TABLE buildings2m AS SELECT * FROM buildings;


UPDATE buildings2m SET geom2D = ST_MAKEVALID(geom2D);


UPDATE buildings2m SET geom2D = buffer FROM (
SELECT y.gid, st_multi(ST_DIFFERENCE(st_multi(ST_Buffer(y.geom2D, 2)), st_multi(ST_buffer(y.geom2D, 1)))) As buffer
FROM buildings2m y
WHERE y.gid > 0
) t
WHERE buildings2m.gid = t.gid;
UPDATE buildings2m SET geom = buffer FROM (
SELECT b2.gid, st_multi(ST_DIFFERENCE(st_multi(ST_BUFFER(b2.geom,2)),st_multi(ST_buffer(b2.geom,1)))) as buffer
FROM buildings2m b2
WHERE b2.gid > 0
) t
WHERE buildings2m.gid = t.gid;