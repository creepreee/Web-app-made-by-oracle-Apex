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
unistr('/* Supported devices page \2014 full, cleaned-up script'),
'   Shows single emoji for each state:',
unistr('     \2705 = working/active'),
unistr('     \274C = not working'),
unistr('     \26A0\FE0F = warning/partial'),
unistr('     \2754 = unknown / untested / fallback'),
'*/',
'(function($){',
'  "use strict";',
'',
'  $(function(){',
'',
'    // ---------- helpers / renderers ----------',
'',
'    function renderSoCs(list){',
'      var $wrap = $(''<div class="ps-soc-items"></div>'');',
'      list.forEach(function(s){',
'        var $it = $(',
'          ''<div class="ps-item" data-soc-id="''+escapeHtmlAttr(s.id)+''">'' +',
'            ''<div class="label">''+escapeHtml(s.name)+''</div>'' +',
unistr('            ''<div class="sub-arrow">\25B8</div>'' +'),
'          ''</div>''',
'        );',
'        $wrap.append($it);',
'      });',
'      return $wrap;',
'    }',
'',
'    function renderManufacturers(list){',
'      var $wrap = $(''<div></div>'');',
'      list.forEach(function(m){',
'        var $blk = $(',
'          ''<div class="ps-manufacturer-block" data-manufacturer-id="''+escapeHtmlAttr(m.id)+''">'' +',
'            ''<div class="ps-manufacturer-title">''+escapeHtml(m.name)+''</div>'' +',
'            ''<div class="ps-device-list"></div>'' +',
'          ''</div>''',
'        );',
'        $wrap.append($blk);',
'      });',
'      return $wrap;',
'    }',
'',
'    function renderDevices(list){',
'      var $wrap = $(''<div></div>'');',
'      list.forEach(function(d){',
'        var did = (d.id !== undefined) ? d.id : (d.device_id !== undefined ? d.device_id : '''');',
'        var label = d.name || d.device_name || ''Unnamed device'';',
unistr('        var other = d.other_info ? '' \2014 '' + d.other_info : (d.info ? '' \2014 '' + d.info : '''');'),
'        var $el = $(''<div class="ps-device" role="button"></div>'')',
'                    .attr(''data-device-id'', String(did))',
'                    .text(label + other);',
'        if(!did){',
'          $el.addClass(''ps-device-noid'');',
'          $el.append('' '').append($(''<span style="color:#ff8080;font-weight:700">[no id]</span>''));',
'        }',
'        $wrap.append($el);',
'        console.debug(''renderDevices: added'', label, ''data-device-id='', did);',
'      });',
'      return $wrap;',
'    }',
'',
'    // ---------- clicks: category, soc, manufacturer ----------',
'',
'    $(''#ps-supported'').on(''click'', ''.ps-category > .ps-cat-label'', function(){',
'      var $catBox = $(this).closest(''.ps-category'');',
'      var catName = $catBox.data(''category'');',
'      var $child = $catBox.find(''.ps-child'').first();',
'',
'      var isOpen = $child.is('':visible'');',
'      $(''.ps-child'').not($child).slideUp(180);',
'      $(''.ps-arrow'').css(''transform'',''rotate(0deg)'');',
'',
'      if(isOpen){',
'        $child.slideUp(180);',
'        $(this).find(''.ps-arrow'').css(''transform'',''rotate(0deg)'');',
'        $(''#ps-detail'').empty();',
'        return;',
'      } else {',
'        $(this).find(''.ps-arrow'').css(''transform'',''rotate(90deg)'');',
'      }',
'',
'      $child.slideDown(200);',
'',
'      if($child.data(''loaded'') !== ''true''){',
unistr('        $child.html(''<div class="ps-loading">Loading SoCs\2026</div>'');'),
'        apex.server.process(''GET_SOCs'', { x01: catName }, { dataType: ''json'' })',
'          .done(function(res){',
'            $child.empty();',
'            if(Array.isArray(res) && res.length){',
'              $child.append(renderSoCs(res));',
'            } else {',
'              $child.append(''<div class="ps-loading">No SoCs found.</div>'');',
'            }',
'            $child.data(''loaded'',''true'');',
'          })',
'          .fail(function(err){',
'            $child.html(''<div class="ps-loading">Error loading SoCs</div>'');',
'            console.error(err);',
'          });',
'      }',
'    });',
'',
'    $(''#ps-supported'').on(''click'', ''.ps-soc-items .ps-item'', function(){',
'      var socId = $(this).data(''soc-id'');',
'      $(''.ps-soc-items .ps-item'').removeClass(''active'');',
'      $(this).addClass(''active'');',
'',
'      var $detail = $(''#ps-detail'');',
unistr('      $detail.html(''<div class="ps-loading">Loading manufacturers\2026</div>'');'),
'',
'      apex.server.process(''GET_MANUFACTURERS'', { x01: socId }, { dataType: ''json'' })',
'        .done(function(res){',
'          $detail.empty();',
'          if(Array.isArray(res) && res.length){',
'            $detail.append(renderManufacturers(res));',
'          } else {',
'            $detail.append(''<div class="ps-loading">No manufacturers found.</div>'');',
'          }',
'        })',
'        .fail(function(err){',
'          $detail.html(''<div class="ps-loading">Error loading manufacturers</div>'');',
'          console.error(err);',
'        });',
'    });',
'',
'    $(''#ps-supported'').on(''click'', ''.ps-manufacturer-block .ps-manufacturer-title'', function(){',
'      var $blk = $(this).closest(''.ps-manufacturer-block'');',
'      var manufacturerId = $blk.data(''manufacturer-id'');',
'      var socId = $(''.ps-soc-items .ps-item.active'').data(''soc-id'');',
'',
'      if(!socId){',
'        alert(''Select an SoC first'');',
'        return;',
'      }',
'',
'      var $deviceList = $blk.find(''.ps-device-list'');',
unistr('      $deviceList.html(''<div class="ps-loading">Loading devices\2026</div>'');'),
'',
'      apex.server.process(''GET_DEVICES'', { x01: socId, x02: manufacturerId }, { dataType: ''json'' })',
'        .done(function(res){',
'          $deviceList.empty();',
'          if(Array.isArray(res) && res.length){',
'            $deviceList.append(renderDevices(res));',
'          } else {',
'            $deviceList.append(''<div class="ps-loading">No devices found.</div>'');',
'          }',
'        })',
'        .fail(function(err){',
'          $deviceList.html(''<div class="ps-loading">Error loading devices</div>'');',
'          console.error(err);',
'        });',
'    });',
'',
'    // ---------- device click -> details ----------',
'',
'    $(''#ps-supported'').off(''click'', ''.ps-device'').on(''click'', ''.ps-device'', function () {',
'      var deviceId = $(this).data(''device-id'') || $(this).attr(''data-device-id'');',
'      console.log(''Clicked deviceId:'', deviceId);',
'',
'      if (!deviceId) {',
'        console.warn(''deviceId missing on clicked element. Check data-device-id attribute.'');',
'        return;',
'      }',
'',
'      // ensure string (APEX expects x01 as string)',
'      var payload = { x01: String(deviceId) };',
'',
'      apex.server.process(''GET_DEVICE_DETAILS'', payload, {',
'        dataType: ''json'',',
'        success: function(res){',
'          console.log(''GET_DEVICE_DETAILS raw response:'', res);',
'          try { console.log(''GET_DEVICE_DETAILS JSON:\n'', JSON.stringify(res, null, 2)); } catch(e){}',
'',
'          // normalize incoming shape',
'          var p;',
'          if (res && res.device && typeof res.device === ''object'') {',
'            p = Object.assign({}, res.device);',
'            p.uefi = Array.isArray(res.uefi) ? res.uefi : (Array.isArray(p.uefi) ? p.uefi : []);',
'          } else {',
'            p = Object.assign({}, res || {});',
'            p.uefi = Array.isArray(p.uefi) ? p.uefi : [];',
'          }',
'',
'          var d = {',
'            device_name : p.device_name || p.title || p.name || ''Unknown device'',',
'            manufacturer: p.manufacturer || p.vendor || ''Unknown'',',
'            state       : p.state || p.state_text || '''',',
'            codename    : p.codename || '''',',
'            maintainer  : p.maintainer || '''',',
'            contributors: p.contributors || '''',',
'            testers     : p.testers || '''',',
'            active      : (p.active || p.active_flag) ? String(p.active || p.active_flag) : ''N'',',
'            uefi        : Array.isArray(p.uefi) ? p.uefi : []',
'          };',
'',
'          console.debug(''GET_DEVICE_DETAILS normalized payload:'', d);',
'',
'          renderDeviceDetails(d);',
'        },',
'        error: function(jqXHR, textStatus, errorThrown) {',
'          console.error(''GET_DEVICE_DETAILS error'', textStatus, errorThrown, jqXHR && jqXHR.responseText);',
unistr('          $(''#ps-detail'').html(''<div class="ps-device-card">Unable to load device details \2014 check console/network.</div>'');'),
'        }',
'      });',
'    });',
'',
'    // ---------- display helpers ----------',
'',
'    function renderDeviceDetails(d){',
'      d = d || {};',
'      var isActive = (String(d.active || '''').toUpperCase() === ''Y'' || String(d.active || '''').toLowerCase() === ''true'');',
unistr('      var activeDot = isActive ? ''\D83D\DFE2'' : ''\D83D\DD34'';'),
'',
'      var uefiRows = d.uefi && d.uefi.length ? d.uefi : [];',
'',
'      var uefiHtml;',
'      if (uefiRows.length === 0) {',
'        uefiHtml = ''<div style="opacity:.8;font-style:italic;margin:8px 0">No UEFI rows available.</div>'';',
'      } else {',
'        uefiHtml = ''<table class="ps-table"><thead><tr><th>Feature</th><th>Description</th><th>State</th></tr></thead><tbody>'' +',
'          uefiRows.map(function(u){',
'            // robustly find state value (many possible keys/shapes)',
'            var rawState = (u && (u.state || u.state_code || u.state_value || u.status || u.value || u.code)) || '''';',
'            // ensure string',
'            rawState = (rawState === null || rawState === undefined) ? '''' : String(rawState);',
'            return ''<tr>'' +',
'                     ''<td>'' + escapeHtml(u.feature || u.feature_name || '''') + ''</td>'' +',
'                     ''<td>'' + escapeHtml(u.description || '''') + ''</td>'' +',
'                     ''<td style="text-align:center;font-size:18px">'' + renderStateIcon(rawState) + ''</td>'' +',
'                   ''</tr>'';',
'          }).join('''') +',
'        ''</tbody></table>'';',
'      }',
'',
'      var html = ''<div class="ps-device-header">'' +',
'                   ''<h2>'' + escapeHtml(d.device_name) + ''</h2>'' +',
'                   ''<div>'' + escapeHtml(d.manufacturer) + ''</div>'' +',
'                   ''<div style="font-size:18px; margin-top:5px;">'' + escapeHtml(String(d.active || '''')) + '' '' + activeDot + ''</div>'' +',
'                   ''<div class="meta" style="margin-top:8px">'' +',
'                     ''<div><b>State:</b> '' + escapeHtml(d.state || '''') + ''</div>'' +',
'                     ''<div><b>Codename:</b> '' + escapeHtml(d.codename || '''') + ''</div>'' +',
'                     ''<div><b>Maintainer:</b> '' + escapeHtml(d.maintainer || '''') + ''</div>'' +',
'                     ''<div><b>Contributors:</b> '' + escapeHtml(d.contributors || '''') + ''</div>'' +',
'                     ''<div><b>Testers:</b> '' + escapeHtml(d.testers || '''') + ''</div>'' +',
'                   ''</div>'' +',
'                 ''</div>'' +',
'                 ''<h3 style="margin-top:12px">UEFI Status</h3>'' + uefiHtml;',
'',
'      $(''#ps-detail'').html(html);',
'    }',
'',
unistr('    // single-icon renderer \2014 returns ONLY emoji (no text)'),
'    function renderStateIcon(s){',
'      var up = (s || '''').toString().trim().toUpperCase().replace(/[\s\-]+/g,''_'');',
'',
'      var workingSyn = [''WORKING'',''OK'',''TRUE'',''PASS'',''YES'',''Y'',''1'',''ACTIVE''];',
'      var notWorkingSyn = [''NOT_WORK'',''NOT_WORKING'',''NOTWORK'',''NOTWORKING'',''FAIL'',''FALSE'',''NO'',''BROKEN'',''0''];',
'      var unknownSyn = [''UNKNOWN'',''N/A'',''NA'',''?'',''NONE'',''UNTESTED'',''NULL'',''''];',
'      var warnSyn = [''WARN'',''WARNING'',''WIP'',''PARTIAL'',''LIMITED'',''DEGRADED''];',
'',
unistr('      if (workingSyn.indexOf(up) !== -1) return ''\2705'';'),
unistr('      if (notWorkingSyn.indexOf(up) !== -1) return ''\274C'';'),
unistr('      if (warnSyn.indexOf(up) !== -1) return ''\26A0\FE0F'';'),
unistr('      if (unknownSyn.indexOf(up) !== -1) return ''\2754'';'),
'',
'      // fuzzy contains checks',
unistr('      if (up.indexOf(''NOT'') >= 0 || up.indexOf(''FAIL'') >= 0 || up.indexOf(''FALSE'') >= 0 || up.indexOf(''NO'') >= 0) return ''\274C'';'),
unistr('      if (up.indexOf(''WORK'') >= 0 || up.indexOf(''OK'') >= 0) return ''\2705'';'),
unistr('      if (up.indexOf(''WARN'') >= 0 || up.indexOf(''WIP'') >= 0 || up.indexOf(''PARTIAL'') >= 0) return ''\26A0\FE0F'';'),
'',
unistr('      return ''\2754'';'),
'    }',
'',
'    // ---------- tiny helpers ----------',
'    function escapeHtml(str){',
'      if(str === null || str === undefined) return '''';',
'      return String(str)',
'        .replace(/&/g, ''&amp;'')',
'        .replace(/</g, ''&lt;'')',
'        .replace(/>/g, ''&gt;'')',
'        .replace(/"/g, ''&quot;'')',
'        .replace(/''/g, ''&#39;'');',
'    }',
'    function escapeHtmlAttr(val){',
'      return escapeHtml(val).replace(/"/g, ''&quot;'');',
'    }',
'',
'    // expose for debugging if needed',
'    window.renderStateIcon = renderStateIcon;',
'    console.log(''supported-devices: renderStateIcon installed (emoji-only).'');',
'  });',
'',
'})(apex.jQuery);',
''))
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
,p_region_template_options=>'#DEFAULT#:t-Region--noUI:t-Region--scrollBody'
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(124240600458907865516)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(123190819658469027204)
,p_button_name=>'ADD_UEFI'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'check things that are supported in the device'
,p_button_position=>'EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4::'
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
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(123190823013851027238)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_DEVICE_DETAILS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_device_id number := to_number(nvl(apex_application.g_x01, ''0''));',
'  v_device_name    varchar2(4000);',
'  v_manufacturer   varchar2(4000);',
'  v_state          varchar2(4000);',
'  v_codename       varchar2(4000);',
'  v_maintainer     varchar2(4000);',
'  v_contributors   varchar2(4000);',
'  v_testers        varchar2(4000);',
'  v_active         varchar2(10);',
'  v_cnt            number;',
'begin',
'  -- small debug count for logs',
'  select count(*) into v_cnt from devices where device_id = l_device_id;',
'  apex_debug.message(''GET_DEVICE_DETAILS: l_device_id=''||l_device_id||'' devices_count=''||v_cnt);',
'',
'  -- initialize JSON',
'  apex_json.initialize_clob_output;',
'  apex_json.open_object;',
'',
'  -- fetch base device/header info (left joins to avoid exceptions)',
'  begin',
'    select dv.device_name,',
'           m.manufacturer_name,',
'           dd.state,',
'           dd.codename,',
'           dd.maintainer,',
'           dd.contributors,',
'           dd.testers,',
'           dd.active_flag',
'    into v_device_name,',
'         v_manufacturer,',
'         v_state,',
'         v_codename,',
'         v_maintainer,',
'         v_contributors,',
'         v_testers,',
'         v_active',
'    from devices dv',
'    left join device_details dd on dd.device_id = dv.device_id',
'    left join manufacturers m on m.manufacturer_id = dv.manufacturer_id',
'    where dv.device_id = l_device_id;',
'  exception',
'    when no_data_found then',
'      -- leave v_* as null (client will show defaults)',
'      null;',
'  end;',
'',
'  apex_json.open_object(''device'');',
'    apex_json.write(''device_name'', v_device_name);',
'    apex_json.write(''manufacturer'', v_manufacturer);',
'    apex_json.write(''state'', v_state);',
'    apex_json.write(''codename'', v_codename);',
'    apex_json.write(''maintainer'', v_maintainer);',
'    apex_json.write(''contributors'', v_contributors);',
'    apex_json.write(''testers'', v_testers);',
'    apex_json.write(''active'', v_active);',
'  apex_json.close_object;',
'',
'  -- UEFI: return master list left-joined with device-specific rows so all features appear',
'  apex_json.open_array(''uefi'');',
'    for r in (',
'      select m.feature_name,',
'             nvl(d.description, null)        as description,',
'             nvl(d.state_code, ''UNTESTED'')   as state_code',
'      from uefi_master_list m',
'      left join device_uefi_status d',
'        on d.feature_name = m.feature_name',
'       and d.device_id = l_device_id',
'      order by m.display_order, m.feature_name',
'    ) loop',
'      apex_json.open_object;',
'        apex_json.write(''feature'', r.feature_name);',
'        apex_json.write(''description'', r.description); -- may be null',
'        apex_json.write(''state'', r.state_code);       -- defaults to ''UNTESTED'' if missing',
'      apex_json.close_object;',
'    end loop;',
'  apex_json.close_array;',
'',
'  -- debug info',
'  apex_json.open_object(''__debug'');',
'    apex_json.write(''requested_device_id'', l_device_id);',
'    apex_json.write(''devices_count'', v_cnt);',
'    apex_json.write(''device_row_found'', case when v_device_name is not null then ''Y'' else ''N'' end);',
'  apex_json.close_object;',
'',
'  apex_json.close_object;',
'',
'  -- output',
'  htp.p(apex_json.get_clob_output);',
'  apex_json.free_output;',
'exception',
'  when others then',
'    htp.p(''{"error":"PLSQL_ERROR","msg":"'' || replace(sqlerrm, ''"'', '''''''') || ''"}'');',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>123190823013851027238
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124240600327664865515)
,p_process_sequence=>50
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_DEVICE_UEFI'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_dev_id number := to_number(nvl(apex_application.g_x01,''0''));',
'  l_payload clob := nvl(apex_application.g_x02,''{}'');',
'  l_cnt number;',
'  l_i pls_integer;',
'  l_feature_id number;',
'  l_feature_name varchar2(4000);',
'  l_desc varchar2(4000);',
'  l_state varchar2(20);',
'begin',
'  apex_json.parse(l_payload);',
'  l_cnt := apex_json.get_count(''uefi'');',
'',
'  for l_i in 1..l_cnt loop',
'    begin',
'      l_feature_id := null;',
'      l_feature_name := null;',
'      begin',
'        l_feature_id := apex_json.get_number(''uefi[%d].feature_id'', l_i);',
'      exception when others then l_feature_id := null;',
'      end;',
'',
'      if l_feature_id is not null then',
'        begin',
'          select feature_name into l_feature_name from uefi_master_list where feature_id = l_feature_id;',
'        exception when others then l_feature_name := null;',
'        end;',
'      end if;',
'',
'      if l_feature_name is null then',
'        l_feature_name := apex_json.get_varchar2(''uefi[%d].feature_name'', l_i);',
'      end if;',
'',
'      l_desc := apex_json.get_varchar2(''uefi[%d].description'', l_i);',
'',
'      l_state := upper(nvl(trim(apex_json.get_varchar2(''uefi[%d].state'', l_i)),''UNTESTED''));',
'',
'      if l_state in (''WORKING'',''OK'',''TRUE'',''YES'') then',
'        l_state := ''WORKING'';',
'      elsif l_state in (''NOT_WORKING'',''NOTWORKING'',''FAIL'',''FALSE'',''NO'',''BROKEN'') then',
'        l_state := ''NOT_WORKING'';',
'      elsif l_state in (''UNKNOWN'',''N/A'',''NA'',''?'') then',
'        l_state := ''UNKNOWN'';',
'      else',
'        l_state := ''UNTESTED'';',
'      end if;',
'',
'      if l_dev_id > 0 and l_feature_name is not null then',
'        merge into device_uefi_status t',
'        using (select l_dev_id dev_id, l_feature_name fname from dual) s',
'        on (t.device_id = s.dev_id and t.feature_name = s.fname)',
'        when matched then',
'          update set t.description = l_desc, t.state_code = l_state',
'        when not matched then',
'          insert (device_id, feature_name, description, state_code)',
'          values (l_dev_id, l_feature_name, l_desc, l_state);',
'      end if;',
'    exception when others then null;',
'    end;',
'  end loop;',
'',
'  commit;',
'  htp.p(''{"ok":true}'');',
'exception when others then',
'  htp.p(''{"ok":false,"error":"'' || replace(sqlerrm, ''"'', '''''''') || ''"}'');',
'end;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>124240600327664865515
);
wwv_flow_imp.component_end;
end;
/
