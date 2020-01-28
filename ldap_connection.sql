
DECLARE
    retval              PLS_INTEGER;
    my_session          DBMS_LDAP.session;
    my_attrs            DBMS_LDAP.string_collection;
    my_message          DBMS_LDAP.message;
    my_entry            DBMS_LDAP.message;
    entry_index         PLS_INTEGER;
    my_dn               VARCHAR2(256);
    my_attr_name        VARCHAR2(256);
    my_ber_elmt         DBMS_LDAP.ber_element;
    attr_index          PLS_INTEGER;
    i                   PLS_INTEGER;
    my_vals             DBMS_LDAP.STRING_COLLECTION ;
    ldap_host           VARCHAR2(256);
    ldap_port           VARCHAR2(256);
    ldap_user           VARCHAR2(256);
    ldap_passwd         VARCHAR2(256);
    ldap_base           VARCHAR2(256);
BEGIN

    -- Please customize the following variables as needed
    ldap_host  := 'xxxxx' ;
    ldap_port  := '389';
    ldap_user  := 'CN=xx,OU=xx,OU=xx,DC=xx,DC=xx,DC=xx';
    ldap_passwd:= 'xxxx';
    ldap_base  := 'OU=xx,OU=xx,OU=xx,DC=xx,DC=xx,DC=xx';
    -- end of customizable settings

    retval := -1;
    DBMS_OUTPUT.PUT('DBMS_LDAP Search Example ');
    DBMS_OUTPUT.PUT_LINE('to directory .. ');
    DBMS_OUTPUT.PUT_LINE(RPAD('LDAP Host ',25,' ') || ': ' || ldap_host);
    DBMS_OUTPUT.PUT_LINE(RPAD('LDAP Port ',25,' ') || ': ' || ldap_port);

    -- Choosing exceptions to be raised by DBMS_LDAP library.
    DBMS_LDAP.USE_EXCEPTION := TRUE;

    my_session := DBMS_LDAP.init(ldap_host,ldap_port);

    DBMS_OUTPUT.PUT_LINE (RPAD('Ldap session ',25,' ')  || ': ' || RAWTOHEX(SUBSTR(my_session,1,8)) || '(returned from init)');

    -- bind to the directory
    retval := DBMS_LDAP.simple_bind_s(my_session, ldap_user, ldap_passwd);

    DBMS_OUTPUT.PUT_LINE(RPAD('simple_bind_s Returns ',25,' ') || ': '|| TO_CHAR(retval));

    -- issue the search
    my_attrs(1) := '*'; -- retrieve all attributes

    -- an example how to get only some attributes
    -- my_attrs(1) := 'sAMAccountName';
    -- my_attrs(2) := 'userAccountControl';
    -- my_attrs(3) := 'lastLogon';
    -- my_attrs(4) := 'badPasswordTime';
    -- my_attrs(5) := 'pwdLastSet';


    retval := DBMS_LDAP.search_s(my_session, ldap_base,
                                 DBMS_LDAP.SCOPE_SUBTREE,
                                 'objectClass=user',
                                 my_attrs,
                                 0,
                                 my_message);

    DBMS_OUTPUT.PUT_LINE(RPAD('search_s Returns ',25,' ') || ': '|| TO_CHAR(retval));
    DBMS_OUTPUT.PUT_LINE (RPAD('LDAP message  ',25,' ')  || ': ' || RAWTOHEX(SUBSTR(my_message,1,8)) || '(returned from search_s)');

    -- count the number of entries returned
    retval := DBMS_LDAP.count_entries(my_session, my_message);
    DBMS_OUTPUT.PUT_LINE(RPAD('Number of Entries ',25,' ') || ': '|| TO_CHAR(retval));
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');


    -- get the first entry
    my_entry := DBMS_LDAP.first_entry(my_session, my_message);
    entry_index := 1;

    -- Loop through each of the entries one by one
    while my_entry IS NOT NULL loop
        -- print the current entry
        my_dn := DBMS_LDAP.get_dn(my_session, my_entry);
        DBMS_OUTPUT.PUT_LINE ('        dn: ' || my_dn);

        my_attr_name := DBMS_LDAP.first_attribute(my_session,my_entry, my_ber_elmt);
        attr_index := 1;

        while my_attr_name IS NOT NULL loop
            --some attributes are no human readable, just skip them
            if my_attr_name not in ('objectGUID', 'objectSid', 'dnsRecord') then
                begin
                    my_vals := DBMS_LDAP.get_values (my_session, my_entry, my_attr_name);
                    if my_vals.COUNT > 0 then
                        FOR i in my_vals.FIRST..my_vals.LAST loop
                            DBMS_OUTPUT.PUT_LINE('           ' || my_attr_name || ' : '|| SUBSTR(my_vals(i),1,200));
                        end loop;
                    end if;
                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('           ' || my_attr_name || ' : fetch error '||SQLERRM);
                END;
            end if;
            my_attr_name := DBMS_LDAP.next_attribute(my_session,my_entry, my_ber_elmt);
            attr_index := attr_index+1;
        end loop;
        my_entry := DBMS_LDAP.next_entry(my_session, my_entry);
        DBMS_OUTPUT.PUT_LINE('===================================================');
        entry_index := entry_index+1;
        
        IF entry_index = 10 THEN
          EXIT;
        END IF;
    end loop;

    -- unbind from the directory
    retval := DBMS_LDAP.unbind_s(my_session);
    DBMS_OUTPUT.PUT_LINE(RPAD('unbind_res Returns ',25,' ') || ': ' || TO_CHAR(retval));
    DBMS_OUTPUT.PUT_LINE('Directory operation Successful .. exiting');

-- Handle Exceptions
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Error code    : ' || TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE(' Error Message : ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE(' Exception encountered .. exiting');
END;
