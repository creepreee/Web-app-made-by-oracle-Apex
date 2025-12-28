prompt --application/shared_components/user_interface/lovs/socs_soc_name
begin
--   Manifest
--     SOCS.SOC_NAME
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
 p_id=>wwv_flow_imp.id(123384581776145730596)
,p_lov_name=>'SOCS.SOC_NAME'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'SOCS'
,p_return_column_name=>'SOC_ID'
,p_display_column_name=>'SOC_NAME'
,p_default_sort_column_name=>'SOC_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>15687673558842
);
wwv_flow_imp.component_end;
end;
/
