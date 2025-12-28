prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_name=>'Supported Devices'
,p_alias=>'SUPPORTED-DEVICES'
,p_step_title=>'Supported Devices'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function($){',
'  $(document).ready(function(){',
'',
'(function($){',
'',
'  // ----- HELPER RENDERERS -----',
'  function renderSoCs(list){',
'    var $wrap = $(''<div class="ps-soc-items"></div>'');',
'    list.forEach(function(s){',
unistr('      var $it = $(''<div class="ps-item" data-soc-id="''+s.id+''"><div class="label">''+s.name+''</div><div class="sub-arrow">\25B8</div></div>'');'),
'      $wrap.append($it);',
'    });',
'    return $wrap;',
'  }',
'',
'  function renderManufacturers(list){',
'    var $wrap = $(''<div></div>'');',
'    list.forEach(function(m){',
'      var $blk = $(''<div class="ps-manufacturer-block" data-manufacturer-id="''+m.id+''"><div class="ps-manufacturer-title">''+m.name+''</div><div class="ps-device-list"></div></div>'');',
'      $wrap.append($blk);',
'    });',
'    return $wrap;',
'  }',
'',
'  function renderDevices(list){',
'    var $wrap = $(''<div></div>'');',
'    list.forEach(function(d){',
unistr('      $wrap.append(''<div class="ps-device">''+d.name + (d.other_info ? '' \2014 '' + d.other_info : '''') +''</div>'');'),
'    });',
'    return $wrap;',
'  }',
'',
'  // ----- CATEGORY CLICK -----',
'  $(''#ps-supported'').on(''click'', ''.ps-category > .ps-cat-label'', function(){',
'    var $catBox = $(this).closest(''.ps-category'');',
'    var catName = $catBox.data(''category'');',
'    var $child = $catBox.find(''.ps-child'').first();',
'',
'    var isOpen = $child.is('':visible'');',
'    $(''.ps-child'').not($child).slideUp(180);',
'    $(''.ps-arrow'').css(''transform'',''rotate(0deg)'');',
'',
'    if(isOpen){',
'      $child.slideUp(180);',
'      $(this).find(''.ps-arrow'').css(''transform'',''rotate(0deg)'');',
'      $(''#ps-detail'').empty();',
'      return;',
'    } else {',
'      $(this).find(''.ps-arrow'').css(''transform'',''rotate(90deg)'');',
'    }',
'',
'    $child.slideDown(200);',
'',
'    if($child.data(''loaded'') !== ''true''){',
unistr('      $child.html(''<div class="ps-loading">Loading SoCs\2026</div>'');'),
'      apex.server.process(''GET_SOCs'', { x01: catName }, { dataType: ''json'' })',
'        .done(function(res){',
'          $child.empty();',
'          if(Array.isArray(res) && res.length){',
'            $child.append(renderSoCs(res));',
'          } else {',
'            $child.append(''<div class="ps-loading">No SoCs found.</div>'');',
'          }',
'          $child.data(''loaded'',''true'');',
'        })',
'        .fail(function(err){',
'          $child.html(''<div class="ps-loading">Error loading SoCs</div>'');',
'          console.error(err);',
'        });',
'    }',
'  });',
'',
'  // ----- SOC CLICK -----',
'  $(''#ps-supported'').on(''click'', ''.ps-soc-items .ps-item'', function(){',
'    var socId = $(this).data(''soc-id'');',
'    $(''.ps-soc-items .ps-item'').removeClass(''active'');',
'    $(this).addClass(''active'');',
'',
'    var $detail = $(''#ps-detail'');',
unistr('    $detail.html(''<div class="ps-loading">Loading manufacturers\2026</div>'');'),
'',
'    apex.server.process(''GET_MANUFACTURERS'', { x01: socId }, { dataType: ''json'' })',
'      .done(function(res){',
'        $detail.empty();',
'        if(Array.isArray(res) && res.length){',
'          $detail.append(renderManufacturers(res));',
'        } else {',
'          $detail.append(''<div class="ps-loading">No manufacturers found.</div>'');',
'        }',
'      })',
'      .fail(function(err){',
'        $detail.html(''<div class="ps-loading">Error loading manufacturers</div>'');',
'        console.error(err);',
'      });',
'  });',
'',
'  // ----- MANUFACTURER CLICK -----',
'  $(''#ps-supported'').on(''click'', ''.ps-manufacturer-block .ps-manufacturer-title'', function(){',
'    var $blk = $(this).closest(''.ps-manufacturer-block'');',
'    var manufacturerId = $blk.data(''manufacturer-id'');',
'    var socId = $(''.ps-soc-items .ps-item.active'').data(''soc-id'');',
'',
'    if(!socId){',
'      alert(''Select an SoC first'');',
'      return;',
'    }',
'',
'    var $deviceList = $blk.find(''.ps-device-list'');',
unistr('    $deviceList.html(''<div class="ps-loading">Loading devices\2026</div>'');'),
'',
'    apex.server.process(''GET_DEVICES'', { x01: socId, x02: manufacturerId }, { dataType: ''json'' })',
'      .done(function(res){',
'        $deviceList.empty();',
'        if(Array.isArray(res) && res.length){',
'          $deviceList.append(renderDevices(res));',
'        } else {',
'          $deviceList.append(''<div class="ps-loading">No devices found.</div>'');',
'        }',
'      })',
'      .fail(function(err){',
'        $deviceList.html(''<div class="ps-loading">Error loading devices</div>'');',
'        console.error(err);',
'      });',
'  });',
'',
'  // ----- DEVICE CLICK (optional) -----',
'  $(''#ps-supported'').on(''click'', ''.ps-device'', function(){',
'    var name = $(this).text();',
'    alert(''Device clicked: '' + name);',
'  });',
'',
'  // ----- ADD NEW DEVICE BUTTON -----',
'//depreciated',
'',
'})(apex.jQuery);',
'',
'  });',
'})(apex.jQuery);'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Basic layout */',
'#ps-supported { max-width:1100px; margin: 2.5rem auto; color: #fff; font-family: Arial, sans-serif; }',
'.ps-categories { display:flex; gap:16px; flex-wrap:wrap; justify-content:center; margin-bottom:1.25rem; }',
'',
'/* Category box style */',
'.ps-category {',
'  background: linear-gradient(135deg, #2b2b2b, #3b3b3b); /* subtle dark gradient */',
'  border-radius: 12px;',
'  padding: 12px;',
'  width: 280px;',
'  box-shadow: 0 6px 18px rgba(0,0,0,0.35);',
'  cursor: pointer;',
'  transition: transform .18s ease, box-shadow .18s ease;',
'  position: relative;',
'  overflow: visible;',
'}',
'',
'.ps-cat-label {',
'  font-size: 1.05rem;',
'  font-weight: 600;',
'  display: flex;',
'  justify-content: space-between;',
'  align-items: center;',
'  color: #fff; /* text pops against dark gradient */',
'  text-shadow: 0 1px 2px rgba(0,0,0,0.7); /* optional, extra contrast */',
'}',
'',
'.ps-category:hover { transform: translateY(-4px); box-shadow: 0 12px 30px rgba(0,0,0,0.45); }',
'',
'.ps-arrow { transform: rotate(0deg); transition: transform .25s ease; color: #ffb4e6; }',
'',
'/* the child container that will slideDown */',
'.ps-child {',
'  display: none; /* initially hidden; will slideDown via JS */',
'  margin-top: 12px;',
'  padding-top: 8px;',
'  border-top: 1px solid rgba(255,255,255,0.04);',
'}',
'',
'/* SoC / manufacturer / device items */',
'.ps-item {',
'  background: rgba(255,255,255,0.02);',
'  border-radius: 8px;',
'  padding: 8px 10px;',
'  margin: 8px 0;',
'  display:flex;',
'  justify-content:space-between;',
'  align-items:center;',
'  cursor:pointer;',
'  transition: background .15s ease, transform .12s ease;',
'}',
'.ps-item:hover { background: rgba(255,255,255,0.04); transform: translateX(4px); }',
'.ps-item .label { font-weight:500; color:#fff; }',
'.ps-item .sub-arrow { color:#ffb4e6; }',
'',
'/* detail column on the right (manufacturers / devices) */',
'#ps-detail {',
'  margin-top: 24px;',
'  background: #1f1f1f;',
'  border-radius: 14px;',
'  padding: 16px;',
'  box-shadow: 0 10px 28px rgba(0,0,0,0.35);',
'}',
'',
'/* manufacturer block */',
'.ps-manufacturer-block {',
'  margin-top: 10px;',
'  padding: 14px;',
'  border-radius: 12px;',
'  background: rgba(255,255,255,0.06); /* was 0.02 */',
'}',
'',
'.ps-manufacturer-title {',
'  font-weight: 700;',
'  color: #fff;',
'  font-size: 1.05rem;',
'}',
'/* device list inside manufacturer */',
'.ps-device-list { margin-top:8px; }',
'.ps-device { padding:8px 10px; border-radius:6px; background: rgba(0,0,0,0.15); margin-bottom:6px; color:#fff; }',
'',
'/* small helper */',
'.ps-loading { opacity:0.8; font-style:italic; color:#ddd; }',
'',
'.ps-add-btn {',
'  background: linear-gradient(90deg,#ff33cc,#9933ff);',
'  color: #fff;',
'  border: none;',
'  padding: 10px 18px;',
'  border-radius: 10px;',
'  font-weight: 700;',
'  cursor: pointer;',
'  box-shadow: 0 8px 24px rgba(153,51,255,0.15);',
'  transition: transform .18s ease, box-shadow .18s ease, opacity .12s;',
'}',
'.ps-add-btn:hover { transform: translateY(-3px); box-shadow: 0 14px 36px rgba(153,51,255,0.22); }',
'.ps-add-btn:active { transform: translateY(-1px); }',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(123190819658469027204)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="ps-supported">',
'',
'  <!-- Categories (static buttons for now) -->',
'  <div class="ps-categories">',
'    <div class="ps-category" data-category="Qualcomm"> ',
'      <div class="ps-cat-label">',
unistr('        Qualcomm <span class="ps-arrow">\25B8</span>'),
'      </div>',
'      <div class="ps-child soc-list" data-loaded="false"></div>',
'    </div>',
'',
'    <div class="ps-category" data-category="Mediatek"> ',
'      <div class="ps-cat-label">',
unistr('        Mediatek <span class="ps-arrow">\25B8</span>'),
'      </div>',
'      <div class="ps-child soc-list" data-loaded="false"></div>',
'    </div>',
'',
'    <div class="ps-category" data-category="Exynos"> ',
'      <div class="ps-cat-label">',
unistr('        Exynos <span class="ps-arrow">\25B8</span>'),
'      </div>',
'      <div class="ps-child soc-list" data-loaded="false"></div>',
'    </div>',
'  </div>',
'',
'  <!-- area for manufacturer list & devices -->',
'  <div id="ps-detail" class="ps-detail"></div>',
'',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(123370752392847952092)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(123189750976044967475)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(123190822558179027233)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(123190819658469027204)
,p_button_name=>'ADD_MANUFACTURER'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Manufacturer'
,p_button_position=>'EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(123190822600388027234)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(123190819658469027204)
,p_button_name=>'ADD_SOC'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Soc'
,p_button_position=>'EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(123190822757184027235)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(123190819658469027204)
,p_button_name=>'ADD_DEVICE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Device'
,p_button_position=>'EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5::'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123190819842362027206)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_SOCs'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_cat_name varchar2(4000) := apex_application.g_x01; -- we pass category name as x01',
'begin',
'  apex_json.open_array;',
'  for r in (',
'    select soc_id, soc_name',
'    from socs',
'    where category_id = (',
'      select category_id from categories where lower(category_name) = lower(nvl(l_cat_name,''@#@''))',
'    )',
'    order by soc_name',
'  ) loop',
'    apex_json.open_object;',
'    apex_json.write(''id'', r.soc_id);',
'    apex_json.write(''name'', r.soc_name);',
'    apex_json.close_object;',
'  end loop;',
'  apex_json.close_array;',
'exception when others then',
'  -- return empty array on error',
'  apex_json.open_array;',
'  apex_json.close_array;',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>123190819842362027206
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123190819980416027207)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_MANUFACTURERS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_soc_id number := to_number(nvl(apex_application.g_x01,''0''));',
'begin',
'  apex_json.open_array;',
'  for r in (',
'    select distinct m.manufacturer_id, m.manufacturer_name',
'    from manufacturers m',
'    left join devices d',
'      on d.manufacturer_id = m.manufacturer_id',
'      and d.soc_id = l_soc_id',
'    where m.soc_id = l_soc_id',
'       or d.manufacturer_id is not null',
'    order by m.manufacturer_name',
'  ) loop',
'    apex_json.open_object;',
'    apex_json.write(''id'', r.manufacturer_id);',
'    apex_json.write(''name'', r.manufacturer_name);',
'    apex_json.close_object;',
'  end loop;',
'  apex_json.close_array;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>123190819980416027207
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123190820091545027208)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_DEVICES'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_soc_id number := to_number(nvl(apex_application.g_x01,''0''));',
'  l_man_id number := to_number(nvl(apex_application.g_x02,''0''));',
'begin',
'  apex_json.open_array;',
'  for r in (',
'    select device_id, device_name, nvl(other_info,'''') other_info',
'    from devices',
'    where soc_id = l_soc_id',
'      and manufacturer_id = l_man_id',
'    order by device_name',
'  ) loop',
'    apex_json.open_object;',
'    apex_json.write(''id'', r.device_id);',
'    apex_json.write(''name'', r.device_name);',
'    apex_json.write(''other_info'', r.other_info);',
'    apex_json.close_object;',
'  end loop;',
'  apex_json.close_array;',
'exception when others then',
'  apex_json.open_array;',
'  apex_json.close_array;',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>123190820091545027208
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123190820965087027217)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_DIALOG_URL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_url varchar2(4000);',
'begin',
'  l_url := ''f?p='' || v(''APP_ID'') || '':5:'' || v(''APP_SESSION'') || ''::NO::P_DIALOG_MODE:ADD'';',
'  apex_json.open_object;',
'  apex_json.write(''url'', apex_util.prepare_url(p_url => l_url, p_checksum_type => ''SESSION''));',
'  apex_json.close_object;',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>123190820965087027217
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123190821232214027220)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_DIALOG_SOC_URL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_url varchar2(4000);',
'begin',
'  l_url := ''f?p='' || v(''APP_ID'') || '':3:'' || v(''APP_SESSION'') || ''::NO::P_DIALOG_MODE:ADD'';',
'  apex_json.open_object;',
'  apex_json.write(''url'', apex_util.prepare_url(p_url => l_url, p_checksum_type => ''SESSION''));',
'  apex_json.close_object;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>123190821232214027220
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123190822430396027232)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_DIALOG_MAN_URL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_url varchar2(4000);',
'begin',
'  l_url := ''f?p='' || v(''APP_ID'') || '':'' || ''7'' || '':'' || v(''APP_SESSION'') || ''::NO::P_DIALOG_MODE:ADD'';',
'  apex_json.open_object;',
'  apex_json.write(''url'', apex_util.prepare_url(p_url => l_url, p_checksum_type => ''SESSION''));',
'  apex_json.close_object;',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>123190822430396027232
);
wwv_flow_imp.component_end;
end;
/
