prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>119737520605061022036
,p_default_application_id=>150074
,p_default_id_offset=>0
,p_default_owner=>'WKSP_CREEPREEE'
);
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(123189750976044967475)
,p_name=>'Breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(123196458379029543330)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(123370752839999952093)
,p_parent_id=>wwv_flow_imp.id(123196458379029543330)
,p_short_name=>'Supported Devices'
,p_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>2
);
wwv_flow_imp.component_end;
end;
/
