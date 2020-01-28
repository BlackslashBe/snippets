DECLARE
  req utl_http.req;
  resp sys.utl_http.resp;
  txt       VARCHAR2(4000);
  v_counter INTEGER;
  v_return  VARCHAR2(100);
  
  rw varchar2(32767);


BEGIN
  UTL_HTTP.set_wallet (
     path      =>  'file:' || 'e:\walletlocation\', 
     password  => 'walletpassword'
  );
  
  
  req := sys.utl_http.begin_request('https://url/','GET','HTTP/1.0');
  utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');
  resp := utl_http.get_response(req);
  
  loop
  begin 
  rw := null; 
  utl_http.read_line(resp, rw, TRUE); 
  dbms_output.put_line(rw);
  -- process rw
  exception when others then exit;
  end;
  end loop; 
  utl_http.end_response(resp);
  
  
END ;
