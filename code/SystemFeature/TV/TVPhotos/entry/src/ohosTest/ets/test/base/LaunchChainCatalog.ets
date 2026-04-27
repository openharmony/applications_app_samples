/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export interface LaunchChainScenario {
  id: string;
  domain: string;
  ability: string;
  trigger: string;
  payload: string;
  expectedState: string;
  expectedStorageKey: string;
  steps: string[];
}

class LaunchChainScenarioRecord implements LaunchChainScenario {
  id: string;
  domain: string;
  ability: string;
  trigger: string;
  payload: string;
  expectedState: string;
  expectedStorageKey: string;
  steps: string[];

  constructor(id: string, domain: string, ability: string, trigger: string, payload: string, expectedState: string,
    expectedStorageKey: string, steps: string[]) {
    this.id = id;
    this.domain = domain;
    this.ability = ability;
    this.trigger = trigger;
    this.payload = payload;
    this.expectedState = expectedState;
    this.expectedStorageKey = expectedStorageKey;
    this.steps = steps;
  }
}

const LAUNCH_CHAIN_SCENARIOS: LaunchChainScenario[] = [
  {
    id: 'main_001',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/1|image/jpeg',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_image_payload', 'verify_direct_uri']
  },
  {
    id: 'main_002',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/2|image/png',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_png_payload', 'verify_direct_uri']
  },
  {
    id: 'main_003',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/3|video/mp4',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_video_payload', 'verify_direct_uri']
  },
  {
    id: 'main_004',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'distributed://media/4|image/jpeg',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_distributed_payload', 'verify_direct_uri']
  },
  {
    id: 'main_005',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/5|image/heif',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_heif_payload', 'verify_direct_type']
  },
  {
    id: 'main_006',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/6|image/bmp',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_bmp_payload', 'verify_direct_type']
  },
  {
    id: 'main_007',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/7|image/webp',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_webp_payload', 'verify_direct_type']
  },
  {
    id: 'main_008',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/8|application/octet-stream',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_binary_payload', 'verify_direct_type']
  },
  {
    id: 'main_009',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=true',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_close_true', 'verify_terminate_count']
  },
  {
    id: 'main_010',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=false',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_close_false', 'verify_alive_state']
  },
  {
    id: 'main_011',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=undefined',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_empty_close', 'verify_alive_state']
  },
  {
    id: 'main_012',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'uri=file://media/9',
    expectedState: 'alive',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_uri_only', 'verify_context_alive']
  },
  {
    id: 'main_013',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/10|image/gif',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_gif_payload', 'verify_direct_type']
  },
  {
    id: 'main_014',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/11|video/avi',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_avi_payload', 'verify_direct_type']
  },
  {
    id: 'main_015',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/12|audio/mp3',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_audio_payload', 'verify_direct_type']
  },
  {
    id: 'main_016',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/13|image/tiff',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_tiff_payload', 'verify_direct_type']
  },
  {
    id: 'main_017',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/14|image/raw',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_raw_payload', 'verify_direct_type']
  },
  {
    id: 'main_018',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/15|image/svg+xml',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_svg_payload', 'verify_direct_type']
  },
  {
    id: 'main_019',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/16|image/avif',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_avif_payload', 'verify_direct_type']
  },
  {
    id: 'main_020',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/17|video/mkv',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_mkv_payload', 'verify_direct_type']
  },
  {
    id: 'main_021',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/18|image/jxl',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_jxl_payload', 'verify_direct_type']
  },
  {
    id: 'main_022',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/19|image/vnd.wap.wbmp',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_wbmp_payload', 'verify_direct_type']
  },
  {
    id: 'main_023',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/20|text/plain',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_text_payload', 'verify_direct_type']
  },
  {
    id: 'main_024',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/21|application/pdf',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_pdf_payload', 'verify_direct_type']
  },
  {
    id: 'main_025',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/22|application/zip',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_zip_payload', 'verify_direct_type']
  },
  {
    id: 'main_026',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/23|image/jpeg',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_second_jpeg', 'verify_direct_uri']
  },
  {
    id: 'main_027',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/24|image/png',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_second_png', 'verify_direct_uri']
  },
  {
    id: 'main_028',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/25|video/mp4',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_second_video', 'verify_direct_uri']
  },
  {
    id: 'main_029',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=true,reason=exit',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_exit_close', 'verify_terminate_count']
  },
  {
    id: 'main_030',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=false,reason=keep',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_keep_close', 'verify_alive_state']
  },
  {
    id: 'main_031',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=true,source=picker',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_picker_close', 'verify_terminate_count']
  },
  {
    id: 'main_032',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=false,source=picker',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_picker_keep', 'verify_alive_state']
  },
  {
    id: 'main_033',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/26|image/x-icon',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_icon_payload', 'verify_direct_type']
  },
  {
    id: 'main_034',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/27|image/apng',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_apng_payload', 'verify_direct_type']
  },
  {
    id: 'main_035',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/28|video/quicktime',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_quicktime_payload', 'verify_direct_type']
  },
  {
    id: 'main_036',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/29|image/x-ms-bmp',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_msbmp_payload', 'verify_direct_type']
  },
  {
    id: 'main_037',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/30|image/jp2',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_jp2_payload', 'verify_direct_type']
  },
  {
    id: 'main_038',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/31|application/json',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_json_payload', 'verify_direct_type']
  },
  {
    id: 'main_039',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/32|application/xml',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_xml_payload', 'verify_direct_type']
  },
  {
    id: 'main_040',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'matrix',
    payload: 'main_ability_matrix',
    expectedState: 'matrix_ready',
    expectedStorageKey: 'none',
    steps: ['build_main_matrix', 'iterate_main_cases', 'verify_main_case_count']
  },
  {
    id: 'picker_001',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=1',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_1', 'verify_picker_limit']
  },
  {
    id: 'picker_002',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=2',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_2', 'verify_picker_limit']
  },
  {
    id: 'picker_003',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=3',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_3', 'verify_picker_limit']
  },
  {
    id: 'picker_004',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=4',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_4', 'verify_picker_limit']
  },
  {
    id: 'picker_005',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=5',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_5', 'verify_picker_limit']
  },
  {
    id: 'picker_006',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=6',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_6', 'verify_picker_limit']
  },
  {
    id: 'picker_007',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=7',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_7', 'verify_picker_limit']
  },
  {
    id: 'picker_008',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=8',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_8', 'verify_picker_limit']
  },
  {
    id: 'picker_009',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=9',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_9', 'verify_picker_limit']
  },
  {
    id: 'picker_010',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=10',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_10', 'verify_picker_limit']
  },
  {
    id: 'picker_011',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=20',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_20', 'verify_picker_limit']
  },
  {
    id: 'picker_012',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=50',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_50', 'verify_picker_limit']
  },
  {
    id: 'picker_013',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=99',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_99', 'verify_picker_limit']
  },
  {
    id: 'picker_014',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=0',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_0', 'verify_picker_limit']
  },
  {
    id: 'picker_015',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=true',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_close_true', 'verify_terminate_count']
  },
  {
    id: 'picker_016',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=false',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_close_false', 'verify_alive_state']
  },
  {
    id: 'picker_017',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=undefined',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_empty_close', 'verify_alive_state']
  },
  {
    id: 'picker_018',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=true,reason=finish',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_finish_close', 'verify_terminate_count']
  },
  {
    id: 'picker_019',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=false,reason=stay',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_stay_close', 'verify_alive_state']
  },
  {
    id: 'picker_020',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=12',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_12', 'verify_picker_limit']
  },
  {
    id: 'picker_021',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=14',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_14', 'verify_picker_limit']
  },
  {
    id: 'picker_022',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=16',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_16', 'verify_picker_limit']
  },
  {
    id: 'picker_023',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=18',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_18', 'verify_picker_limit']
  },
  {
    id: 'picker_024',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=24',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_24', 'verify_picker_limit']
  },
  {
    id: 'picker_025',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=32',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_32', 'verify_picker_limit']
  },
  {
    id: 'picker_026',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=40',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_40', 'verify_picker_limit']
  },
  {
    id: 'picker_027',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=48',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_48', 'verify_picker_limit']
  },
  {
    id: 'picker_028',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=64',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_64', 'verify_picker_limit']
  },
  {
    id: 'picker_029',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=72',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_72', 'verify_picker_limit']
  },
  {
    id: 'picker_030',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=80',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_80', 'verify_picker_limit']
  },
  {
    id: 'picker_031',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=88',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_88', 'verify_picker_limit']
  },
  {
    id: 'picker_032',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=96',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_96', 'verify_picker_limit']
  },
  {
    id: 'picker_033',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=true,source=main',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_main_close', 'verify_terminate_count']
  },
  {
    id: 'picker_034',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=false,source=main',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_main_keep', 'verify_alive_state']
  },
  {
    id: 'picker_035',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=true,source=entry',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_entry_close', 'verify_terminate_count']
  },
  {
    id: 'picker_036',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=false,source=entry',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_entry_keep', 'verify_alive_state']
  },
  {
    id: 'picker_037',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=100',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_100', 'verify_picker_limit']
  },
  {
    id: 'picker_038',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=128',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_128', 'verify_picker_limit']
  },
  {
    id: 'picker_039',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=256',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_limit_256', 'verify_picker_limit']
  },
  {
    id: 'picker_040',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'matrix',
    payload: 'picker_matrix',
    expectedState: 'matrix_ready',
    expectedStorageKey: 'none',
    steps: ['build_picker_matrix', 'iterate_picker_cases', 'verify_picker_case_count']
  },
  {
    id: 'entry_001',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: '1920x1080',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_window_size', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_002',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: '3840x2160',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_window_size', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_003',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: '1280x720',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_window_size', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_004',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: '1024x768',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_window_size', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_005',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: '800x600',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_window_size', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_006',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: '720x480',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_window_size', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_007',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: '640x360',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_window_size', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_008',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: '7680x4320',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_window_size', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_009',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_bundle_contract',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_bundle_name', 'verify_entry_bundle']
  },
  {
    id: 'entry_010',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_ability_contract',
    expectedState: 'want_ready',
    expectedStorageKey: 'abilityName',
    steps: ['load_entry_want', 'read_ability_name', 'verify_entry_ability']
  },
  {
    id: 'entry_011',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'persist_window_width',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['persist_window_width', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_012',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'persist_window_height',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['persist_window_height', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_013',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'full_hd_cleanup',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_full_hd_window', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_014',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'uhd_cleanup',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_uhd_window', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_015',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'small_cleanup',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_small_window', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_016',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'square_cleanup',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_square_window', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_017',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'ultrawide_cleanup',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_ultrawide_window', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_018',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'portrait_cleanup',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_portrait_window', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_019',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_launch_contract',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_launch_contract', 'verify_launch_contract']
  },
  {
    id: 'entry_020',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_stage_contract',
    expectedState: 'want_ready',
    expectedStorageKey: 'abilityName',
    steps: ['load_entry_want', 'read_stage_contract', 'verify_stage_contract']
  },
  {
    id: 'entry_021',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_21',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_21', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_022',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_22',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_22', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_023',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_23',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_23', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_024',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_24',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_24', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_025',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_25',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_25', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_026',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_26',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_26', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_027',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_27',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_27', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_028',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_28',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_28', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_029',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_29',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_29', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_030',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_30',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_30', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_031',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_31',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_31', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_032',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_32',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_32', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_033',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_33',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_case_33', 'verify_entry_bundle']
  },
  {
    id: 'entry_034',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_34',
    expectedState: 'want_ready',
    expectedStorageKey: 'abilityName',
    steps: ['load_entry_want', 'read_case_34', 'verify_entry_ability']
  },
  {
    id: 'entry_035',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_35',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_case_35', 'verify_entry_bundle']
  },
  {
    id: 'entry_036',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_36',
    expectedState: 'want_ready',
    expectedStorageKey: 'abilityName',
    steps: ['load_entry_want', 'read_case_36', 'verify_entry_ability']
  },
  {
    id: 'entry_037',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_37',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_case_37', 'verify_entry_bundle']
  },
  {
    id: 'entry_038',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_38',
    expectedState: 'want_ready',
    expectedStorageKey: 'abilityName',
    steps: ['load_entry_want', 'read_case_38', 'verify_entry_ability']
  },
  {
    id: 'entry_039',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_39',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_case_39', 'verify_entry_bundle']
  },
  {
    id: 'entry_040',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'matrix',
    payload: 'entry_matrix',
    expectedState: 'matrix_ready',
    expectedStorageKey: 'none',
    steps: ['build_entry_matrix', 'iterate_entry_cases', 'verify_entry_case_count']
  },
  {
    id: 'loader_001',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'registerDelayCallback',
    payload: 'callback_1',
    expectedState: 'callback_tracked',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'register_callback_1', 'verify_timer_tracked']
  },
  {
    id: 'loader_002',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'registerDelayCallback',
    payload: 'callback_2',
    expectedState: 'callback_tracked',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'register_callback_2', 'verify_timer_tracked']
  },
  {
    id: 'loader_003',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'registerDelayCallback',
    payload: 'callback_3',
    expectedState: 'callback_tracked',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'register_callback_3', 'verify_timer_tracked']
  },
  {
    id: 'loader_004',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'registerDelayCallback',
    payload: 'callback_4',
    expectedState: 'callback_tracked',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'register_callback_4', 'verify_timer_tracked']
  },
  {
    id: 'loader_005',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'registerDelayCallback',
    payload: 'callback_5',
    expectedState: 'callback_tracked',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'register_callback_5', 'verify_timer_tracked']
  },
  {
    id: 'loader_006',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'unregisterDataChangeCallback',
    payload: 'remove_callback_1',
    expectedState: 'callback_removed',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'remove_callback_1', 'verify_timer_removed']
  },
  {
    id: 'loader_007',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'unregisterDataChangeCallback',
    payload: 'remove_callback_2',
    expectedState: 'callback_removed',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'remove_callback_2', 'verify_timer_removed']
  },
  {
    id: 'loader_008',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'unregisterDataChangeCallback',
    payload: 'remove_callback_3',
    expectedState: 'callback_removed',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'remove_callback_3', 'verify_timer_removed']
  },
  {
    id: 'loader_009',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'unregisterDataChangeCallback',
    payload: 'remove_callback_4',
    expectedState: 'callback_removed',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'remove_callback_4', 'verify_timer_removed']
  },
  {
    id: 'loader_010',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'unregisterDataChangeCallback',
    payload: 'remove_callback_5',
    expectedState: 'callback_removed',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'remove_callback_5', 'verify_timer_removed']
  },
  {
    id: 'loader_011',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'loadPhotoSourceData',
    payload: 'empty_source',
    expectedState: 'source_empty',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'load_empty_source', 'verify_empty_state']
  },
  {
    id: 'loader_012',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'loadPhotoSourceData',
    payload: 'single_photo_source',
    expectedState: 'source_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'load_single_photo_source', 'verify_source_count']
  },
  {
    id: 'loader_013',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'loadPhotoSourceData',
    payload: 'multiple_photo_source',
    expectedState: 'source_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'load_multiple_photo_source', 'verify_source_count']
  },
  {
    id: 'loader_014',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataReload',
    payload: 'reload_1',
    expectedState: 'reload_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_reload_1', 'verify_reload_count']
  },
  {
    id: 'loader_015',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataReload',
    payload: 'reload_2',
    expectedState: 'reload_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_reload_2', 'verify_reload_count']
  },
  {
    id: 'loader_016',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataReload',
    payload: 'reload_3',
    expectedState: 'reload_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_reload_3', 'verify_reload_count']
  },
  {
    id: 'loader_017',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataDelete',
    payload: 'delete_1',
    expectedState: 'delete_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_delete_1', 'verify_delete_count']
  },
  {
    id: 'loader_018',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataDelete',
    payload: 'delete_2',
    expectedState: 'delete_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_delete_2', 'verify_delete_count']
  },
  {
    id: 'loader_019',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataAdd',
    payload: 'add_1',
    expectedState: 'add_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_add_1', 'verify_add_count']
  },
  {
    id: 'loader_020',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataAdd',
    payload: 'add_2',
    expectedState: 'add_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_add_2', 'verify_add_count']
  },
  {
    id: 'loader_021',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataChange',
    payload: 'change_1',
    expectedState: 'change_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_change_1', 'verify_change_count']
  },
  {
    id: 'loader_022',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataChange',
    payload: 'change_2',
    expectedState: 'change_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_change_2', 'verify_change_count']
  },
  {
    id: 'loader_023',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataChange',
    payload: 'change_3',
    expectedState: 'change_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_change_3', 'verify_change_count']
  },
  {
    id: 'loader_024',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataChange',
    payload: 'change_4',
    expectedState: 'change_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'trigger_change_4', 'verify_change_count']
  },
  {
    id: 'loader_025',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'resetDataSource',
    payload: 'reset_empty',
    expectedState: 'source_empty',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'reset_source_empty', 'verify_empty_state']
  },
  {
    id: 'loader_026',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'resetDataSource',
    payload: 'reset_populated',
    expectedState: 'source_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'reset_source_populated', 'verify_source_count']
  },
  {
    id: 'loader_027',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'scheduleDelay',
    payload: 'delay_60',
    expectedState: 'delay_scheduled',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'schedule_delay_60', 'verify_timer_tracked']
  },
  {
    id: 'loader_028',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'scheduleDelay',
    payload: 'delay_120',
    expectedState: 'delay_scheduled',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'schedule_delay_120', 'verify_timer_tracked']
  },
  {
    id: 'loader_029',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'scheduleDelay',
    payload: 'delay_240',
    expectedState: 'delay_scheduled',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'schedule_delay_240', 'verify_timer_tracked']
  },
  {
    id: 'loader_030',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'cancelDelay',
    payload: 'cancel_60',
    expectedState: 'delay_canceled',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'cancel_delay_60', 'verify_timer_removed']
  },
  {
    id: 'loader_031',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'cancelDelay',
    payload: 'cancel_120',
    expectedState: 'delay_canceled',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'cancel_delay_120', 'verify_timer_removed']
  },
  {
    id: 'loader_032',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'cancelDelay',
    payload: 'cancel_240',
    expectedState: 'delay_canceled',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'cancel_delay_240', 'verify_timer_removed']
  },
  {
    id: 'loader_033',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'dataObserver',
    payload: 'observer_one',
    expectedState: 'observer_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'register_observer_one', 'verify_observer_ready']
  },
  {
    id: 'loader_034',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'dataObserver',
    payload: 'observer_two',
    expectedState: 'observer_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'register_observer_two', 'verify_observer_ready']
  },
  {
    id: 'loader_035',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'dataObserver',
    payload: 'observer_three',
    expectedState: 'observer_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'register_observer_three', 'verify_observer_ready']
  },
  {
    id: 'loader_036',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'dataObserver',
    payload: 'observer_four',
    expectedState: 'observer_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'register_observer_four', 'verify_observer_ready']
  },
  {
    id: 'loader_037',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'dataObserver',
    payload: 'observer_five',
    expectedState: 'observer_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'register_observer_five', 'verify_observer_ready']
  },
  {
    id: 'loader_038',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'callbacks',
    payload: 'stability_matrix',
    expectedState: 'matrix_ready',
    expectedStorageKey: 'callbackTimers',
    steps: ['build_loader_matrix', 'iterate_loader_cases', 'verify_loader_case_count']
  },
  {
    id: 'loader_039',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'unregisterDataChangeCallback',
    payload: 'cleanup_orphan_timer',
    expectedState: 'callback_removed',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'cleanup_orphan_timer', 'verify_timer_removed']
  },
  {
    id: 'loader_040',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'matrix',
    payload: 'loader_matrix',
    expectedState: 'matrix_ready',
    expectedStorageKey: 'none',
    steps: ['build_loader_matrix', 'iterate_loader_cases', 'verify_loader_case_count']
  },
  {
    id: 'main_041',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/33|image/jpeg',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_case_41', 'verify_direct_uri']
  },
  {
    id: 'main_042',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/34|image/png',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_case_42', 'verify_direct_uri']
  },
  {
    id: 'main_043',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/35|video/mp4',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directUri',
    steps: ['create_main_ability', 'dispatch_case_43', 'verify_direct_uri']
  },
  {
    id: 'main_044',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=true,case=44',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_case_44', 'verify_terminate_count']
  },
  {
    id: 'main_045',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=false,case=45',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_case_45', 'verify_alive_state']
  },
  {
    id: 'main_046',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/36|image/heic',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_case_46', 'verify_direct_type']
  },
  {
    id: 'main_047',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/37|video/webm',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_case_47', 'verify_direct_type']
  },
  {
    id: 'main_048',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/38|application/msword',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_case_48', 'verify_direct_type']
  },
  {
    id: 'main_049',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/39|application/vnd.ms-excel',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_case_49', 'verify_direct_type']
  },
  {
    id: 'main_050',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/40|application/vnd.ms-powerpoint',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_case_50', 'verify_direct_type']
  },
  {
    id: 'main_051',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/41|image/x-portable-pixmap',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_case_51', 'verify_direct_type']
  },
  {
    id: 'main_052',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/42|image/x-portable-graymap',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_case_52', 'verify_direct_type']
  },
  {
    id: 'main_053',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onCreate',
    payload: 'file://media/43|image/x-portable-bitmap',
    expectedState: 'file_manager_ready',
    expectedStorageKey: 'directType',
    steps: ['create_main_ability', 'dispatch_case_53', 'verify_direct_type']
  },
  {
    id: 'main_054',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=true,case=54',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_case_54', 'verify_terminate_count']
  },
  {
    id: 'main_055',
    domain: '主能力创建',
    ability: 'MainAbility',
    trigger: 'onNewWant',
    payload: 'close=false,case=55',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_main_ability', 'dispatch_case_55', 'verify_alive_state']
  },
  {
    id: 'picker_041',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=512',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_41', 'verify_picker_limit']
  },
  {
    id: 'picker_042',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=1024',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_42', 'verify_picker_limit']
  },
  {
    id: 'picker_043',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=true,case=43',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_case_43', 'verify_terminate_count']
  },
  {
    id: 'picker_044',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=false,case=44',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_case_44', 'verify_alive_state']
  },
  {
    id: 'picker_045',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=11',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_45', 'verify_picker_limit']
  },
  {
    id: 'picker_046',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=13',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_46', 'verify_picker_limit']
  },
  {
    id: 'picker_047',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=15',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_47', 'verify_picker_limit']
  },
  {
    id: 'picker_048',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=17',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_48', 'verify_picker_limit']
  },
  {
    id: 'picker_049',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=19',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_49', 'verify_picker_limit']
  },
  {
    id: 'picker_050',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=21',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_50', 'verify_picker_limit']
  },
  {
    id: 'picker_051',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=23',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_51', 'verify_picker_limit']
  },
  {
    id: 'picker_052',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=25',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_52', 'verify_picker_limit']
  },
  {
    id: 'picker_053',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=true,case=53',
    expectedState: 'terminate_called',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_case_53', 'verify_terminate_count']
  },
  {
    id: 'picker_054',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'handleWant',
    payload: 'close=false,case=54',
    expectedState: 'alive',
    expectedStorageKey: 'none',
    steps: ['create_picker_ability', 'dispatch_case_54', 'verify_alive_state']
  },
  {
    id: 'picker_055',
    domain: '选择器能力',
    ability: 'PickerAbility',
    trigger: 'onNewWant',
    payload: 'maxSelectCount=2048',
    expectedState: 'picker_ready',
    expectedStorageKey: 'pickMaxSelectCount',
    steps: ['create_picker_ability', 'dispatch_case_55', 'verify_picker_limit']
  },
  {
    id: 'entry_041',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_41',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_41', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_042',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_42',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_42', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_043',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_43',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_case_43', 'verify_entry_bundle']
  },
  {
    id: 'entry_044',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_44',
    expectedState: 'want_ready',
    expectedStorageKey: 'abilityName',
    steps: ['load_entry_want', 'read_case_44', 'verify_entry_ability']
  },
  {
    id: 'entry_045',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_45',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_45', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_046',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_46',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_46', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_047',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_47',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_case_47', 'verify_entry_bundle']
  },
  {
    id: 'entry_048',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_48',
    expectedState: 'want_ready',
    expectedStorageKey: 'abilityName',
    steps: ['load_entry_want', 'read_case_48', 'verify_entry_ability']
  },
  {
    id: 'entry_049',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_49',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_49', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_050',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_50',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_50', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_051',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_51',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_case_51', 'verify_entry_bundle']
  },
  {
    id: 'entry_052',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_52',
    expectedState: 'want_ready',
    expectedStorageKey: 'abilityName',
    steps: ['load_entry_want', 'read_case_52', 'verify_entry_ability']
  },
  {
    id: 'entry_053',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_53',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_width',
    steps: ['set_cleanup_case_53', 'destroy_entry_ability', 'verify_width_cleared']
  },
  {
    id: 'entry_054',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'onDestroy',
    payload: 'cleanup_case_54',
    expectedState: 'storage_cleared',
    expectedStorageKey: 'window_height',
    steps: ['set_cleanup_case_54', 'destroy_entry_ability', 'verify_height_cleared']
  },
  {
    id: 'entry_055',
    domain: '入口清理',
    ability: 'EntryAbility',
    trigger: 'want',
    payload: 'entry_want_case_55',
    expectedState: 'want_ready',
    expectedStorageKey: 'bundleName',
    steps: ['load_entry_want', 'read_case_55', 'verify_entry_bundle']
  },
  {
    id: 'loader_041',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'registerDelayCallback',
    payload: 'callback_41',
    expectedState: 'callback_tracked',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'register_case_41', 'verify_timer_tracked']
  },
  {
    id: 'loader_042',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'registerDelayCallback',
    payload: 'callback_42',
    expectedState: 'callback_tracked',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'register_case_42', 'verify_timer_tracked']
  },
  {
    id: 'loader_043',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'unregisterDataChangeCallback',
    payload: 'remove_case_43',
    expectedState: 'callback_removed',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'remove_case_43', 'verify_timer_removed']
  },
  {
    id: 'loader_044',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataReload',
    payload: 'reload_case_44',
    expectedState: 'reload_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'reload_case_44', 'verify_reload_count']
  },
  {
    id: 'loader_045',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataDelete',
    payload: 'delete_case_45',
    expectedState: 'delete_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'delete_case_45', 'verify_delete_count']
  },
  {
    id: 'loader_046',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataAdd',
    payload: 'add_case_46',
    expectedState: 'add_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'add_case_46', 'verify_add_count']
  },
  {
    id: 'loader_047',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataChange',
    payload: 'change_case_47',
    expectedState: 'change_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'change_case_47', 'verify_change_count']
  },
  {
    id: 'loader_048',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'scheduleDelay',
    payload: 'delay_case_48',
    expectedState: 'delay_scheduled',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'schedule_case_48', 'verify_timer_tracked']
  },
  {
    id: 'loader_049',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'cancelDelay',
    payload: 'cancel_case_49',
    expectedState: 'delay_canceled',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'cancel_case_49', 'verify_timer_removed']
  },
  {
    id: 'loader_050',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'dataObserver',
    payload: 'observer_case_50',
    expectedState: 'observer_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'observer_case_50', 'verify_observer_ready']
  },
  {
    id: 'loader_051',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'registerDelayCallback',
    payload: 'callback_51',
    expectedState: 'callback_tracked',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'register_case_51', 'verify_timer_tracked']
  },
  {
    id: 'loader_052',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'unregisterDataChangeCallback',
    payload: 'remove_case_52',
    expectedState: 'callback_removed',
    expectedStorageKey: 'callbackTimers',
    steps: ['create_loader', 'remove_case_52', 'verify_timer_removed']
  },
  {
    id: 'loader_053',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'notifyDataReload',
    payload: 'reload_case_53',
    expectedState: 'reload_notified',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'reload_case_53', 'verify_reload_count']
  },
  {
    id: 'loader_054',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'dataObserver',
    payload: 'observer_case_54',
    expectedState: 'observer_ready',
    expectedStorageKey: 'photoSource',
    steps: ['create_loader', 'observer_case_54', 'verify_observer_ready']
  },
  {
    id: 'loader_055',
    domain: '加载器回调',
    ability: 'BasePhotoLoader',
    trigger: 'callbacks',
    payload: 'loader_matrix_55',
    expectedState: 'matrix_ready',
    expectedStorageKey: 'callbackTimers',
    steps: ['build_loader_matrix', 'iterate_case_55', 'verify_loader_case_count']
  }
];

export class LaunchChainCatalog {
  static getAll(): LaunchChainScenario[] {
    return LAUNCH_CHAIN_SCENARIOS.map((item) => {
      return new LaunchChainScenarioRecord(
        item.id,
        item.domain,
        item.ability,
        item.trigger,
        item.payload,
        item.expectedState,
        item.expectedStorageKey,
        [...item.steps]
      );
    });
  }

  static getDomains(): string[] {
    return ['主能力创建', '选择器能力', '入口清理', '加载器回调'];
  }

  static getByDomain(domain: string): LaunchChainScenario[] {
    return LaunchChainCatalog.getAll().filter((item) => item.domain === domain);
  }

  static findById(id: string): LaunchChainScenario | undefined {
    return LaunchChainCatalog.getAll().find((item) => item.id === id);
  }
}
