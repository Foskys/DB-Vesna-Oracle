CREATE USER C##SHM 
IDENTIFIED BY Pa$$w0rd;
SELECT * FROM V$PDBS;

CREATE PLUGGABLE DATABASE SH_PDB
  ADMIN USER admin_sys IDENTIFIED BY "qwerty1234"
  FILE_NAME_CONVERT = ('/opt/oracle/oradata/FREE/pdbseed/', 
                      '/opt/oracle/oradata/CDB/my_new_pdb/');

ALTER PLUGGABLE DATABASE ALL OPEN;
grant create table to C##SHM;
grant insert any table to C##SHM;
grant select on u1_shm_pdb.shm_table to c##shm;

