DECLARE
    l_id NUMBER;
BEGIN
wwv_flow_api.set_security_group_id(apex_util.find_security_group_id('WORKSPACE_NAME'));
    
    

    l_id := APEX_MAIL.SEND(
        p_to        => 'xx@xx.xx',
        p_from      => 'xx@xx.xx',
        p_subj      => 'APEX_MAIL with attachment',
        p_body      => 'Please review the attachment.',
        p_body_html => '<b>Please</b> review the attachment');
/*
    FOR c1 IN (SELECT filename, blob_content, mime_type 
        FROM APEX_APPLICATION_FILES
        WHERE ID IN (123,456)) LOOP

        APEX_MAIL.ADD_ATTACHMENT(
            p_mail_id    => l_id,
            p_attachment => c1.blob_content,
            p_filename   => c1.filename,
            p_mime_type  => c1.mime_type);
        END LOOP;
        */
    COMMIT;
END;
