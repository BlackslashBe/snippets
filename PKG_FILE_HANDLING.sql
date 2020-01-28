CREATE OR REPLACE PACKAGE PKG_FILE_HANDLING AS 
  c_directory CONSTANT VARCHAR2(100) := 'EUREKA_UPLOADS';
  
  procedure p_test_write;
  
  procedure p_test_exists;

  procedure p_test_remove;
  
  
  PROCEDURE MOVE_APEX_FILES_TO_DIRECTORY(
    p_request_id IN NUMBER,
    p_filenames  IN VARCHAR2
  );
  
  FUNCTION FILE_EXISTS(
    p_request_id IN NUMBER,
    p_filenames  IN VARCHAR2
  ) RETURN VARCHAR2;
  
  PROCEDURE REMOVE_FILE(
    p_request_file_id IN NUMBER
  );
  
  PROCEDURE COPY_FILE(
    p_src_dir  IN VARCHAR2,
    p_src_file IN VARCHAR2,
    p_dest_dir IN VARCHAR2,
    p_dest_file IN VARCHAR2
  );
  
  FUNCTION loadBlobFromFile(
    p_file_name VARCHAR2,
    p_directory VARCHAR2 
  ) RETURN BLOB;
  
  PROCEDURE loadBlobToFile(
    p_blob IN BLOB,
    p_file_name IN NUMBER,
    p_directory  IN VARCHAR2
  );
  
END PKG_FILE_HANDLING;
/


CREATE OR REPLACE PACKAGE BODY PKG_FILE_HANDLING AS
--------------------------------------------------------------------------------
--
-- procedure p_test_write
--
--------------------------------------------------------------------------------
  PROCEDURE p_test_write AS
    l_file utl_file.file_type;
  BEGIN
    l_file := utl_file.fopen( c_directory, 'test_bjorn.txt', 'W' );
    utl_file.put_line( l_file, 'Here is some text' );
    utl_file.fclose( l_file );
  END p_test_write;
  
--------------------------------------------------------------------------------
--
-- procedure p_test_exists
--
--------------------------------------------------------------------------------
  procedure p_test_exists AS
    l_exists     boolean;
    l_size       integer;
    l_block_size integer;
  BEGIN
    utl_file.fgetattr( 
      c_directory, 
      'oracle.png', 
      l_exists, 
      l_size, 
      l_block_size 
    );
    
   if( l_exists ) then
     dbms_output.put_line( 'The file exists and has a size of ' || l_size );
   else
     dbms_output.put_line( 'The file does not exist or is not visible to Oracle' );
   end if;

  END p_test_exists;
  
  procedure p_test_remove AS
    l_file utl_file.file_type;
  BEGIN
    utl_file.fremove(c_directory, 'test_bjorn.txt');
   
  /*
    l_file := utl_file.fopen( c_directory, 'test_bjorn.txt', 'W' );
    utl_file.put_line( l_file, 'Here is some text' );
    utl_file.fclose( l_file );*/
  END p_test_remove;
  
  
  /*
  DECLARE
  l_file      UTL_FILE.FILE_TYPE;
  l_buffer    RAW(32767);
  l_amount    BINARY_INTEGER := 32767;
  l_pos       INTEGER := 1;
  l_blob      BLOB;
  l_blob_len  INTEGER;
BEGIN
  -- Get LOB locator
  SELECT col1
  INTO   l_blob
  FROM   tab1
  WHERE  rownum = 1;

  l_blob_len := DBMS_LOB.getlength(l_blob);
  
  -- Open the destination file.
  --l_file := UTL_FILE.fopen('BLOBS','MyImage.gif','w', 32767);
  l_file := UTL_FILE.fopen('BLOBS','MyImage.gif','wb', 32767);

  -- Read chunks of the BLOB and write them to the file
  -- until complete.
  WHILE l_pos < l_blob_len LOOP
    DBMS_LOB.read(l_blob, l_amount, l_pos, l_buffer);
    UTL_FILE.put_raw(l_file, l_buffer, TRUE);
    l_pos := l_pos + l_amount;
  END LOOP;
  
  -- Close the file.
  UTL_FILE.fclose(l_file);
  
EXCEPTION
  WHEN OTHERS THEN
    -- Close the file if something goes wrong.
    IF UTL_FILE.is_open(l_file) THEN
      UTL_FILE.fclose(l_file);
    END IF;
    RAISE;
END;



CREATE OR REPLACE DIRECTORY images AS 'C:\';
Next we create a table to hold the BLOB.

CREATE TABLE tab1 (
  id        NUMBER,
  blob_data BLOB
);
We import the file into a BLOB datatype and insert it into the table.

DECLARE
  l_bfile  BFILE;
  l_blob   BLOB;

  l_dest_offset INTEGER := 1;
  l_src_offset  INTEGER := 1;
BEGIN
  INSERT INTO tab1 (id, blob_data)
  VALUES (1, empty_blob())
  RETURN blob_data INTO l_blob;

  l_bfile := BFILENAME('IMAGES', 'MyImage.gif');
  DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
  -- loadfromfile deprecated.
  -- DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
  DBMS_LOB.loadblobfromfile (
    dest_lob    => l_blob,
    src_bfile   => l_bfile,
    amount      => DBMS_LOB.lobmaxsize,
    dest_offset => l_dest_offset,
    src_offset  => l_src_offset);
  DBMS_LOB.fileclose(l_bfile);

  COMMIT;
END;

To update an existing BLOB do the following.

DECLARE
  l_bfile  BFILE;
  l_blob   BLOB;

  l_dest_offset INTEGER := 1;
  l_src_offset  INTEGER := 1;
BEGIN
  SELECT blob_data
  INTO   l_blob
  FROM   tab1
  WHERE  id = 1
  FOR UPDATE;

  l_bfile := BFILENAME('IMAGES', 'MyImage.gif');
  DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
  DBMS_LOB.trim(l_blob, 0);
  -- loadfromfile deprecated.
  -- DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
  DBMS_LOB.loadblobfromfile (
    dest_lob    => l_blob,
    src_bfile   => l_bfile,
    amount      => DBMS_LOB.lobmaxsize,
    dest_offset => l_dest_offset,
    src_offset  => l_src_offset);
  DBMS_LOB.fileclose(l_bfile);
END;
  
  */
  
  
  PROCEDURE MOVE_APEX_FILES_TO_DIRECTORY(
    p_request_id IN NUMBER,
    p_filenames  IN VARCHAR2
  ) AS
    l_file_names    APEX_APPLICATION_GLOBAL.vc_arr2;
    r_rec           apex_application_temp_files%ROWTYPE;  
    l_file          UTL_FILE.FILE_TYPE;
    l_buffer        RAW(32767);
    l_amount        BINARY_INTEGER := 32767;
    l_pos           INTEGER := 1;
    l_blob          BLOB;
    l_blob_len      INTEGER;
  BEGIN
  
    l_file_names := apex_util.string_to_table( p_filenames );
  
    FOR i IN 1 .. l_file_names.COUNT LOOP
      -- RESET ALL VARIABLES
      l_file     := NULL;
      l_buffer   := NULL;
      l_amount   := 32767;
      l_pos      := 1;
      l_blob     := NULL;
      l_blob_len := 0;
    
  
      SELECT ID , APPLICATION_ID , NAME, case when FILENAME like '%\' then '' else substr(FILENAME, - instr(reverse(FILENAME), '\') + 1) end FILENAME, MIME_TYPE , CREATED_ON, BLOB_CONTENT
        INTO r_rec
        FROM apex_application_temp_files
       WHERE name = l_file_names(i);
       l_blob :=  r_rec.BLOB_CONTENT;
       
      --- Todo store local reference
      INSERT INTO REQUEST_FILES( REQUEST_ID, FILE_PATH)
      VALUES (p_request_id, r_rec.filename);
      
      --WRITE to server
      BEGIN
        -- Get LOB locator
        l_blob_len := DBMS_LOB.getlength(l_blob);
        
        -- Open the destination file.
        --l_file := UTL_FILE.fopen(c_directory,r_rec.FILENAME,'w', 32767);
        l_file := UTL_FILE.fopen(c_directory,'R'||p_request_id||'-'||r_rec.FILENAME,'wb', 32767);
        
        -- Read chunks of the BLOB and write them to the file
        -- until complete.
        WHILE l_pos < l_blob_len LOOP
          DBMS_LOB.read(l_blob, l_amount, l_pos, l_buffer);
          UTL_FILE.put_raw(l_file, l_buffer, TRUE);
          l_pos := l_pos + l_amount;
        END LOOP;
        
        -- Close the file.
        UTL_FILE.fclose(l_file);
      
      EXCEPTION
        WHEN OTHERS THEN
        -- Close the file if something goes wrong.
        IF UTL_FILE.is_open(l_file) THEN
          UTL_FILE.fclose(l_file);
        END IF;
        RAISE;
      END;
       
  
    END LOOP;
  
  END;
  
  
  FUNCTION FILE_EXISTS(
    p_request_id IN NUMBER,
    p_filenames  IN VARCHAR2
  ) RETURN VARCHAR2 AS
    CURSOR c_rf (p_filename IN VARCHAR2) IS
      SELECT 1 occ
        FROM request_files
       WHERE file_path = p_filename
         AND request_id = p_request_id;
       
    r_rf            c_rf%ROWTYPE;
    r_rec           apex_application_temp_files%ROWTYPE;
    l_error_message VARCHAR2(256);
    l_file_names    apex_application_global.vc_arr2;
    
  BEGIN
  
    l_file_names := apex_util.string_to_table( p_filenames );
    
    FOR i IN 1 .. l_file_names.COUNT LOOP
    
      -- Get file from apex table:
      SELECT ID , APPLICATION_ID , NAME, case when FILENAME like '%\' then '' else substr(FILENAME, - instr(reverse(FILENAME), '\') + 1) end FILENAME, MIME_TYPE , CREATED_ON, BLOB_CONTENT
        INTO r_rec
        FROM apex_application_temp_files
       WHERE name = l_file_names(i);
       
      -- Check if file exists in request files table
      OPEN c_rf(r_rec.FILENAME);
      FETCH c_rf INTO r_rf;
      IF c_rf%FOUND THEN
        CLOSE c_rf;
        l_error_message := common.pkg_parameters.get_parameter('ERR_FILE_EXISTS');
        EXIT;
      ELSE  
        CLOSE c_rf;
      END IF;
    END LOOP;
    
    RETURN l_error_message;
    
  END; 
  
  PROCEDURE REMOVE_FILE(
    p_request_file_id IN NUMBER
  ) AS
    CURSOR c_rf IS
      SELECT REQUEST_FILE_ID, REQUEST_ID, FILE_PATH
        FROM request_files rf
       WHERE request_file_id = p_request_file_id;
    r_rf c_rf%ROWTYPE;   
  BEGIN
    OPEN c_rf;
    FETCH c_rf INTO r_rf;
    CLOSE c_rf;
    
    -- remove file from server
    utl_file.fremove(c_directory, 'R'||r_rf.request_id||'-'||r_rf.file_path);
    
    -- remove file from table
    DELETE FROM request_files where request_file_id = p_request_file_id;
  
  END;


  

PROCEDURE COPY_FILE(
    p_src_dir  IN VARCHAR2,
    p_src_file IN VARCHAR2,
    p_dest_dir IN VARCHAR2,
    p_dest_file IN VARCHAR2
  ) AS
   in_file  utl_file.file_type;
   s        VARCHAR2(32767);
   r        RAW(32767);
   out_file utl_file.file_type;
BEGIN
   in_file  := utl_file.fopen(p_src_dir, p_src_file, 'rb',32767);
   out_file := utl_file.fopen(p_dest_dir, p_dest_file, 'wb',32767);
   LOOP
      
      --utl_file.put_line(in_file, s);
      --utl_file.put_line(out_file, s);
      utl_file.GET_RAW(in_file, r,32767);
      utl_file.put_raw(out_file, r);
   END LOOP;
EXCEPTION
   WHEN no_data_found THEN
          UTL_FILE.fclose(in_file);
          UTL_FILE.fclose(out_file);
END;

FUNCTION loadBlobFromFile(
    p_file_name VARCHAR2,
    p_directory VARCHAR2 
  ) RETURN BLOB AS
  dest_loc  BLOB := empty_blob();
  src_loc   BFILE := BFILENAME(p_directory, p_file_name);
BEGIN
  -- Open source binary file from OS
  DBMS_LOB.OPEN(src_loc, DBMS_LOB.LOB_READONLY);
  
  -- Create temporary LOB object
  DBMS_LOB.CREATETEMPORARY(
        lob_loc => dest_loc
      , cache   => true
      , dur     => dbms_lob.session
  );
    
  -- Open temporary lob
  DBMS_LOB.OPEN(dest_loc, DBMS_LOB.LOB_READWRITE);
  
  -- Load binary file into temporary LOB
  DBMS_LOB.LOADFROMFILE(
        dest_lob => dest_loc
      , src_lob  => src_loc
      , amount   => DBMS_LOB.getLength(src_loc));
  
  -- Close lob objects
  DBMS_LOB.CLOSE(dest_loc);
  DBMS_LOB.CLOSE(src_loc);
  
  -- Return temporary LOB object
  RETURN dest_loc;
END loadBlobFromFile;


PROCEDURE loadBlobToFile(
    p_blob IN BLOB,
    p_file_name IN NUMBER,
    p_directory  IN VARCHAR2
  ) AS
  

    r_rec           apex_application_temp_files%ROWTYPE;  
    l_file          UTL_FILE.FILE_TYPE;
    l_buffer        RAW(32767);
    l_amount        BINARY_INTEGER := 32767;
    l_pos           INTEGER := 1;
    l_blob          BLOB;
    l_blob_len      INTEGER;
  BEGIN
  

      -- RESET ALL VARIABLES
      l_file     := NULL;
      l_buffer   := NULL;
      l_amount   := 32767;
      l_pos      := 1;
      l_blob     := NULL;
      l_blob_len := 0;
    

       l_blob :=  p_blob;

      
      --WRITE to server
      BEGIN
        -- Get LOB locator
        l_blob_len := DBMS_LOB.getlength(l_blob);
        
        -- Open the destination file.
        l_file := UTL_FILE.fopen(p_directory,p_file_name,'wb', 32767);
        
        -- Read chunks of the BLOB and write them to the file
        -- until complete.
        WHILE l_pos < l_blob_len LOOP
          DBMS_LOB.read(l_blob, l_amount, l_pos, l_buffer);
          UTL_FILE.put_raw(l_file, l_buffer, TRUE);
          l_pos := l_pos + l_amount;
        END LOOP;
        
        -- Close the file.
        UTL_FILE.fclose(l_file);
      
      EXCEPTION
        WHEN OTHERS THEN
        -- Close the file if something goes wrong.
        IF UTL_FILE.is_open(l_file) THEN
          UTL_FILE.fclose(l_file);
        END IF;
        RAISE;
      END;
       
  END;







END PKG_FILE_HANDLING;
/
