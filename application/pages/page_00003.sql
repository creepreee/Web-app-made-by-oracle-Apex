prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>119737520605061022036
,p_default_application_id=>150074
,p_default_id_offset=>0
,p_default_owner=>'WKSP_CREEPREEE'
);
wwv_flow_imp_page.create_page(
 p_id=>3
,p_name=>'Add SoC'
,p_alias=>'ADD-SOC'
,p_page_mode=>'MODAL'
,p_step_title=>'Add SoC'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(123419566442970752993)
,p_plug_name=>'Add SoC'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'SOCS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(123419569250050753005)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(123419569628256753006)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(123419569250050753005)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(123190821654180027224)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(123419566442970752993)
,p_button_name=>'BTN_SUBMIT_SOC'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'ADD'
,p_button_position=>'NEXT'
,p_show_processing=>'Y'
,p_confirm_message=>'Are you sure you wanna add this SOC?'
,p_confirm_style=>'warning'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190821183967027219)
,p_name=>'P3_DIALOG_MODE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(123419566442970752993)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190821821770027226)
,p_name=>'P3_SOC_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(123419566442970752993)
,p_item_source_plug_id=>wwv_flow_imp.id(123419566442970752993)
,p_source=>'SOC_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190821930692027227)
,p_name=>'P3_SOC_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(123419566442970752993)
,p_item_source_plug_id=>wwv_flow_imp.id(123419566442970752993)
,p_prompt=>'Soc Name'
,p_source=>'SOC_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123419567646976753003)
,p_name=>'P3_CATEGORY_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(123419566442970752993)
,p_item_source_plug_id=>wwv_flow_imp.id(123419566442970752993)
,p_prompt=>'Category'
,p_source=>'CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT category_name d, category_id r',
'FROM categories',
'ORDER BY category_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- SELECT TE CATEGORY --'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(123419569734900753006)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(123419569628256753006)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(123419570544582753007)
,p_event_id=>wwv_flow_imp.id(123419569734900753006)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(123190821320067027221)
,p_name=>'DA_Close_Dialog_On_Success'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(123419569628256753006)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(123190821447048027222)
,p_event_id=>wwv_flow_imp.id(123190821320067027221)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.submitResult === "SUCCESS"',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(123190821594000027223)
,p_event_id=>wwv_flow_imp.id(123190821320067027221)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.event.trigger(window.parent, ''ps:soc-added'');',
'apex.navigation.dialog.close();',
''))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123419572636005753009)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(123419566442970752993)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Add SoC'
,p_attribute_01=>'TABLE'
,p_attribute_03=>'SOCS'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(123190821654180027224)
,p_internal_uid=>123419572636005753009
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123419573061653753009)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>123419573061653753009
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123419572217972753008)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(123419566442970752993)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Add SoC'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>123419572217972753008
);
wwv_flow_imp.component_end;
end;
/
