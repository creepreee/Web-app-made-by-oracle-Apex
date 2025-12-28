prompt --application/shared_components/user_interface/lovs/manufacturers_manufacturer_name
begin
--   Manifest
--     MANUFACTURERS.MANUFACTURER_NAME
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>119737520605061022036
,p_default_application_id=>150074
,p_default_id_offset=>0
,p_default_owner=>'WKSP_CREEPREEE'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(123384582407152730597)
,p_lov_name=>'MANUFACTURERS.MANUFACTURER_NAME'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'MANUFACTURERS'
,p_return_column_name=>'MANUFACTURER_ID'
,p_display_column_name=>'MANUFACTURER_NAME'
,p_default_sort_column_name=>'MANUFACTURER_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>15687673558870
);
wwv_flow_imp.component_end;
end;
/
