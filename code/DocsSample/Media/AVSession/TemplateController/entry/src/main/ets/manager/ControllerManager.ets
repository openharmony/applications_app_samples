/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

// [Start create_controller]
// [Start query_home_content]
// [Start play_for_search]
// [Start register_user_info_change]
// [Start release]
// [Start get_all_descriptors]
// [Start register_template_create]
// [Start unregister_template_create]
// [Start register_template_destroy]
// [Start unregister_template_destroy]
// [Start query_main_tabs]
// [Start query_media_tab_content]
// [Start query_media_entity]
// [Start query_compilation]
// [Start query_play_list]
// [Start query_current_single]
// [Start query_compilation_by_keyword]
// [Start query_media_entity_by_keyword]
// [Start query_recommend_media_entity_list]
// [Start query_hot_words]
// [Start query_search_history]
// [Start clear_search_history]
// [Start update_settings]
// [Start report_problem_and_advice]
// [Start login]
// [Start request_dialog_info]
// [Start handle_member_purchase]
// [Start query_member_purchase]
// [Start query_custom_content]
// [Start download_media_entity]
// [Start execute_action]
// [Start play_media_entity]
// [Start favorite_media_entity]
// [Start unregister_user_info_change]
// [Start register_dialog_command_change]
// [Start unregister_dialog_command_change]
// [Start register_current_single_change]
// [Start unregister_current_single_change]
// [Start register_media_entities_change]
// [Start unregister_media_entities_change]
// [Start register_tab_content_change]
// [Start unregister_tab_content_change]
// [Start register_play_list_change]
// [Start unregister_play_list_change]
// [Start register_download_media_entity_status_change]
// [Start unregister_download_media_entity_status_change]
// [Start register_custom_elements_change]
// [Start unregister_custom_elements_change]
// [Start register_settings_change]
// [Start unregister_settings_change]
// [Start register_report_execute_action]
// [Start unregister_report_execute_action]
// [Start register_extension_ability_change]
// [Start unregister_extension_ability_change]
// [Start destroy]
import avMusicTemplate from '@ohos.multimedia.avMusicTemplate';
// [StartExclude create_controller]
// [StartExclude query_home_content]
// [StartExclude play_for_search]
// [StartExclude register_user_info_change]
// [StartExclude release]
// [StartExclude get_all_descriptors]
// [StartExclude register_template_create]
// [StartExclude unregister_template_create]
// [StartExclude register_template_destroy]
// [StartExclude unregister_template_destroy]
// [StartExclude query_main_tabs]
// [StartExclude query_media_tab_content]
// [StartExclude query_media_entity]
// [StartExclude query_compilation]
// [StartExclude query_play_list]
// [StartExclude query_current_single]
// [StartExclude query_compilation_by_keyword]
// [StartExclude query_media_entity_by_keyword]
// [StartExclude query_recommend_media_entity_list]
// [StartExclude query_hot_words]
// [StartExclude query_search_history]
// [StartExclude clear_search_history]
// [StartExclude update_settings]
// [StartExclude report_problem_and_advice]
// [StartExclude login]
// [StartExclude request_dialog_info]
// [StartExclude handle_member_purchase]
// [StartExclude query_member_purchase]
// [StartExclude query_custom_content]
// [StartExclude download_media_entity]
// [StartExclude execute_action]
// [StartExclude play_media_entity]
// [StartExclude favorite_media_entity]
// [StartExclude unregister_user_info_change]
// [StartExclude register_dialog_command_change]
// [StartExclude unregister_dialog_command_change]
// [StartExclude register_current_single_change]
// [StartExclude unregister_current_single_change]
// [StartExclude register_media_entities_change]
// [StartExclude unregister_media_entities_change]
// [StartExclude register_tab_content_change]
// [StartExclude unregister_tab_content_change]
// [StartExclude register_play_list_change]
// [StartExclude unregister_play_list_change]
// [StartExclude register_download_media_entity_status_change]
// [StartExclude unregister_download_media_entity_status_change]
// [StartExclude register_custom_elements_change]
// [StartExclude unregister_custom_elements_change]
// [StartExclude register_settings_change]
// [StartExclude unregister_settings_change]
// [StartExclude register_report_execute_action]
// [StartExclude unregister_report_execute_action]
// [StartExclude register_extension_ability_change]
// [StartExclude unregister_extension_ability_change]
// [StartExclude destroy]
import { WantAgent } from '@kit.AbilityKit';
// [EndExclude create_controller]
// [EndExclude query_home_content]
// [EndExclude play_for_search]
// [EndExclude register_user_info_change]
// [EndExclude release]
// [EndExclude get_all_descriptors]
// [EndExclude register_template_create]
// [EndExclude unregister_template_create]
// [EndExclude register_template_destroy]
// [EndExclude unregister_template_destroy]
// [EndExclude query_main_tabs]
// [EndExclude query_media_tab_content]
// [EndExclude query_media_entity]
// [EndExclude query_compilation]
// [EndExclude query_play_list]
// [EndExclude query_current_single]
// [EndExclude query_compilation_by_keyword]
// [EndExclude query_media_entity_by_keyword]
// [EndExclude query_recommend_media_entity_list]
// [EndExclude query_hot_words]
// [EndExclude query_search_history]
// [EndExclude clear_search_history]
// [EndExclude update_settings]
// [EndExclude report_problem_and_advice]
// [EndExclude login]
// [EndExclude request_dialog_info]
// [EndExclude handle_member_purchase]
// [EndExclude query_member_purchase]
// [EndExclude query_custom_content]
// [EndExclude download_media_entity]
// [EndExclude execute_action]
// [EndExclude play_media_entity]
// [EndExclude favorite_media_entity]
// [EndExclude unregister_user_info_change]
// [EndExclude register_dialog_command_change]
// [EndExclude unregister_dialog_command_change]
// [EndExclude register_current_single_change]
// [EndExclude unregister_current_single_change]
// [EndExclude register_media_entities_change]
// [EndExclude unregister_media_entities_change]
// [EndExclude register_tab_content_change]
// [EndExclude unregister_tab_content_change]
// [EndExclude register_play_list_change]
// [EndExclude unregister_play_list_change]
// [EndExclude register_download_media_entity_status_change]
// [EndExclude unregister_download_media_entity_status_change]
// [EndExclude register_custom_elements_change]
// [EndExclude unregister_custom_elements_change]
// [EndExclude register_settings_change]
// [EndExclude unregister_settings_change]
// [EndExclude register_report_execute_action]
// [EndExclude unregister_report_execute_action]
// [EndExclude register_extension_ability_change]
// [EndExclude unregister_extension_ability_change]
// [EndExclude destroy]

const TAG: string = 'ControllerManager';

export class ControllerManager {
  // [StartExclude get_all_descriptors]
  // [StartExclude register_template_create]
  // [StartExclude unregister_template_create]
  // [StartExclude register_template_destroy]
  // [StartExclude unregister_template_destroy]
  private controller: avMusicTemplate.AVMusicTemplateController | undefined = undefined;
  // [StartExclude query_home_content]
  // [StartExclude play_for_search]
  // [StartExclude register_user_info_change]
  // [EndExclude get_all_descriptors]
  // [StartExclude query_main_tabs]
  // [StartExclude query_media_tab_content]
  // [StartExclude query_media_entity]
  // [StartExclude query_compilation]
  // [StartExclude query_play_list]
  // [StartExclude query_current_single]
  // [StartExclude query_compilation_by_keyword]
  // [StartExclude query_media_entity_by_keyword]
  // [StartExclude query_recommend_media_entity_list]
  // [StartExclude query_hot_words]
  // [StartExclude query_search_history]
  // [StartExclude clear_search_history]
  // [StartExclude update_settings]
  // [StartExclude report_problem_and_advice]
  // [StartExclude login]
  // [StartExclude request_dialog_info]
  // [StartExclude handle_member_purchase]
  // [StartExclude query_member_purchase]
  // [StartExclude query_custom_content]
  // [StartExclude download_media_entity]
  // [StartExclude execute_action]
  // [StartExclude play_media_entity]
  // [StartExclude favorite_media_entity]
  // [StartExclude unregister_user_info_change]
  // [StartExclude register_dialog_command_change]
  // [StartExclude unregister_dialog_command_change]
  // [StartExclude register_current_single_change]
  // [StartExclude unregister_current_single_change]
  // [StartExclude register_media_entities_change]
  // [StartExclude unregister_media_entities_change]
  // [StartExclude register_tab_content_change]
  // [StartExclude unregister_tab_content_change]
  // [StartExclude register_play_list_change]
  // [StartExclude unregister_play_list_change]
  // [StartExclude register_download_media_entity_status_change]
  // [StartExclude unregister_download_media_entity_status_change]
  // [StartExclude register_custom_elements_change]
  // [StartExclude unregister_custom_elements_change]
  // [StartExclude register_settings_change]
  // [StartExclude unregister_settings_change]
  // [StartExclude register_report_execute_action]
  // [StartExclude unregister_report_execute_action]
  // [StartExclude register_extension_ability_change]
  // [StartExclude unregister_extension_ability_change]
  private currentBundleName: string | undefined = undefined;
  // [StartExclude create_controller]
  // [StartExclude release]
  // [StartExclude get_all_descriptors]
  // [StartExclude destroy]
  private static sInstance: ControllerManager;
  // [EndExclude create_controller]
  // [EndExclude register_template_create]
  private templateCreateCallback: Callback<avMusicTemplate.AVMusicTemplateDescriptor> =
    (descriptor: avMusicTemplate.AVMusicTemplateDescriptor) => {
      if (this.isInvalid(descriptor)) {
        console.warn(TAG, 'templateCreateCallback: descriptor is invalid');
        return;
      }
      console.info(TAG, `templateCreateCallback, bundleName: ${descriptor.bundleName}`);
      this.createController(descriptor.sessionId, descriptor.bundleName);
    };
  // [StartExclude register_template_create]
  // [EndExclude register_template_destroy]
  private templateDestroyCallback: Callback<avMusicTemplate.AVMusicTemplateDescriptor> =
    (descriptor: avMusicTemplate.AVMusicTemplateDescriptor) => {
      // [StartExclude register_template_destroy]
      if (this.isInvalid(descriptor)) {
        console.warn(TAG, 'templateDestroyCallback: descriptor is invalid');
        return;
      }
      if (this.isStringEmpty(this.currentBundleName)) {
        console.warn(TAG, 'templateDestroyCallback: current bundleName is empty');
        return;
      }
      if (this.currentBundleName !== descriptor.bundleName) {
        console.warn(TAG, 'templateDestroyCallback: not current bundleName');
        return;
      }
      this.unregisterListener();
      this.destroyController();
      // [EndExclude register_template_destroy]
    };
  // [StartExclude create_controller]
  // [EndExclude register_user_info_change]
  // [StartExclude register_template_destroy]
  private userInfoChangeCallback: Callback<avMusicTemplate.UserInfo> = (userInfo: avMusicTemplate.UserInfo) => {
    console.info(TAG, 'userInfoChangeCallback');
  };
  // [StartExclude register_user_info_change]
  // [EndExclude register_dialog_command_change]
  private reportDialogCommandEvent: avMusicTemplate.ReportDialogCommandEvent =
    (type: avMusicTemplate.DialogControlType, buttonInfo: avMusicTemplate.DialogInfo) => {
      console.info(TAG, 'reportDialogCommandEvent');
    };
  // [StartExclude register_dialog_command_change]
  // [EndExclude register_current_single_change]
  private currentSingleChangeCallback: Callback<avMusicTemplate.Single> = (single: avMusicTemplate.Single) => {
    console.info(TAG, 'onCurrentSingleChange');
  };
  // [StartExclude register_current_single_change]
  // [EndExclude register_media_entities_change]
  private mediaEntitiesChangeCallback: Callback<avMusicTemplate.MediaEntity[]> =
    (single: avMusicTemplate.MediaEntity[]) => {
      console.info(TAG, 'mediaEntitiesChangeCallback');
    };
  // [StartExclude register_media_entities_change]
  // [EndExclude register_tab_content_change]
  private reportTabContentEvent: avMusicTemplate.ReportTabContentEvent =
    (tabId: string, tabContent: avMusicTemplate.MediaTabContent) => {
      console.info(TAG, 'reportTabContentEvent');
    };
  // [StartExclude register_tab_content_change]
  // [EndExclude register_play_list_change]
  private playlistChangeCallback: Callback<avMusicTemplate.PageMediaEntity> =
    (pageMediaEntity: avMusicTemplate.PageMediaEntity) => {
      console.info(TAG, 'playlistChangeCallback');
    };
  // [StartExclude register_play_list_change]
  // [EndExclude register_download_media_entity_status_change]
  private downloadStatusChangeCallback: Callback<avMusicTemplate.MediaEntity> =
    (mediaEntity: avMusicTemplate.MediaEntity) => {
      console.info(TAG, 'downloadStatusChangeCallback');
    };
  // [StartExclude register_download_media_entity_status_change]
  // [EndExclude register_custom_elements_change]
  private reportCustomElementsChangeEvent: avMusicTemplate.ReportCustomElementsChangeEvent =
    (actionType: avMusicTemplate.ActionType, customType: avMusicTemplate.CustomType,
      customElement: avMusicTemplate.CustomElement) => {
      console.info(TAG, 'reportCustomElementsChangeEvent');
    };
  // [StartExclude register_custom_elements_change]
  // [EndExclude register_settings_change]
  private settingsChangeCallback: Callback<avMusicTemplate.SettingItem[]> =
    (settingItems: avMusicTemplate.SettingItem[]) => {
      console.info(TAG, 'settingsChangeCallback');
    };
  // [StartExclude register_settings_change]
  // [EndExclude register_report_execute_action]
  private reportExecuteActionEvent: avMusicTemplate.ReportExecuteActionEvent =
    (actionType: string, customType: string) => {
      console.info(TAG, 'reportExecuteActionEvent');
    };
  // [StartExclude register_report_execute_action]
  // [EndExclude register_extension_ability_change]
  private reportExecuteAbilityEvent: avMusicTemplate.ReportExecuteAbilityEvent = (want: WantAgent) => {
    console.info(TAG, 'reportExecuteAbilityEvent');
  };
  // [StartExclude register_extension_ability_change]

  private constructor() {
  }

  /**
   * 获取模板控制器实例
   *
   * @returns 模板控制器实例
   */
  public static getInstance(): ControllerManager {
    if (!ControllerManager.sInstance) {
      ControllerManager.sInstance = new ControllerManager();
    }
    return ControllerManager.sInstance;
  };
  // [EndExclude create_controller]
  // [EndExclude get_all_descriptors]

  /**
   * 通过getAllAVMusicTemplateDescriptors创建模板
   */
  public createAvMusicTemplateController(bundleName: string) {
    if (this.isStringEmpty(bundleName)) {
      console.warn(TAG, 'createAvMusicTemplateController: bundleName is empty');
      return;
    }
    this.currentBundleName = bundleName;
    try {
      // 该方法需要权限ohos.permission.MANAGE_MEDIA_RESOURCES
      let descriptors: avMusicTemplate.AVMusicTemplateDescriptor[] = avMusicTemplate.getAllAVMusicTemplateDescriptors();
      // [StartExclude get_all_descriptors]
      if (this.isEmptyArray(descriptors)) {
        console.info(TAG, 'createAvMusicTemplateController: descriptors is empty');
        return;
      }
      for (let descriptor of descriptors) {
        if (descriptor === null || descriptor === undefined) {
          console.warn(TAG, 'createAvMusicTemplateController: descriptor is invalid continue');
          continue;
        }
        if (this.currentBundleName === descriptor.bundleName) {
          this.createController(descriptor.sessionId, descriptor.bundleName);
          return;
        }
      }
      // [EndExclude get_all_descriptors]
    } catch (e) {
      console.error(TAG, `getAllAVMusicTemplateDescriptors failed, errCode: ${e?.code}`);
    }
  };
  // [EndExclude register_template_create]

  // [StartExclude get_all_descriptors]
  private isInvalid<T>(obj: T): boolean {
    return obj === undefined || obj === null;
  }

  // [EndExclude get_all_descriptors]
  // [StartExclude register_template_create]
  private isStringEmpty(str: string | undefined): boolean {
    return str === undefined || str === null || str.trim().length === 0;
  }
  // [StartExclude get_all_descriptors]

  private isEmptyArray<T>(array: T[]): boolean {
    return this.isInvalid(array) || array.length <= 0;
  }

  // [EndExclude register_template_create]
  // [EndExclude register_template_destroy]
  /**
   * 注册模板监听
   */
  public registerAVMusicTemplateListener() {
    try {
      // [StartExclude register_template_destroy]
      // 该方法需要权限ohos.permission.MANAGE_MEDIA_RESOURCES
      avMusicTemplate.onAVMusicTemplateCreate(this.templateCreateCallback);
      // [EndExclude register_template_destroy]
      // [StartExclude register_template_create]
      // 该方法需要权限ohos.permission.MANAGE_MEDIA_RESOURCES
      avMusicTemplate.onAVMusicTemplateDestroy(this.templateDestroyCallback);
      // [EndExclude register_template_create]
    } catch (e) {
      console.error(TAG, `registerAVMusicTemplateListener: errCode: ${e?.code}`);
    }
  }
  // [StartExclude register_template_create]
  // [StartExclude register_template_destroy]

  private createController(sessionId: string, bundleName: string) {
    if (this.currentBundleName === null || this.currentBundleName === undefined) {
      console.warn(TAG, 'createController: sessionId is invalid');
      return;
    }
    if (sessionId === null || sessionId === undefined) {
      console.warn(TAG, 'createController: sessionId is invalid');
      return;
    }
    if (bundleName === null || bundleName === undefined) {
      console.warn(TAG, 'createController: bundleName is invalid');
      return;
    }
    if (this.currentBundleName !== bundleName) {
      console.warn(TAG, 'createController: not current bundleName');
      return;
    }
    if (this.controller != undefined) {
      console.warn(TAG, 'createController: controller not undefined');
      return;
    }
    try {
      this.controller = avMusicTemplate.createAVMusicTemplateController(sessionId);
      console.info(TAG, `createController success, bundleName: ${this.currentBundleName}`);
      // [StartExclude create_controller]
      this.registerListener();
      // [EndExclude create_controller]
    } catch (e) {
      console.error(TAG, `createController: errCode: ${e?.code}`);
    }
  }
  // [EndExclude register_user_info_change]
  // [EndExclude register_dialog_command_change]
  // [EndExclude register_current_single_change]
  // [EndExclude register_media_entities_change]
  // [EndExclude register_tab_content_change]
  // [EndExclude register_play_list_change]
  // [EndExclude register_download_media_entity_status_change]
  // [EndExclude register_custom_elements_change]
  // [EndExclude register_settings_change]
  // [EndExclude register_report_execute_action]
  // [EndExclude register_extension_ability_change]

  // [StartExclude create_controller]
  private registerListener() {
    // [StartExclude register_dialog_command_change]
    // [StartExclude register_current_single_change]
    // [StartExclude register_media_entities_change]
    // [StartExclude register_tab_content_change]
    // [StartExclude register_play_list_change]
    // [StartExclude register_download_media_entity_status_change]
    // [StartExclude register_custom_elements_change]
    // [StartExclude register_settings_change]
    // [StartExclude register_report_execute_action]
    // [StartExclude register_extension_ability_change]
    // 注册用户信息改变的监听。
    this.controller?.onUserInfoChange(this.userInfoChangeCallback);
    // [StartExclude register_user_info_change]

    // [EndExclude register_dialog_command_change]
    // 注册弹框命令改变的监听。
    this.controller?.onDialogCommandChange(this.reportDialogCommandEvent);
    // [StartExclude register_dialog_command_change]

    // [EndExclude register_current_single_change]
    // 注册当前单曲改变的监听。
    this.controller?.onCurrentSingleChange(this.currentSingleChangeCallback);
    // [StartExclude register_current_single_change]

    // [EndExclude register_media_entities_change]
    // 注册媒体实体改变的监听。
    this.controller?.onMediaEntitiesChange(this.mediaEntitiesChangeCallback);
    // [StartExclude register_media_entities_change]

    // [EndExclude register_tab_content_change]
    // 注册标签页内容改变的监听。
    this.controller?.onTabContentChange(this.reportTabContentEvent);
    // [StartExclude register_tab_content_change]

    // [EndExclude register_play_list_change]
    // 注册播放列表改变的监听。
    this.controller?.onPlaylistChange(this.playlistChangeCallback);
    // [StartExclude register_play_list_change]

    // [EndExclude register_download_media_entity_status_change]
    // 注册下载媒体状态改变的监听。
    this.controller?.onDownloadMediaEntityStatusChange(this.downloadStatusChangeCallback);
    // [StartExclude register_download_media_entity_status_change]

    // [EndExclude register_custom_elements_change]
    // 注册自定义元素改变的监听。
    this.controller?.onCustomElementsChange(this.reportCustomElementsChangeEvent);
    // [StartExclude register_custom_elements_change]

    // [EndExclude register_settings_change]
    // 注册设置改变的监听。
    this.controller?.onSettingsChange(this.settingsChangeCallback);
    // [StartExclude register_settings_change]

    // [EndExclude register_report_execute_action]
    // 注册上报执行动作的监听。
    this.controller?.onReportExecuteAction(this.reportExecuteActionEvent);
    // [StartExclude register_report_execute_action]

    // [EndExclude register_extension_ability_change]
    // 注册通知媒体中心拉起指定三方应用界面的信息的监听。
    this.controller?.onExtensionAbilityChange(this.reportExecuteAbilityEvent);
    // [EndExclude register_user_info_change]
    // [EndExclude register_dialog_command_change]
    // [EndExclude register_current_single_change]
    // [EndExclude register_media_entities_change]
    // [EndExclude register_tab_content_change]
    // [EndExclude register_play_list_change]
    // [EndExclude register_download_media_entity_status_change]
    // [EndExclude register_custom_elements_change]
    // [EndExclude register_settings_change]
    // [EndExclude register_report_execute_action]
  }
  // [StartExclude register_user_info_change]
  // [EndExclude unregister_user_info_change]
  // [StartExclude register_dialog_command_change]
  // [EndExclude unregister_dialog_command_change]
  // [StartExclude register_current_single_change]
  // [EndExclude unregister_current_single_change]
  // [StartExclude register_media_entities_change]
  // [EndExclude unregister_media_entities_change]
  // [StartExclude register_tab_content_change]
  // [EndExclude unregister_tab_content_change]
  // [StartExclude register_play_list_change]
  // [EndExclude unregister_play_list_change]
  // [StartExclude register_download_media_entity_status_change]
  // [EndExclude unregister_download_media_entity_status_change]
  // [StartExclude register_custom_elements_change]
  // [EndExclude unregister_custom_elements_change]
  // [StartExclude register_settings_change]
  // [EndExclude unregister_settings_change]
  // [StartExclude register_report_execute_action]
  // [EndExclude unregister_report_execute_action]
  // [StartExclude register_extension_ability_change]
  // [EndExclude unregister_extension_ability_change]

  // [EndExclude create_controller]
  // [EndExclude release]
  /**
   * 注销监听
   */
  public unregisterListener() {
    // [StartExclude unregister_dialog_command_change]
    // [StartExclude unregister_current_single_change]
    // [StartExclude unregister_media_entities_change]
    // [StartExclude unregister_tab_content_change]
    // [StartExclude unregister_play_list_change]
    // [StartExclude unregister_download_media_entity_status_change]
    // [StartExclude unregister_custom_elements_change]
    // [StartExclude unregister_settings_change]
    // [StartExclude unregister_report_execute_action]
    // [StartExclude unregister_extension_ability_change]
    // 注销用户信息改变的监听。
    this.controller?.offUserInfoChange();
    // [StartExclude unregister_user_info_change]

    // [EndExclude unregister_dialog_command_change]
    // 注销弹框命令改变的监听。
    this.controller?.offDialogCommandChange();
    // [StartExclude unregister_dialog_command_change]

    // [EndExclude unregister_current_single_change]
    // 注销当前单曲改变的监听。
    this.controller?.offCurrentSingleChange();
    // [StartExclude unregister_current_single_change]

    // [EndExclude unregister_media_entities_change]
    // 注销媒体实体改变的监听。
    this.controller?.offMediaEntitiesChange();
    // [StartExclude unregister_media_entities_change]

    // [EndExclude unregister_tab_content_change]
    // 注销标签页内容改变的监听。
    this.controller?.offTabContentChange();
    // [StartExclude unregister_tab_content_change]

    // [EndExclude unregister_play_list_change]
    // 注销播放列表改变的监听。
    this.controller?.offPlaylistChange();
    // [StartExclude unregister_play_list_change]

    // [EndExclude unregister_download_media_entity_status_change]
    // 注销下载媒体状态改变的监听。
    this.controller?.offDownloadMediaEntityStatusChange();
    // [StartExclude unregister_download_media_entity_status_change]

    // [EndExclude unregister_custom_elements_change]
    // 注销自定义元素改变的监听。
    this.controller?.offCustomElementsChange();
    // [StartExclude unregister_custom_elements_change]

    // [EndExclude unregister_settings_change]
    // 注销设置改变的监听。
    this.controller?.offSettingsChange();
    // [StartExclude unregister_settings_change]

    // [EndExclude unregister_report_execute_action]
    // 注销上报执行动作的监听。
    this.controller?.offReportExecuteAction();
    // [StartExclude unregister_report_execute_action]

    // [EndExclude unregister_extension_ability_change]
    // 注销通知媒体中心拉起指定三方应用界面的信息的监听。
    this.controller?.offExtensionAbilityChange();
    // [EndExclude unregister_user_info_change]
    // [EndExclude unregister_dialog_command_change]
    // [EndExclude unregister_current_single_change]
    // [EndExclude unregister_media_entities_change]
    // [EndExclude unregister_tab_content_change]
    // [EndExclude unregister_play_list_change]
    // [EndExclude unregister_download_media_entity_status_change]
    // [EndExclude unregister_custom_elements_change]
    // [EndExclude unregister_settings_change]
    // [EndExclude unregister_report_execute_action]
  }
  // [StartExclude unregister_user_info_change]
  // [StartExclude unregister_dialog_command_change]
  // [StartExclude unregister_current_single_change]
  // [StartExclude unregister_media_entities_change]
  // [StartExclude unregister_tab_content_change]
  // [StartExclude unregister_play_list_change]
  // [StartExclude unregister_download_media_entity_status_change]
  // [StartExclude unregister_custom_elements_change]
  // [StartExclude unregister_settings_change]
  // [StartExclude unregister_report_execute_action]
  // [StartExclude unregister_extension_ability_change]
  // [EndExclude destroy]

  /**
   * 销毁控制器
   */
  public destroyController() {
    console.info(TAG, 'destroyController')
    this.controller?.destroy();
    this.controller = undefined;
    this.currentBundleName = undefined;
  }
  // [StartExclude destroy]

  // [EndExclude unregister_template_create]
  // [EndExclude unregister_template_destroy]
  /**
   * 反注册模板监听
   */
  public unregisterAVMusicTemplateListener() {
    try {
      // [StartExclude unregister_template_destroy]
      avMusicTemplate.offAVMusicTemplateCreate();
      // [EndExclude unregister_template_destroy]
      // [StartExclude unregister_template_create]
      avMusicTemplate.offAVMusicTemplateDestroy();
      // [EndExclude unregister_template_create]
    } catch (e) {
      console.error(TAG, `unregisterAVMusicTemplateListener: errCode: ${e?.code}`);
    }
  }
  // [StartExclude create_controller]
  // [EndExclude query_home_content]
  // [StartExclude release]
  // [StartExclude unregister_template_create]
  // [StartExclude unregister_template_destroy]
  // [EndExclude query_main_tabs]

  /**
   * 查询主标签。
   */
  public async queryMainTabs(): Promise<avMusicTemplate.MediaTab[]> {
    let tabs: avMusicTemplate.MediaTab[] = [];
    if (!this.controller) {
      console.info(TAG, 'queryMainTabs: controller is undefined')
      return tabs;
    }
    try {
      console.info(TAG, 'queryMainTabs')
      tabs = await this.controller.queryMainTabs();
    } catch (e) {
      console.error(TAG, `queryMainTabs failed, errCode: ${e?.code}`)
    }
    return tabs;
  }
  // [StartExclude query_main_tabs]
  // [EndExclude query_media_tab_content]

  /**
   * 模拟查询媒体标签页内容
   *
   * @param tabId 标签页ID
   */
  public async queryMediaTabContent(tabId: string): Promise<avMusicTemplate.MediaTabContent | undefined> {
    try {
      let tabContent: avMusicTemplate.MediaTabContent | undefined = await this.controller?.queryMediaTabContent(tabId);
      if (tabContent?.errorCode != 0) {
        console.warn(TAG, 'queryMediaTabContent fail')
        return undefined;
      }
      console.info(TAG, 'queryMediaTabContent success')
      return tabContent;
    } catch (e) {
      console.error(TAG, `queryMediaTabContent failed, errCode: ${e?.code}`)
      return undefined;
    }
  }
  // [StartExclude query_home_content]
  // [StartExclude query_media_tab_content]
  // [EndExclude query_media_entity]

  /**
   * 模拟查询媒体实体
   *
   * @returns 页面媒体实体
   */
  public async queryMediaEntity(): Promise<avMusicTemplate.PageMediaEntity | undefined> {
    // 查询媒体实体。
    let queryMediaEntityParam: avMusicTemplate.QueryMediaEntityParam = {
      entityId: 'entityId',
      pageIndex: 0,
      type: avMusicTemplate.EntityType.SINGLE
    };
    try {
      let pageMediaEntity: avMusicTemplate.PageMediaEntity | undefined =
        await this.controller?.queryMediaEntity(queryMediaEntityParam);
      if (pageMediaEntity?.errorCode != 0) {
        console.warn(TAG, 'queryMediaEntity fail')
        return undefined;
      }
      console.info(TAG, 'queryMediaEntity success')
      return pageMediaEntity;
    } catch (e) {
      console.error(TAG, `queryMediaEntity failed, errCode: ${e?.code}`)
      return undefined;
    }
  };
  // [StartExclude query_media_entity]
  // [EndExclude query_compilation]

  /**
   * 模拟查询合集
   *
   * @returns 页面媒体实体
   */
  public async queryCompilation(): Promise<avMusicTemplate.PageMediaEntity | undefined> {
    let compilationId: string = 'compilationId';
    let pageIndex: number = 0;
    try {
      let pageMediaEntity: avMusicTemplate.PageMediaEntity | undefined =
        await this.controller?.queryCompilation(compilationId, pageIndex);
      if (pageMediaEntity?.errorCode != 0) {
        console.warn(TAG, 'queryCompilation fail')
        return undefined;
      }
      console.info(TAG, 'queryCompilation success')
      return pageMediaEntity;
    } catch (e) {
      console.error(TAG, `queryCompilation failed, errCode: ${e?.code}`)
      return undefined;
    }
  };
  // [StartExclude query_compilation]
  // [EndExclude query_play_list]

  /**
   * 模拟查询播放列表
   *
   * @returns 页面媒体实体
   */
  public async queryPlaylist(): Promise<avMusicTemplate.PageMediaEntity | undefined> {
    let pageIndex: number = 0;
    let sort: avMusicTemplate.Sort = avMusicTemplate.Sort.ORDER;
    try {
      let pageMediaEntity: avMusicTemplate.PageMediaEntity | undefined =
        await this.controller?.queryPlaylist(pageIndex, sort);
      if (pageMediaEntity?.errorCode != 0) {
        console.warn(TAG, 'queryPlaylist fail')
        return undefined;
      }
      console.info(TAG, 'queryPlaylist success')
      return pageMediaEntity;
    } catch (e) {
      console.error(TAG, `queryPlaylist failed, errCode: ${e?.code}`)
      return undefined;
    }
  };
  // [StartExclude query_play_list]
  // [EndExclude query_current_single]

  /**
   * 模拟查询当前单曲
   *
   * @returns 单曲
   */
  public async queryCurrentSingle(): Promise<avMusicTemplate.Single | undefined> {
    try {
      let single: avMusicTemplate.Single | undefined = await this.controller?.queryCurrentSingle();
      if (!single?.mediaId || single?.mediaId === '') {
        console.warn(TAG, 'queryCurrentSingle fail')
        return undefined;
      }
      console.info(TAG, 'queryCurrentSingle success')
      return single;
    } catch (e) {
      console.error(TAG, `queryCurrentSingle failed, errCode: ${e?.code}`)
      return undefined;
    }
  };
  // [StartExclude query_current_single]
  // [EndExclude query_compilation_by_keyword]

  /**
   * 模拟按关键字查询合集
   *
   * @returns 合集数组
   */
  public async queryCompilationByKeyword(): Promise<avMusicTemplate.Compilation[]> {
    let compilations: avMusicTemplate.Compilation[] = [];
    if (!this.controller) {
      console.error(TAG, 'queryCompilationByKeyword controller is undefined');
      return compilations;
    }
    let keyword: string = 'keyword';
    try {
      compilations = await this.controller.queryCompilationByKeyword(keyword);
      console.info(TAG, 'queryCompilationByKeyword success')
    } catch (e) {
      console.error(TAG, `queryCompilationByKeyword failed, errCode: ${e?.code}`)
    }
    return compilations;
  };
  // [StartExclude query_compilation_by_keyword]
  // [EndExclude query_media_entity_by_keyword]

  /**
   * 模拟按关键字查询媒体实体
   *
   * @returns 合集数组
   */
  public async queryMediaEntityByKeyword(): Promise<avMusicTemplate.PageMediaEntity | undefined> {
    let keyword: string = 'keyword';
    let searchType: avMusicTemplate.EntityType = avMusicTemplate.EntityType.SINGER;
    let pageIndex: number = 0;
    try {
      let pageMediaEntity: avMusicTemplate.PageMediaEntity | undefined =
        await this.controller?.queryMediaEntityByKeyword(keyword, searchType, pageIndex);
      if (pageMediaEntity?.errorCode != 0) {
        console.warn(TAG, 'queryMediaEntityByKeyword fail')
        return undefined;
      }
      console.info(TAG, 'queryMediaEntityByKeyword success')
      return pageMediaEntity;
    } catch (e) {
      console.error(TAG, `queryMediaEntityByKeyword failed, errCode: ${e?.code}`)
    }
    return undefined;
  };
  // [StartExclude query_media_entity_by_keyword]
  // [EndExclude query_recommend_media_entity_list]

  /**
   * 模拟查询推荐的媒体实体列表
   *
   * @returns 媒体实体数组
   */
  public async queryRecommendMediaEntityList(): Promise<avMusicTemplate.MediaEntity[]> {
    let mediaEntities: avMusicTemplate.MediaEntity[] = [];
    if (!this.controller) {
      console.error(TAG, 'queryRecommendMediaEntityList controller is undefined');
      return mediaEntities;
    }
    try {
      mediaEntities = await this.controller.queryRecommendMediaEntityList();
      console.info(TAG, 'queryRecommendMediaEntityList success')
    } catch (e) {
      console.error(TAG, `queryRecommendMediaEntityList failed, errCode: ${e?.code}`)
    }
    return mediaEntities;
  };
  // [StartExclude query_recommend_media_entity_list]
  // [EndExclude query_hot_words]

  /**
   * 模拟查询热词
   *
   * @returns 热词数组
   */
  public async queryHotWords(): Promise<string[]> {
    let hotWords: string[] = [];
    if (!this.controller) {
      console.error(TAG, 'queryHotWords controller is undefined');
      return hotWords;
    }
    try {
      hotWords = await this.controller.queryHotWords();
      console.info(TAG, 'queryHotWords success')
    } catch (e) {
      console.error(TAG, `queryHotWords failed, errCode: ${e?.code}`)
    }
    return hotWords;
  };
  // [StartExclude query_hot_words]
  // [EndExclude query_search_history]

  /**
   * 模拟查询搜索历史
   *
   * @returns 搜索历史数组
   */
  public async querySearchHistory(): Promise<string[]> {
    let searchHistory: string[] = [];
    if (!this.controller) {
      console.error(TAG, 'querySearchHistory controller is undefined');
      return searchHistory;
    }
    try {
      searchHistory = await this.controller.querySearchHistory();
      console.info(TAG, 'querySearchHistory success')
    } catch (e) {
      console.error(TAG, `querySearchHistory failed, errCode: ${e?.code}`)
    }
    return searchHistory;
  };
  // [StartExclude query_search_history]
  // [EndExclude query_member_purchase]

  /**
   * 模拟查询购买会员的情况
   *
   * @returns 会员购买信息列表
   */
  public async queryMemberPurchase(): Promise<avMusicTemplate.MemberPurchaseInfo[]> {
    let memberPurchaseInfo: avMusicTemplate.MemberPurchaseInfo[] = [];
    if (!this.controller) {
      console.error(TAG, 'queryMemberPurchase controller is undefined');
      return memberPurchaseInfo;
    }
    let memberPurchaseType: avMusicTemplate.MemberPurchaseType = avMusicTemplate.MemberPurchaseType.NORMAL;
    try {
      memberPurchaseInfo = await this.controller.queryMemberPurchase(memberPurchaseType);
      console.info(TAG, 'queryMemberPurchase success')
    } catch (e) {
      console.error(TAG, `queryMemberPurchase failed, errCode: ${e?.code}`)
    }
    return memberPurchaseInfo;
  };
  // [StartExclude query_member_purchase]
  // [EndExclude query_custom_content]

  /**
   * 模拟查询自定义内容
   *
   * @returns 自定义元素
   */
  public async queryCustomContent(): Promise<avMusicTemplate.CustomElement | undefined> {
    let queryType: avMusicTemplate.CustomType[] = ['USER_INFO', 'TAB', 'COMPILATION', 'SETTINGS'];
    try {
      let customElement: avMusicTemplate.CustomElement | undefined =
        await this.controller?.queryCustomContent(queryType);
      if (customElement?.errorCode != 0) {
        console.warn(TAG, 'queryCustomContent fail')
        return undefined;
      }
      console.info(TAG, 'queryCustomContent success')
      return customElement;
    } catch (e) {
      console.error(TAG, `queryCustomContent failed, errCode: ${e?.code}`)
      return undefined;
    }
  };
  // [EndExclude clear_search_history]
  // [StartExclude query_custom_content]

  /**
   * 模拟清除搜索历史
   *
   * @returns Promise类型的boolean，清除成功或者失败
   */
  public async clearSearchHistory(): Promise<boolean> {
    try {
      let operResult: avMusicTemplate.OperResult | undefined = await this.controller?.clearSearchHistory()
      if (operResult?.errorCode != 0) {
        console.warn(TAG, 'clearSearchHistory fail');
        return false;
      }
      console.info(TAG, 'clearSearchHistory success');
      return true;
    } catch (e) {
      console.error(TAG, `clearSearchHistory failed, errCode: ${e?.code}`);
      return false;
    }
  };
  // [StartExclude clear_search_history]
  // [EndExclude update_settings]

  /**
   * 模拟更新设置信息。
   *
   * @returns Promise类型更新后的设置项
   */
  public async updateSettings(): Promise<avMusicTemplate.SettingItem | undefined> {
    let settingItem: avMusicTemplate.SettingItem = {
      id: 'id',
      title: 'title',
      desc: 'desc',
      mediaId: 'mediaId'
    };
    try {
      let setting: avMusicTemplate.SettingItem | undefined = await this.controller?.updateSettings(settingItem);
      if (!setting?.id || setting?.id !== settingItem.id) {
        console.warn(TAG, 'updateSettings fail')
        return settingItem;
      }
      console.info(TAG, 'updateSettings success')
      return setting;
    } catch (e) {
      console.error(TAG, `updateSettings failed, errCode: ${e?.code}`)
      return settingItem;
    }
  };
  // [StartExclude update_settings]
  // [EndExclude report_problem_and_advice]

  /**
   * 模拟报告问题和建议。
   *
   * @returns Promise类型上报结果。true：成功。false：失败。
   */
  public async reportProblemAndAdvice(): Promise<boolean> {
    let advice: string = 'advice';
    try {
      let operResult: avMusicTemplate.OperResult | undefined = await this.controller?.reportProblemAndAdvice(advice);
      if (operResult?.errorCode != 0) {
        console.warn(TAG, 'reportProblemAndAdvice fail')
        return false;
      }
      console.info(TAG, 'reportProblemAndAdvice success')
      return true;
    } catch (e) {
      console.error(TAG, `reportProblemAndAdvice failed, errCode: ${e?.code}`)
      return false;
    }
  };
  // [StartExclude report_problem_and_advice]
  // [EndExclude login]

  /**
   * 模拟登录。
   *
   * @returns Promise类型的二维码信息数组。
   */
  public async login(): Promise<avMusicTemplate.QrCodeInfo[]> {
    let qrCodeInfos: avMusicTemplate.QrCodeInfo[] = [];
    if (!this.controller) {
      console.error(TAG, 'login controller is undefined');
      return qrCodeInfos;
    }
    let controlType: avMusicTemplate.LoginType = 'queryLoginInfo';
    // 可不传id。id为QrCodeInfo.id，用于LoginType为refreshLoginInfo场景。
    let id: string | undefined = undefined;
    try {
      qrCodeInfos = await this.controller.login(controlType, id);
      console.info(TAG, 'login callback success')
    } catch (e) {
      console.error(TAG, `login callback failed, errCode: ${e?.code}`)
    }
    return qrCodeInfos;
  };
  // [StartExclude login]
  // [EndExclude request_dialog_info]

  /**
   * 模拟请求弹框信息。
   *
   * @returns Promise类型的弹框信息。
   */
  public async requestDialogInfo(): Promise<avMusicTemplate.DialogInfo | undefined> {
    let actionType: avMusicTemplate.DialogActionType = 'open';
    // 可不传actionInfo。用于DialogActionType为refresh和close场景。
    let actionInfo: avMusicTemplate.DialogActionInfo = {
      dialogId: 'dialogId',
      isChecked: true,
      clickedBtnId: 'clickedBtnId'
    };
    try {
      let dialogInfo: avMusicTemplate.DialogInfo | undefined =
        await this.controller?.requestDialogInfo(actionType, actionInfo);
      if (!dialogInfo?.dialogId || dialogInfo?.dialogId === '') {
        console.info(TAG, 'requestDialogInfo fail')
        return undefined;
      }
      console.info(TAG, 'requestDialogInfo success')
      return dialogInfo;
    } catch (e) {
      console.error(TAG, `requestDialogInfo failed, errCode: ${e?.code}`)
    }
    return undefined;
  };
  // [StartExclude request_dialog_info]
  // [EndExclude handle_member_purchase]

  /**
   * 模拟请求弹框信息。
   *
   * @returns Promise类型的弹框信息。
   */
  public async handleMemberPurchase(): Promise<avMusicTemplate.DialogInfo | undefined> {
    let memberPurchaseInfo: avMusicTemplate.MemberPurchaseInfo = {
      id: 'id',
      diagramUrl: 'diagramUrl',
      diagramContent: 'diagramContent',
      memberPurchaseType: avMusicTemplate.MemberPurchaseType.NORMAL
    };
    try {
      let dialogInfo: avMusicTemplate.DialogInfo | undefined =
        await this.controller?.handleMemberPurchase(memberPurchaseInfo);
      if (!dialogInfo?.dialogId || dialogInfo?.dialogId === '') {
        console.info(TAG, 'handleMemberPurchase fail')
        return undefined;
      }
      console.info(TAG, 'handleMemberPurchase success')
      return dialogInfo;
    } catch (e) {
      console.error(TAG, `handleMemberPurchase failed, errCode: ${e?.code}`)
    }
    return undefined;
  };
  // [StartExclude handle_member_purchase]
  // [EndExclude download_media_entity]

  /**
   * 模拟下载媒体实体。
   *
   * @returns Promise类型操作结果。
   */
  public async downloadMediaEntity(): Promise<boolean> {
    let controlType: avMusicTemplate.DownloadControlType = 'startDownload';
    let mediaEntity: avMusicTemplate.MediaEntity = {
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    };
    try {
      let operResult: avMusicTemplate.OperResult | undefined =
        await this.controller?.downloadMediaEntity(controlType, mediaEntity);
      if (operResult?.errorCode != 0) {
        console.warn(TAG, 'start downloadMediaEntity fail')
        return false;
      }
      console.info(TAG, 'start downloadMediaEntity success')
      return true;
    } catch (e) {
      console.error(TAG, `start downloadMediaEntity failed, errCode: ${e?.code}`)
      return false;
    }
  };
  // [EndExclude play_for_search]
  // [StartExclude download_media_entity]

  /**
   * 模拟搜播。
   *
   * @returns Promise类型操作结果。
   */
  public async playForSearch(): Promise<boolean> {
    let command: avMusicTemplate.SearchPlayInfoType = avMusicTemplate.SearchPlayInfoType.PLAY_MUSIC;
    let searchPlayMusicItems: avMusicTemplate.SearchPlayMusicItem[] = [{
      entityId: 'entityId',
      entityName: 'entityName'
    }];
    let searchPlayMusicInfo: avMusicTemplate.SearchPlayMusicInfo = {
      items: searchPlayMusicItems,
      displayName: 'displayName',
      description: 'description'
    };
    let searchPlayInfo: avMusicTemplate.SearchPlayInfo = {
      musicInfo: searchPlayMusicInfo
    };
    try {
      let operResult: avMusicTemplate.OperResult | undefined =
        await this.controller?.playForSearch(command, searchPlayInfo);
      if (operResult?.errorCode != 0) {
        console.warn(TAG, 'playForSearch fail')
        return false;
      }
      console.info(TAG, 'playForSearch success')
      return true;
    } catch (e) {
      console.error(TAG, `playForSearch failed, errCode: ${e?.code}`)
      return false;
    }
  };
  // [StartExclude play_for_search]
  // [EndExclude execute_action]

  /**
   * 模拟执行动作。
   *
   * @returns Promise<string>类型操作结果。
   */
  public async executeAction(): Promise<string> {
    let actionType: string = 'actionType';
    let params: string = 'params';
    try {
      let result: string | undefined = await this.controller?.executeAction(actionType, params);
      if (!result || result === '') {
        console.warn(TAG, 'executeAction fail')
        return '';
      }
      console.info(TAG, 'executeAction success')
      return result;
    } catch (e) {
      console.error(TAG, `executeAction failed, errCode: ${e?.code}`)
      return '';
    }
  };
  // [StartExclude execute_action]
  // [EndExclude play_media_entity]

  /**
   * 模拟播放媒体。
   */
  public async playMediaEntity() {
    let mediaEntity: avMusicTemplate.MediaEntity = {
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    };
    this.controller?.playMediaEntity(mediaEntity);
  };
  // [StartExclude play_media_entity]
  // [EndExclude favorite_media_entity]

  /**
   * 模拟收藏媒体。
   *
   * @returns Promise类型操作结果。
   */
  public async favoriteMediaEntity(): Promise<boolean> {
    let actionType: avMusicTemplate.MediaFavoriteType = 'addFavorite';
    let mediaEntity: avMusicTemplate.MediaEntity = {
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    };
    try {
      let operResult: avMusicTemplate.OperResult | undefined =
        await this.controller?.favoriteMediaEntity(actionType, mediaEntity);
      if (operResult?.errorCode != 0) {
        console.warn(TAG, 'favoriteMediaEntity fail')
        return false;
      }
      console.info(TAG, 'favoriteMediaEntity success')
      return true;
    } catch (e) {
      console.error(TAG, `favoriteMediaEntity failed, errCode: ${e?.code}`)
      return false;
    }
  };
  // [EndExclude create_controller]
  // [EndExclude query_home_content]
  // [EndExclude play_for_search]
  // [EndExclude register_user_info_change]
  // [EndExclude release]
  // [EndExclude get_all_descriptors]
  // [EndExclude register_template_create]
  // [EndExclude unregister_template_create]
  // [EndExclude register_template_destroy]
  // [EndExclude unregister_template_destroy]
  // [EndExclude query_main_tabs]
  // [EndExclude query_media_tab_content]
  // [EndExclude query_media_entity]
  // [EndExclude query_compilation]
  // [EndExclude query_play_list]
  // [EndExclude query_current_single]
  // [EndExclude query_compilation_by_keyword]
  // [EndExclude query_media_entity_by_keyword]
  // [EndExclude query_recommend_media_entity_list]
  // [EndExclude query_hot_words]
  // [EndExclude query_search_history]
  // [EndExclude clear_search_history]
  // [EndExclude update_settings]
  // [EndExclude report_problem_and_advice]
  // [EndExclude login]
  // [EndExclude request_dialog_info]
  // [EndExclude handle_member_purchase]
  // [EndExclude query_member_purchase]
  // [EndExclude query_custom_content]
  // [EndExclude download_media_entity]
  // [EndExclude execute_action]
  // [EndExclude play_media_entity]
  // [EndExclude unregister_user_info_change]
  // [EndExclude register_dialog_command_change]
  // [EndExclude unregister_dialog_command_change]
  // [EndExclude register_current_single_change]
  // [EndExclude unregister_current_single_change]
  // [EndExclude register_media_entities_change]
  // [EndExclude unregister_media_entities_change]
  // [EndExclude register_tab_content_change]
  // [EndExclude unregister_tab_content_change]
  // [EndExclude register_play_list_change]
  // [EndExclude unregister_play_list_change]
  // [EndExclude register_download_media_entity_status_change]
  // [EndExclude unregister_download_media_entity_status_change]
  // [EndExclude register_custom_elements_change]
  // [EndExclude unregister_custom_elements_change]
  // [EndExclude register_settings_change]
  // [EndExclude unregister_settings_change]
  // [EndExclude register_report_execute_action]
  // [EndExclude unregister_report_execute_action]
  // [EndExclude register_extension_ability_change]
  // [EndExclude unregister_extension_ability_change]
  // [EndExclude destroy]
}
// [End create_controller]
// [End query_home_content]
// [End play_for_search]
// [End register_user_info_change]
// [End release]
// [End get_all_descriptors]
// [End register_template_create]
// [End unregister_template_create]
// [End register_template_destroy]
// [End unregister_template_destroy]
// [End query_main_tabs]
// [End query_media_tab_content]
// [End query_media_entity]
// [End query_compilation]
// [End query_play_list]
// [End query_current_single]
// [End query_compilation_by_keyword]
// [End query_media_entity_by_keyword]
// [End query_recommend_media_entity_list]
// [End query_hot_words]
// [End query_search_history]
// [End clear_search_history]
// [End update_settings]
// [End report_problem_and_advice]
// [End login]
// [End request_dialog_info]
// [End handle_member_purchase]
// [End query_member_purchase]
// [End query_custom_content]
// [End download_media_entity]
// [End execute_action]
// [End play_media_entity]
// [End favorite_media_entity]
// [End unregister_user_info_change]
// [End register_dialog_command_change]
// [End unregister_dialog_command_change]
// [End register_current_single_change]
// [End unregister_current_single_change]
// [End register_media_entities_change]
// [End unregister_media_entities_change]
// [End register_tab_content_change]
// [End unregister_tab_content_change]
// [End register_play_list_change]
// [End unregister_play_list_change]
// [End register_download_media_entity_status_change]
// [End unregister_download_media_entity_status_change]
// [End register_custom_elements_change]
// [End unregister_custom_elements_change]
// [End register_settings_change]
// [End unregister_settings_change]
// [End register_report_execute_action]
// [End unregister_report_execute_action]
// [End register_extension_ability_change]
// [End unregister_extension_ability_change]
// [End destroy]