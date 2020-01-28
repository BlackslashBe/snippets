prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>14230907643309512
,p_default_application_id=>99999
,p_default_owner=>'IT_CHECK'
);
end;
/
prompt --application/shared_components/plugins/process_type/ru_eurochem_atw_irscrollbarsplugin
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(19807327594680762)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'RU.EUROCHEM.ATW.IRSCROLLBARSPLUGIN'
,p_display_name=>'Interactive Report Scrollbars Plugin'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render(',
'    p_process in apex_plugin.t_process,',
'	p_plugin  in apex_plugin.t_plugin',
') RETURN apex_plugin.t_process_exec_result IS',
'  ',
'  l_result           APEX_PLUGIN.t_process_exec_result;',
'begin',
'  if apex_application.g_debug then',
'    apex_plugin_util.debug_process (',
'	  p_plugin => p_plugin,',
'	  p_process => p_process',
'	);',
'  end if;',
'',
'  ',
'    -- Eigene JS Library einbinden',
'    APEX_JAVASCRIPT.add_library(p_name           => ''plugin.apex.IRScrollbars'',',
'                                p_directory      => p_plugin.file_prefix,',
'                                p_version        => NULL,',
'                                p_skip_extension => FALSE);',
'  ',
'  ',
'    -- add onload code',
'    APEX_JAVASCRIPT.add_onload_code(p_code => ''init_plugin();'');',
'    --',
'    APEX_CSS.add(',
'      p_css => ''.t-Body-nav {  z-index: 400; }'',',
'      p_key => ''setbodyindex''',
'    );',
'  ',
'  ',
'  return l_result;',
'end;'))
,p_api_version=>2
,p_execution_function=>'render'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0.0'
,p_files_version=>2
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E2061646A757374426F647957696474682829207B0D0A202076617220772C2064656C7461203D20303B0D0A20202428222E612D4952522D7461626C6522292E656163682866756E6374696F6E2829207B0D0A20202020202076617220';
wwv_flow_api.g_varchar2_table(2) := '64203D20242874686973292E77696474682829202D20242874686973292E706172656E7428292E776964746828293B0D0A202020202020696620282064203E2064656C74612029207B0D0A202020202020202064656C7461203D20643B0D0A2020202020';
wwv_flow_api.g_varchar2_table(3) := '207D0D0A20207D293B0D0A0D0A2020696620282064656C7461203E20302029207B0D0A2020202077203D20242822626F647922292E776964746828293B0D0A20202020242822626F647922292E77696474682877202B2064656C7461293B0D0A20207D0D';
wwv_flow_api.g_varchar2_table(4) := '0A7D0D0A0D0A66756E6374696F6E20696E69745F706C7567696E28297B0D0A202061646A757374426F6479576964746828293B0D0A0D0A2020242877696E646F77292E6F6E28226170657877696E646F77726573697A6564222C2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(5) := '29207B0D0A2020202061646A757374426F6479576964746828293B0D0A20207D293B0D0A0D0A2020766172206C61737458203D20303B0D0A2020200D0A2020242877696E646F77292E6F6E28227363726F6C6C222C2066756E6374696F6E2829207B0D0A';
wwv_flow_api.g_varchar2_table(6) := '202020207661722078203D2077696E646F772E7363726F6C6C583B0D0A2020202069662028207820213D3D206C617374582029207B0D0A2020202020206C61737458203D20783B0D0A2020202020202428222E6A732D737469636B795769646765742D74';
wwv_flow_api.g_varchar2_table(7) := '6F67676C6522292E656163682866756E6374696F6E2829207B0D0A202020202020202076617220737724203D20242874686973292C0D0A202020202020202064203D207377242E706172656E7428292E6F666673657428292E6C656674202D20783B0D0A';
wwv_flow_api.g_varchar2_table(8) := '0D0A202020202020202069662028207377242E686173436C617373282269732D737475636B222929207B0D0A202020202020202020207377242E63737328226C656674222C2064202B2022707822293B0D0A20202020202020207D20656C7365207B0D0A';
wwv_flow_api.g_varchar2_table(9) := '202020202020202020207377242E63737328226C656674222C202222293B0D0A20202020202020207D0D0A2020202020207D293B0D0A202020207D0D0A20207D293B0D0A0D0A20202F2F20737469636B792077696467657473206172656E277420637265';
wwv_flow_api.g_varchar2_table(10) := '617465642079657420736F20776169742E20506572686170732062657474657220746F206C697374656E20666F72206372656174650D0A202073657454696D656F75742866756E6374696F6E2829207B0D0A202020202428222E6A732D737469636B7957';
wwv_flow_api.g_varchar2_table(11) := '69646765742D746F67676C6522292E656163682866756E6374696F6E2829207B0D0A20202020202076617220737724203D20242874686973293B0D0A0D0A2020202020202F2F2074686573652073686F756C64206265207265616C6C206576656E747320';
wwv_flow_api.g_varchar2_table(12) := '6E6F742063616C6C6261636B73210D0A2020202020207377242E737469636B7957696467657428226F7074696F6E222C20226F6E537469636B222C2066756E6374696F6E2829207B0D0A20202020202020207661722064203D207377242E706172656E74';
wwv_flow_api.g_varchar2_table(13) := '28292E6F666673657428292E6C656674202D2077696E646F772E7363726F6C6C583B0D0A20202020202020207377242E63737328226C656674222C2064202B2022707822293B0D0A2020202020207D293B0D0A0D0A2020202020207377242E737469636B';
wwv_flow_api.g_varchar2_table(14) := '7957696467657428226F7074696F6E222C20226F6E556E737469636B222C2066756E6374696F6E2829207B0D0A20202020202020207377242E63737328226C656674222C202222293B0D0A2020202020207D293B0D0A202020207D290D0A20207D2C2035';
wwv_flow_api.g_varchar2_table(15) := '3030293B0D0A0D0A2020242822626F647922292E6F6E2822617065786265666F726572656672657368222C2066756E6374696F6E2829207B0D0A20202020242822626F647922292E63737328227769647468222C2222293B0D0A20207D293B0D0A0D0A20';
wwv_flow_api.g_varchar2_table(16) := '20242822626F647922292E6F6E282261706578616674657272656672657368222C2066756E6374696F6E2829207B0D0A2020202061646A757374426F6479576964746828293B0D0A20207D293B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(19807815098724829)
,p_plugin_id=>wwv_flow_api.id(19807327594680762)
,p_file_name=>'plugin.apex.IRScrollbars.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done