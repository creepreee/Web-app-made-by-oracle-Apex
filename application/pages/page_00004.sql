prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_name=>'Device Details Editor'
,p_alias=>'DEVICE-DETAILS-EDITOR'
,p_page_mode=>'MODAL'
,p_step_title=>'Device Details Editor'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function saveUefiFromIG() {',
'',
'  var ig = apex.region("ig_uefi");',
'  if (!ig) {',
'    alert("UEFI grid not ready");',
'    return;',
'  }',
'',
'  var grid  = ig.widget().interactiveGrid("getViews", "grid");',
'  var model = grid.model;',
'',
'  var payload = {',
'    device_id: $v("P939_DEVICE_ID"),   // <-- MUST exist',
'    uefi: []',
'  };',
'',
'  model.forEach(function(rec){',
'',
'    var state =',
'      model.getValue(rec, "CHK_WORKING") === ''Y''     ? ''WORKING'' :',
'      model.getValue(rec, "CHK_NOTWORKING") === ''Y''  ? ''NOT_WORKING'' :',
'      model.getValue(rec, "CHK_UNKNOWN") === ''Y''     ? ''UNKNOWN'' :',
'      ''UNTESTED'';',
'',
'    payload.uefi.push({',
'      feature_id:   model.getValue(rec, "FEATURE_ID"),',
'      feature_name: model.getValue(rec, "FEATURE_NAME"),',
'      description:  model.getValue(rec, "DESCRIPTION"),',
'      state:        state',
'    });',
'  });',
'',
'  console.log("SENDING PAYLOAD:", payload);',
'',
'  apex.server.process(',
'    "SAVE_DEVICE_UEFI",',
'    {',
'      x01: payload.device_id,',
'      x02: JSON.stringify(payload)',
'    },',
'    {',
'      dataType: "json",',
'      success: function(res){',
'        console.log("SERVER RESPONSE:", res);',
'        apex.message.showPageSuccess("UEFI data saved");',
'      },',
'      error: function(err){',
'        console.error("SAVE FAILED", err);',
unistr('        alert("Save failed \2014 check console");'),
'      }',
'    }',
'  );',
'}',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function($){',
'  "use strict";',
'',
'  // ---- Helpers to read device id robustly (dialog or main page) ----',
'  function getDeviceIdAny() {',
'    try { if (typeof $v === ''function'' && $v(''P4_DEVICE_ID'')) return String($v(''P4_DEVICE_ID'')); } catch(e){}',
'    try { if (window.apex && typeof window.apex.item === ''function'') { var it = apex.item(''P4_DEVICE_ID''); if(it && typeof it.getValue === ''function'') return String(it.getValue()); } } catch(e){}',
'    // try parent / top / opener (same origin)',
'    var tries = [window.parent, window.top, window.opener];',
'    for(var i=0;i<tries.length;i++){',
'      try {',
'        var w = tries[i];',
'        if(!w || w===window) continue;',
'        if (typeof w.$v === ''function'' && w.$v(''P4_DEVICE_ID'')) return String(w.$v(''P4_DEVICE_ID''));',
'        if (w.apex && typeof w.apex.item === ''function'') { var it2 = w.apex.item(''P4_DEVICE_ID''); if(it2 && typeof it2.getValue === ''function'') return String(it2.getValue()); }',
'        if (w.document) {',
'          var el = w.document.querySelector(''#P4_DEVICE_ID'') || w.document.querySelector(''[name="P4_DEVICE_ID"]'');',
'          if (el && (el.value || el.getAttribute && el.getAttribute(''value''))) return String(el.value || el.getAttribute(''value''));',
'        }',
'      } catch(e){ /* ignore cross origin */ }',
'    }',
'    return '''';',
'  }',
'',
'  // ---- robust extractor for weird LOV / object values ----',
'  function extractStateRaw(val){',
'    if (val === null || val === undefined) return '''';',
'    if (typeof val === ''string'') return val;',
'    if (typeof val === ''number'' || typeof val === ''boolean'') return String(val);',
'    if (Array.isArray(val)) return val.map(v => (v==null)?'''':String(v)).join('','');',
'    if (typeof val === ''object'') {',
'      // common APEX LOV shapes: try some keys',
'      var keys = [''R'',''D'',''r'',''d'',''value'',''label'',''name'',''state'',''code'',''display''];',
'      for (var k=0;k<keys.length;k++){',
'        if (val[keys[k]] !== undefined && val[keys[k]] !== null) return String(val[keys[k]]);',
'      }',
'      // fallback to JSON',
'      try { return JSON.stringify(val); } catch(e){ return String(val); }',
'    }',
'    return String(val);',
'  }',
'',
'  // ---- normalize to canonical DB values (max 10 chars) ----',
'',
'function normalizeStateValue(raw){',
'  var s = (raw||'''').toString().trim();',
'  if (!s) return ''UNTESTED'';',
'  var up = s.toUpperCase().replace(/[\s\-]+/g,''_'');',
'',
'  // exact lists (preferred canonical outputs)',
'  var notworkExact = [''NOT_WORK'',''NOT_WORKING'',''NOTWORK'',''FAIL'',''FALSE'',''NO'',''BROKEN'',''0''];',
'  var workingExact = [''WORKING'',''OK'',''TRUE'',''PASS'',''YES'',''Y'',''1'',''ACTIVE''];',
'  var unknownExact = [''UNKNOWN'',''N/A'',''NA'',''?'',''NONE''];',
'  var warnExact    = [''WARN'',''WARNING'',''WIP'',''PARTIAL'',''LIMITED'',''DEGRADED''];',
'',
'  // 1) explicit NOT/FAIL first',
'  for(var i=0;i<notworkExact.length;i++){',
'    if(up === notworkExact[i]) return ''NOT_WORKING'';',
'  }',
'',
'  // 2) explicit WORK',
'  for(var j=0;j<workingExact.length;j++){',
'    if(up === workingExact[j]) return ''WORKING'';',
'  }',
'',
'  // 3) exact unknown/warn',
'  for(var k=0;k<unknownExact.length;k++){',
'    if(up === unknownExact[k]) return ''UNKNOWN'';',
'  }',
'  for(var m=0;m<warnExact.length;m++){',
'    if(up === warnExact[m]) return ''UNKNOWN'';',
'  }',
'',
'  // 4) fuzzy contains - check NOT/FAIL before WORK',
'  if (up.indexOf(''NOT'') >= 0 || up.indexOf(''FAIL'') >= 0 || up.indexOf(''FALSE'') >= 0 || up.indexOf(''NO'') >= 0) return ''NOT_WORKING'';',
'  if (up.indexOf(''WORK'') >= 0 || up.indexOf(''OK'') >= 0 || up.indexOf(''YES'') >= 0) return ''WORKING'';',
'  if (up.indexOf(''?'') >= 0 || up.indexOf(''UNKNOWN'') >= 0) return ''UNKNOWN'';',
'',
'  // fallback',
'  return ''UNKNOWN'';',
'}',
'',
'  // ---- read IG model rows robustly ----',
'  function readIGModelRows(staticId) {',
'    try {',
'      if (typeof apex === ''undefined'' || typeof apex.region !== ''function'') return null;',
'      var rg = apex.region(staticId);',
'      if (!rg) return null;',
'      var widget = rg.widget();',
'      if (!widget) return null;',
'      var view, model;',
'      try { view = widget.interactiveGrid(''getCurrentView''); } catch(e) { try { view = widget.interactiveGrid(''getViews'',''grid''); } catch(e) { view = null; } }',
'      model = view && (view.model || (view.view && view.view.model));',
'      if (!model) return null;',
'',
'      var rows = [];',
'      // prefer model.forEach',
'      if (typeof model.forEach === ''function'') {',
'        model.forEach(function(rec){',
'          try {',
'            rows.push({',
'              FEATURE_ID: model.getValue(rec,''FEATURE_ID''),',
'              FEATURE_NAME: model.getValue(rec,''FEATURE_NAME''),',
'              DESCRIPTION: model.getValue(rec,''DESCRIPTION''),',
'              STATE_CODE: model.getValue(rec,''STATE_CODE'')  // whatever the IG column is called',
'            });',
'          } catch(e){}',
'        });',
'        return rows;',
'      }',
'      // fallback getRecordIds',
'      if (typeof model.getRecordIds === ''function'') {',
'        var ids = model.getRecordIds();',
'        ids.forEach(function(id){',
'          try {',
'            var rec = model.getRecord(id);',
'            rows.push({',
'              FEATURE_ID: model.getValue(rec,''FEATURE_ID''),',
'              FEATURE_NAME: model.getValue(rec,''FEATURE_NAME''),',
'              DESCRIPTION: model.getValue(rec,''DESCRIPTION''),',
'              STATE_CODE: model.getValue(rec,''STATE_CODE'')',
'            });',
'          } catch(e){}',
'        });',
'        return rows;',
'      }',
'    } catch(e){',
'      console.warn(''readIGModelRows error'', e);',
'    }',
'    return null;',
'  }',
'',
'  // ---- DOM fallback for IG table (if model fails) ----',
'  function readIGDomRows() {',
'    var rows = [];',
'    var $table = $(''#ig_uefi_ig table'').first();',
'    if (!$table || $table.length === 0) $table = $(''.a-IG table'').first();',
'    if (!$table || $table.length === 0) return rows;',
'',
'    $table.find(''tbody tr'').each(function(){',
'      var $tr = $(this);',
'      var fid = $tr.find(''[data-col="FEATURE_ID"]'').text().trim() || $tr.find(''input[name$="FEATURE_ID"]'').val() || null;',
'      var fname = $tr.find(''[data-col="FEATURE_NAME"]'').text().trim() || $tr.find(''input[name$="FEATURE_NAME"]'').val() || '''';',
'      var desc = $tr.find(''[data-col="DESCRIPTION"]'').text().trim() || $tr.find(''textarea[name$="DESCRIPTION"]'').val() || '''';',
'      var stateCell = $tr.find(''[data-col="STATE_CODE"]'').text().trim() || '''';',
'      rows.push({',
'        FEATURE_ID: fid || null,',
'        FEATURE_NAME: fname || '''',',
'        DESCRIPTION: desc || '''',',
'        STATE_CODE: stateCell || ''''',
'      });',
'    });',
'    return rows;',
'  }',
'',
'  // ---- build normalized payload for server ----',
'  function buildPayload(rows, deviceId) {',
'    var out = [];',
'    (rows||[]).forEach(function(r, idx){',
'      var raw = extractStateRaw(r.STATE_CODE || r.state || r.state_code || null);',
'      var norm = normalizeStateValue(raw);',
'      console.debug(''Row'', idx, ''feature='', r.FEATURE_NAME || r.feature_name, ''raw='', raw, ''norm='', norm);',
'      out.push({',
'        feature_id: (r.FEATURE_ID === null || r.FEATURE_ID === undefined || r.FEATURE_ID === '''') ? null : r.FEATURE_ID,',
'        feature_name: r.FEATURE_NAME || r.feature_name || '''',',
'        description: r.DESCRIPTION || r.description || '''',',
'        state: norm',
'      });',
'    });',
'    return { device_id: String(deviceId || ''''), uefi: out };',
'  }',
'',
'  // ---- main save function ----',
'  function saveUefiFromIG() {',
'    try {',
'      var deviceId = getDeviceIdAny();',
'      console.log(''Resolved device id ->'', deviceId);',
unistr('      if (!deviceId) console.warn(''device id empty \2014 will still send empty x01'');'),
'',
'      // 1) try model',
'      var rows = readIGModelRows(''ig_uefi'');',
'      if (!rows || !rows.length) {',
unistr('        console.warn(''Model read returned empty \2014 trying DOM fallback'');'),
'        rows = readIGDomRows();',
'      }',
'',
'      console.log(''Collected rows count ='', (rows && rows.length) || 0);',
'      if (!rows || !rows.length) {',
'        console.warn(''No rows found to save. Aborting.'');',
'        return;',
'      }',
'',
'      var payload = buildPayload(rows, deviceId);',
'      console.log(''SENDING PAYLOAD:'', payload);',
'',
'      apex.server.process(',
'        ''SAVE_DEVICE_UEFI'',',
'        { x01: String(deviceId || ''''), x02: JSON.stringify(payload) },',
'        {',
'          dataType: ''json'',',
'          success: function(res){',
'            console.log(''SERVER RESPONSE:'', res);',
'            if (res && res.ok) {',
'              apex.message.showPageSuccess(''Saved UEFI data'');',
'              // try refreshing IG in parent/opener/top/local',
'              try { if (window.parent && window.parent !== window && window.parent.apex && typeof window.parent.apex.region === ''function'') window.parent.apex.region(''ig_uefi'').refresh(); } catch(e){}',
'              try { if (window.opener && window.opener.apex && typeof window.opener.apex.region === ''function'') window.opener.apex.region(''ig_uefi'').refresh(); } catch(e){}',
'              try { apex.region && apex.region(''ig_uefi'') && apex.region(''ig_uefi'').refresh(); } catch(e){}',
'            } else {',
'              apex.message.clearErrors();',
'              apex.message.showErrors([{ type:''error'', location:''page'', message:(res && res.error) || ''Save failed'', unsafe:false }]);',
'            }',
'          },',
'          error: function(jqXHR, textStatus, err){',
'            console.error(''AJAX error'', textStatus, err, jqXHR && jqXHR.responseText);',
'            apex.message.showErrors([{ type:''error'', location:''page'', message:''AJAX error while saving UEFI data'', unsafe:false }]);',
'          }',
'        }',
'      );',
'    } catch(e) {',
'      console.error(''saveUefiFromIG fatal'', e);',
unistr('      apex.message.showErrors([{ type:''error'', location:''page'', message:''Unexpected JS error \2014 check console'', unsafe:false }]);'),
'    }',
'  }',
'',
'  // expose so you can call from console',
'  window.saveUefiFromIG = saveUefiFromIG;',
'  // bind UI Save button if present',
'  $(document).on(''click'',''#SAVE_DEVICE'', function(e){ e.preventDefault(); saveUefiFromIG(); });',
'',
unistr('  console.log(''Robust UEFI save helper installed \2014 call saveUefiFromIG() to test.'');'),
'})(apex.jQuery);',
''))
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(123190823991659027247)
,p_plug_name=>'New'
,p_region_name=>'ig_uefi'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'  m.feature_id,',
'  m.feature_name,',
'  NVL(d.description, NULL) AS description,',
'  NVL(d.state_code, ''UNTESTED'') AS state_code',
'FROM uefi_master_list m',
'LEFT JOIN device_uefi_status d',
'  ON d.feature_name = m.feature_name',
' AND d.device_id = :P4_DEVICE_ID',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(123190824274716027250)
,p_name=>'FEATURE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FEATURE_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Feature Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124240598962674865501)
,p_name=>'DESCRIPTION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DESCRIPTION'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>200
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_readonly_condition_type=>'NEVER'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124240599000285865502)
,p_name=>'STATE_CODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATE_CODE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_RADIOGROUP'
,p_heading=>'State'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC:Working;WORKING,Not Working;NOT_WORKING,Unknown;UNKNOWN'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124240601967644865531)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124240602045122865532)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124240603474507865546)
,p_name=>'FEATURE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FEATURE_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>70
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(123190824024597027248)
,p_internal_uid=>123190824024597027248
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>true
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(124241003067325247117)
,p_interactive_grid_id=>wwv_flow_imp.id(123190824024597027248)
,p_static_id=>'1242410031'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(124241003289085247118)
,p_report_id=>wwv_flow_imp.id(124241003067325247117)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(124241004625506247122)
,p_view_id=>wwv_flow_imp.id(124241003289085247118)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(123190824274716027250)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(124241005569897247124)
,p_view_id=>wwv_flow_imp.id(124241003289085247118)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(124240598962674865501)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(124241006421856247126)
,p_view_id=>wwv_flow_imp.id(124241003289085247118)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(124240599000285865502)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(124413383793872982960)
,p_view_id=>wwv_flow_imp.id(124241003289085247118)
,p_display_seq=>0
,p_column_id=>wwv_flow_imp.id(124240601967644865531)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(124956495533727102760)
,p_view_id=>wwv_flow_imp.id(124241003289085247118)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(124240603474507865546)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(124231950440425874017)
,p_plug_name=>'Device Details Editor'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'DEVICE_DETAILS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(124231954439089874022)
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
 p_id=>wwv_flow_imp.id(124231954862638874023)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(124231954439089874022)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(124231957072420874025)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(124231954439089874022)
,p_button_name=>'SAVE'
,p_button_static_id=>'SAVE_DEVICE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'SAVE'
,p_button_position=>'NEXT'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190823336749027241)
,p_name=>'P4_CODENAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'Codename of device'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190823494469027242)
,p_name=>'P4_MAINTAINER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'Maintainer'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190823540034027243)
,p_name=>'P4_CONTRIBUTORS'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'Contributors'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190823622408027244)
,p_name=>'P4_TESTERS'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'Testers'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190823703386027245)
,p_name=>'P4_ACTIVE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_item_source_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'Active State'
,p_source=>'ACTIVE_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Active;Y,Inactive;N'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(123190823868078027246)
,p_name=>'P4_CATEGORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'Category'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT category_name d, category_id r',
'FROM categories',
'ORDER BY category_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Category --'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(124240600178652865513)
,p_name=>'P4_DEVICE_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_is_primary_key=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_item_source_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'Device'
,p_source=>'DEVICE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT device_name d, device_id r',
'FROM devices',
'WHERE soc_id = :P4_SOC_ID',
'  AND manufacturer_id = :P4_MANUFACTURER_ID',
'ORDER BY device_name',
''))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Device --'
,p_lov_cascade_parent_items=>'P4_MANUFACTURER_ID'
,p_ajax_items_to_submit=>'P4_MANUFACTURER_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(124240600626991865518)
,p_name=>'P4_STATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_item_source_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_source=>'STATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(124240601183443865523)
,p_name=>'P4_ACTIVE_FLAG'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(124240601227173865524)
,p_name=>'P4_SOC_ID'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'SoC'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'SOCS.SOC_NAME'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select SoC --'
,p_lov_cascade_parent_items=>'P4_CATEGORY_ID'
,p_ajax_items_to_submit=>'P4_CATEGORY_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(124240601411525865526)
,p_name=>'P4_MANUFACTURER_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(124231950440425874017)
,p_prompt=>'Manufacturer '
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT manufacturer_name d, manufacturer_id r',
'FROM manufacturers',
'WHERE soc_id = :P4_SOC_ID',
'ORDER BY manufacturer_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Manufacturer --'
,p_lov_cascade_parent_items=>'P4_SOC_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(124231954964136874023)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(124231954862638874023)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(124231955722306874024)
,p_event_id=>wwv_flow_imp.id(124231954964136874023)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124231957841426874026)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(124231950440425874017)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Device Details Editor'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_dev_id number := to_number(nvl(:P4_DEVICE_ID, 0));',
'begin',
'  if l_dev_id = 0 then',
'    raise_application_error(-20001, ''Device ID is required.'');',
'  end if;',
'',
'  merge into device_details dd',
'  using (select l_dev_id dev_id from dual) src',
'  on (dd.device_id = src.dev_id)',
'  when matched then',
'    update set',
'      dd.codename     = :P4_CODENAME,',
'      dd.maintainer   = :P4_MAINTAINER,',
'      dd.contributors = :P4_CONTRIBUTORS,',
'      dd.testers      = :P4_TESTERS,',
'      dd.state        = :P4_STATE,',
'      dd.active_flag  = :P4_ACTIVE',
'  when not matched then',
'    insert (device_id, codename, maintainer, contributors, testers, state, active_flag)',
'    values (l_dev_id, :P4_CODENAME, :P4_MAINTAINER, :P4_CONTRIBUTORS, :P4_TESTERS, :P4_STATE, :P4_ACTIVE);',
'',
'  commit;',
'end;'))
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(124231957072420874025)
,p_internal_uid=>124231957841426874026
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124231958218522874026)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>124231958218522874026
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124240602175296865533)
,p_process_sequence=>70
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(123190823991659027247)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'New - Save Interactive Grid Data'
,p_attribute_01=>'TABLE'
,p_attribute_03=>'DEVICE_UEFI_STATUS'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_process_error_message=>'Error'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(124231957072420874025)
,p_process_success_message=>'success!'
,p_internal_uid=>124240602175296865533
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124240602207062865534)
,p_process_sequence=>80
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(124231950440425874017)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'New'
,p_attribute_01=>'TABLE'
,p_attribute_03=>'DEVICE_DETAILS'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_process_error_message=>'Error'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(124231957072420874025)
,p_process_success_message=>'Success!'
,p_internal_uid=>124240602207062865534
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124231957402282874026)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(124231950440425874017)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Device Details Editor'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>124231957402282874026
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124240602306845865535)
,p_process_sequence=>90
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_DEVICE_UEFI'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_dev_id    number := to_number(nvl(apex_application.g_x01,''0''));',
'  l_payload   clob   := nvl(apex_application.g_x02,''{}'');',
'',
'  l_cnt       number;',
'  l_i         pls_integer;',
'',
'  l_feature_id     number;',
'  l_feature_name   varchar2(4000);',
'  l_desc           varchar2(4000);',
'  l_state_raw      varchar2(4000);',
'  l_state          varchar2(20); -- increase to permit ''NOT_WORKING''',
'',
'  -- optional header fields',
'  l_header_codename     varchar2(4000);',
'  l_header_maintainer   varchar2(4000);',
'  l_header_contributors varchar2(4000);',
'  l_header_testers      varchar2(4000);',
'  l_header_active       varchar2(10);',
'',
'  l_after_count number;',
'begin',
'  apex_debug.message(''SAVE_DEVICE_UEFI: device_id=%s'', l_dev_id);',
'  apex_debug.message(''SAVE_DEVICE_UEFI payload (trunc 32k): %s'', substr(l_payload,1,32000));',
'',
'  -- parse payload (will raise if not valid JSON)',
'  apex_json.parse(l_payload);',
'',
'  -- optional header extraction (safe)',
'  begin',
'    l_header_codename     := apex_json.get_varchar2(''header.codename'');',
'    l_header_maintainer   := apex_json.get_varchar2(''header.maintainer'');',
'    l_header_contributors := apex_json.get_varchar2(''header.contributors'');',
'    l_header_testers      := apex_json.get_varchar2(''header.testers'');',
'    l_header_active       := apex_json.get_varchar2(''header.active'');',
'  exception when others then',
'    null;',
'  end;',
'',
'  -- upsert device_details (non-blocking)',
'  if l_dev_id > 0 then',
'    begin',
'      merge into device_details dd',
'      using (select l_dev_id dev from dual) src',
'      on (dd.device_id = src.dev)',
'      when matched then',
'        update set',
'          dd.codename     = case when l_header_codename is not null then l_header_codename else dd.codename end,',
'          dd.maintainer   = case when l_header_maintainer is not null then l_header_maintainer else dd.maintainer end,',
'          dd.contributors = case when l_header_contributors is not null then l_header_contributors else dd.contributors end,',
'          dd.testers      = case when l_header_testers is not null then l_header_testers else dd.testers end,',
'          dd.active_flag  = case when l_header_active is not null then l_header_active else dd.active_flag end',
'      when not matched then',
'        insert (device_id, codename, maintainer, contributors, testers, active_flag)',
'        values (l_dev_id, l_header_codename, l_header_maintainer, l_header_contributors, l_header_testers, l_header_active);',
'      apex_debug.message(''SAVE_DEVICE_UEFI: device_details merge OK for %s'', l_dev_id);',
'    exception',
'      when others then',
'        apex_debug.message(''SAVE_DEVICE_UEFI: device_details merge ERROR: %s'', sqlerrm);',
'    end;',
'  else',
'    apex_debug.message(''SAVE_DEVICE_UEFI: l_dev_id is zero or invalid'');',
'  end if;',
'',
'  -- process uefi array',
'  l_cnt := apex_json.get_count(''uefi'');',
'  apex_debug.message(''UEFI COUNT = %s'', l_cnt);',
'',
'  for l_i in 1..l_cnt loop',
'    begin',
'      -- defaults',
'      l_feature_id   := null;',
'      l_feature_name := null;',
'      l_desc         := null;',
'      l_state_raw    := null;',
'      l_state        := ''UNTESTED'';',
'',
'      -- feature_id (optional)',
'      begin',
'        l_feature_id := apex_json.get_number(''uefi[%d].feature_id'', l_i);',
'      exception when others then',
'        l_feature_id := null;',
'      end;',
'',
'      -- resolve feature_name via id if provided',
'      if l_feature_id is not null then',
'        begin',
'          select feature_name',
'          into l_feature_name',
'          from uefi_master_list',
'          where feature_id = l_feature_id;',
'        exception',
'          when no_data_found then',
'            apex_debug.message(''Row %s: feature_id %s not found in master list'', l_i, l_feature_id);',
'            l_feature_name := null;',
'          when others then',
'            apex_debug.message(''Row %s: feature_id lookup error %s'', l_i, sqlerrm);',
'            l_feature_name := null;',
'        end;',
'      end if;',
'',
'      -- fallback: read feature_name directly from payload',
'      begin',
'        if l_feature_name is null then',
'          l_feature_name := apex_json.get_varchar2(''uefi[%d].feature_name'', l_i);',
'        end if;',
'      exception when others then',
'        l_feature_name := null;',
'      end;',
'',
'      -- description',
'      begin',
'        l_desc := apex_json.get_varchar2(''uefi[%d].description'', l_i);',
'      exception when others then',
'        l_desc := null;',
'      end;',
'',
'      -- raw state (may be many forms from JS)',
'      begin',
'        l_state_raw := apex_json.get_varchar2(''uefi[%d].state'', l_i);',
'      exception when others then',
'        l_state_raw := null;',
'      end;',
'',
unistr('      -- normalize state (server-side) \2014 canonical values: NOT_WORKING, WORKING, UNKNOWN, UNTESTED'),
'      begin',
'        -- unify to upper & replace whitespace/hyphen with underscore',
'        l_state := upper(trim(nvl(l_state_raw, '''')));',
'        l_state := regexp_replace(l_state, ''[\s\-]+'', ''_'');',
'',
'        -- exact matches first (include common variants)',
'        if l_state in (',
'             ''NOT_WORK'', ''NOT_WORKING'', ''NOTWORK'', ''NOTWORKING'', ''FAIL'', ''FALSE'', ''NO'', ''BROKEN''',
'           ) then',
'          l_state := ''NOT_WORKING'';',
'',
'        elsif l_state in (',
'             ''WORKING'', ''OK'', ''TRUE'', ''PASS'', ''YES'', ''Y'', ''1'', ''ACTIVE''',
'           ) then',
'          l_state := ''WORKING'';',
'',
'        elsif l_state in (',
'             ''UNKNOWN'', ''N/A'', ''NA'', ''?'', ''NONE''',
'           ) then',
'          l_state := ''UNKNOWN'';',
'',
'        elsif l_state in (',
'             ''WARN'', ''WARNING'', ''WIP'', ''PARTIAL'', ''LIMITED'', ''DEGRADED''',
'           ) then',
'          l_state := ''UNKNOWN'';',
'',
'        else',
'          -- fuzzy fallback: check negative/failure tokens first',
'          if instr(l_state, ''NOT'') > 0 or instr(l_state, ''FAIL'') > 0 or instr(l_state, ''FALSE'') > 0 or instr(l_state, ''NO'') > 0 then',
'            l_state := ''NOT_WORKING'';',
'          elsif instr(l_state, ''WORK'') > 0 or instr(l_state, ''OK'') > 0 then',
'            l_state := ''WORKING'';',
'          elsif instr(l_state, ''?'') > 0 or instr(l_state, ''UNKNOWN'') > 0 then',
'            l_state := ''UNKNOWN'';',
'          else',
'            l_state := ''UNTESTED'';',
'          end if;',
'        end if;',
'      exception when others then',
'        l_state := ''UNTESTED'';',
'      end;',
'',
'      apex_debug.message(''Row %s >>> fid=%s fname=%s desc=%s raw_state=%s norm_state=%s'',',
'                         l_i,',
'                         nvl(to_char(l_feature_id),''<null>''),',
'                         nvl(l_feature_name,''<null>''),',
'                         nvl(substr(l_desc,1,200),''<null>''),',
'                         nvl(l_state_raw,''<null>''),',
'                         nvl(l_state,''<null>''));',
'',
'      -- only merge if we have a feature_name and a valid device id',
'      if l_dev_id > 0 and l_feature_name is not null then',
'        begin',
'          merge into device_uefi_status t',
'          using (select l_dev_id dev_id, l_feature_name fname from dual) s',
'          on (t.device_id = s.dev_id and t.feature_name = s.fname)',
'          when matched then',
'            update set t.description = l_desc, t.state_code = l_state',
'          when not matched then',
'            insert (device_id, feature_name, description, state_code)',
'            values (l_dev_id, l_feature_name, l_desc, l_state);',
'          apex_debug.message(''Row %s MERGE OK'', l_i);',
'        exception',
'          when others then',
'            apex_debug.message(''Row %s MERGE ERROR: %s'', l_i, sqlerrm);',
'        end;',
'      else',
'        apex_debug.message(''Row %s skipped (missing feature_name or device_id)'', l_i);',
'      end if;',
'',
'    exception',
'      when others then',
'        apex_debug.message(''Row %s OUTER ERROR: %s'', l_i, sqlerrm);',
'    end;',
'  end loop;',
'',
'  commit;',
'',
'  -- report how many rows now for this device',
'  begin',
'    select count(*) into l_after_count from device_uefi_status where device_id = l_dev_id;',
'    apex_debug.message(''After SAVE: device_uefi_status count for %s = %s'', l_dev_id, l_after_count);',
'  exception when others then null;',
'  end;',
'',
'  htp.p(''{"ok":true}'');',
'exception',
'  when others then',
'    htp.p(''{"ok":false,"error":"'' || replace(sqlerrm, ''"'', '''''''') || ''"}'');',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>124240602306845865535
);
wwv_flow_imp.component_end;
end;
/
