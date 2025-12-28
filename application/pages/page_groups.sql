prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 150074
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>119737520605061022036
,p_default_application_id=>150074
,p_default_id_offset=>0
,p_default_owner=>'WKSP_CREEPREEE'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(123189756587563967485)
,p_group_name=>'Administration'
);
wwv_flow_imp.component_end;
end;
/
