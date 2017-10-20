set define off;

/* XXX: Insert password(s) if missing: 
http://www.random.org/strings/?num=4&len=8&digits=on&loweralpha=on&unique=on&format=html&rnd=new
insert into fis_frpa_pd (fis_id, pd) values ('id1','pd1');
commit;
*/

select p.fis_id, w.pd, p.lastfirstname, d.last_updated
from fis_document d, fis_person p, fis_frpa_pd w
where d.fis_doc_type = 'PHOTO' 
and d.last_updated > '30-APR-12' 
and d.fis_id = p.fis_id
and p.fis_id = w.fis_id(+)
order by d.last_updated;
