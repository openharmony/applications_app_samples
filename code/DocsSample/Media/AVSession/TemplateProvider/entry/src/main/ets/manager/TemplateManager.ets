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

// [Start manager_create_template]
// [Start template_register_listener]
// [Start set_user_info]
// [Start unregister_listener]
// [Start start_template]
// [Start register_query_main_tabs]
// [Start register_query_media_tab_content]
// [Start register_query_media_entity]
// [Start register_query_compilation]
// [Start register_query_play_list]
// [Start register_query_current_single]
// [Start register_query_compilation_by_keyword]
// [Start register_query_media_entity_by_keyword]
// [Start register_query_recommend_media_entity_list]
// [Start register_query_hot_words]
// [Start register_query_search_history]
// [Start register_clear_search_history]
// [Start register_on_login]
// [Start register_request_dialog_info]
// [Start register_handle_member_purchase]
// [Start register_query_member_purchase]
// [Start register_query_custom_content]
// [Start register_download_media_entity]
// [Start register_settings_change]
// [Start register_problem_and_advice]
// [Start register_play_for_search]
// [Start register_execute_action]
// [Start register_play_media_entity]
// [Start register_favorite_media_entity]
// [Start set_dialog_command]
// [Start set_current_single]
// [Start set_media_entities]
// [Start set_tab_content]
// [Start set_play_list]
// [Start set_custom_elements]
// [Start set_settings]
// [Start report_execute_action]
// [Start set_extension_ability]
// [Start destroy]
import avMusicTemplate from '@ohos.multimedia.avMusicTemplate';
// [StartExclude manager_create_template]
// [StartExclude template_register_listener]
// [StartExclude set_user_info]
// [StartExclude unregister_listener]
// [StartExclude start_template]
// [StartExclude register_query_main_tabs]
// [StartExclude register_query_media_tab_content]
// [StartExclude register_query_media_entity]
// [StartExclude register_query_compilation]
// [StartExclude register_query_play_list]
// [StartExclude register_query_current_single]
// [StartExclude register_query_compilation_by_keyword]
// [StartExclude register_query_media_entity_by_keyword]
// [StartExclude register_query_recommend_media_entity_list]
// [StartExclude register_query_hot_words]
// [StartExclude register_query_search_history]
// [StartExclude register_clear_search_history]
// [StartExclude register_on_login]
// [StartExclude register_request_dialog_info]
// [StartExclude register_handle_member_purchase]
// [StartExclude register_query_member_purchase]
// [StartExclude register_query_custom_content]
// [StartExclude register_download_media_entity]
// [StartExclude register_settings_change]
// [StartExclude register_problem_and_advice]
// [StartExclude register_play_for_search]
// [StartExclude register_execute_action]
// [StartExclude register_play_media_entity]
// [StartExclude register_favorite_media_entity]
// [StartExclude set_dialog_command]
// [StartExclude set_current_single]
// [StartExclude set_media_entities]
// [StartExclude set_tab_content]
// [StartExclude set_play_list]
// [StartExclude set_custom_elements]
// [StartExclude set_settings]
// [StartExclude report_execute_action]
// [StartExclude destroy]
import { wantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [EndExclude manager_create_template]
// [EndExclude template_register_listener]
// [EndExclude set_user_info]
// [EndExclude unregister_listener]
// [EndExclude start_template]
// [EndExclude register_query_main_tabs]
// [EndExclude register_query_media_tab_content]
// [EndExclude register_query_media_entity]
// [EndExclude register_query_compilation]
// [EndExclude register_query_play_list]
// [EndExclude register_query_current_single]
// [EndExclude register_query_compilation_by_keyword]
// [EndExclude register_query_media_entity_by_keyword]
// [EndExclude register_query_recommend_media_entity_list]
// [EndExclude register_query_hot_words]
// [EndExclude register_query_search_history]
// [EndExclude register_clear_search_history]
// [EndExclude register_on_login]
// [EndExclude register_request_dialog_info]
// [EndExclude register_handle_member_purchase]
// [EndExclude register_query_member_purchase]
// [EndExclude register_query_custom_content]
// [EndExclude register_download_media_entity]
// [EndExclude register_settings_change]
// [EndExclude register_problem_and_advice]
// [EndExclude register_play_for_search]
// [EndExclude register_execute_action]
// [EndExclude register_play_media_entity]
// [EndExclude register_favorite_media_entity]
// [EndExclude set_dialog_command]
// [EndExclude set_current_single]
// [EndExclude set_media_entities]
// [EndExclude set_tab_content]
// [EndExclude set_play_list]
// [EndExclude set_custom_elements]
// [EndExclude set_settings]
// [EndExclude report_execute_action]
// [EndExclude destroy]

export class TemplateManager {
  private template: avMusicTemplate.AVMusicTemplate | undefined = undefined;
  // [StartExclude template_register_listener]
  // [StartExclude set_user_info]
  // [StartExclude unregister_listener]
  // [StartExclude start_template]
  // [StartExclude register_query_main_tabs]
  // [StartExclude register_query_media_tab_content]
  // [StartExclude register_query_media_entity]
  // [StartExclude register_query_compilation]
  // [StartExclude register_query_play_list]
  // [StartExclude register_query_current_single]
  // [StartExclude register_query_compilation_by_keyword]
  // [StartExclude register_query_media_entity_by_keyword]
  // [StartExclude register_query_recommend_media_entity_list]
  // [StartExclude register_query_hot_words]
  // [StartExclude register_query_search_history]
  // [StartExclude register_clear_search_history]
  // [StartExclude register_on_login]
  // [StartExclude register_request_dialog_info]
  // [StartExclude register_handle_member_purchase]
  // [StartExclude register_query_member_purchase]
  // [StartExclude register_query_custom_content]
  // [StartExclude register_download_media_entity]
  // [StartExclude register_settings_change]
  // [StartExclude register_problem_and_advice]
  // [StartExclude register_play_for_search]
  // [StartExclude register_execute_action]
  // [StartExclude register_play_media_entity]
  // [StartExclude register_favorite_media_entity]
  // [StartExclude set_dialog_command]
  // [StartExclude set_current_single]
  // [StartExclude set_media_entities]
  // [StartExclude set_tab_content]
  // [StartExclude set_play_list]
  // [StartExclude set_custom_elements]
  // [StartExclude set_settings]
  // [StartExclude report_execute_action]
  // [StartExclude set_extension_ability]
  // [StartExclude destroy]
  private static sInstance: TemplateManager;
  // [EndExclude set_user_info]
  // [StartExclude manager_create_template]
  private isLogin: boolean = false;
  // [EndExclude template_register_listener]
  // [EndExclude register_query_main_tabs]
  // [StartExclude set_user_info]
  private queryMainTabsEvent: avMusicTemplate.QueryMainTabsEvent = async () => {
    return new Promise<avMusicTemplate.MediaTab[]>(async (resolve, reject) => {
      try {
        let tabs: avMusicTemplate.MediaTab[] = await this.getMainTabs();
        resolve(tabs);
      } catch (e) {
        console.error(`queryMainTabsEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_query_main_tabs]
  // [EndExclude register_query_media_tab_content]
  private queryMediaTabContentEvent: avMusicTemplate.QueryMediaTabContentEvent = async (tabId: string) => {
    return new Promise<avMusicTemplate.MediaTabContent>(async (resolve, reject) => {
      try {
        let tabContent: avMusicTemplate.MediaTabContent = await this.createMediaTabContent();
        resolve(tabContent);
      } catch (e) {
        console.error(`queryMediaTabContentEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude template_register_listener]
  // [StartExclude register_query_media_tab_content]
  // [EndExclude register_query_media_entity]
  private queryMediaEntityEvent: avMusicTemplate.QueryMediaEntityEvent =
    async (params: avMusicTemplate.QueryMediaEntityParam) => {
      return new Promise<avMusicTemplate.PageMediaEntity>(async (resolve, reject) => {
        try {
          let pageMediaEntity: avMusicTemplate.PageMediaEntity = await this.createPageMediaEntity();
          resolve(pageMediaEntity);
        } catch (e) {
          console.error(`queryMediaEntityEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_query_media_entity]
  // [EndExclude register_query_compilation]
  private queryCompilationEvent: avMusicTemplate.QueryCompilationEvent =
    async (compilationId: string, pageIndex: number) => {
      return new Promise<avMusicTemplate.PageMediaEntity>(async (resolve, reject) => {
        try {
          let pageMediaEntity: avMusicTemplate.PageMediaEntity = await this.createPageMediaEntity();
          resolve(pageMediaEntity);
        } catch (e) {
          console.error(`queryCompilationEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_query_compilation]
  // [EndExclude register_query_play_list]
  private queryPlaylistEvent: avMusicTemplate.QueryPlaylistEvent =
    async (pageIndex: number, sort: avMusicTemplate.Sort) => {
      return new Promise<avMusicTemplate.PageMediaEntity>(async (resolve, reject) => {
        try {
          let pageMediaEntity: avMusicTemplate.PageMediaEntity = await this.createPageMediaEntity();
          resolve(pageMediaEntity);
        } catch (e) {
          console.error(`queryPlaylistEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_query_play_list]
  // [EndExclude register_query_current_single]
  private queryCurrentSingleEvent: avMusicTemplate.QueryCurrentSingleEvent = async () => {
    return new Promise<avMusicTemplate.Single>(async (resolve, reject) => {
      try {
        let single: avMusicTemplate.Single = await this.createCurrentSingle();
        resolve(single);
      } catch (e) {
        console.error(`queryCurrentSingleEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_query_current_single]
  // [EndExclude register_query_compilation_by_keyword]
  private queryCompilationByKeywordEvent: avMusicTemplate.QueryCompilationByKeywordEvent = async (keyword: string) => {
    return new Promise<avMusicTemplate.Compilation[]>(async (resolve, reject) => {
      try {
        let compilation: avMusicTemplate.Compilation = await this.createCompilation();
        let compilations: avMusicTemplate.Compilation[] = [compilation];
        resolve(compilations);
      } catch (e) {
        console.error(`queryCompilationByKeywordEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_query_compilation_by_keyword]
  // [EndExclude register_query_media_entity_by_keyword]
  private queryMediaEntityByKeywordEvent: avMusicTemplate.QueryMediaEntityByKeywordEvent =
    async (keyword: string, searchType: avMusicTemplate.EntityType, pageIndex: number) => {
      return new Promise<avMusicTemplate.PageMediaEntity>(async (resolve, reject) => {
        try {
          let pageMediaEntity: avMusicTemplate.PageMediaEntity = await this.createPageMediaEntity();
          resolve(pageMediaEntity);
        } catch (e) {
          console.error(`queryMediaEntityByKeywordEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_query_media_entity_by_keyword]
  // [EndExclude register_query_recommend_media_entity_list]
  private queryRecommendMediaEntityListEvent: avMusicTemplate.QueryRecommendMediaEntityListEvent = async () => {
    return new Promise<avMusicTemplate.MediaEntity[]>(async (resolve, reject) => {
      try {
        let mediaEntity: avMusicTemplate.MediaEntity = await this.createMediaEntity();
        let mediaEntities: avMusicTemplate.MediaEntity[] = [mediaEntity];
        resolve(mediaEntities);
      } catch (e) {
        console.error(`queryRecommendMediaEntityListEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_query_recommend_media_entity_list]
  // [EndExclude register_query_hot_words]
  private queryHotWordsEvent: avMusicTemplate.QueryHotWordsEvent = async () => {
    return new Promise<string[]>(async (resolve, reject) => {
      try {
        let hotWords: string[] = ['热词1', '热词2', '热词3', '热词4', '热词5'];
        resolve(hotWords);
      } catch (e) {
        console.error(`queryHotWordsEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_query_hot_words]
  // [EndExclude register_query_search_history]
  private querySearchHistoryEvent: avMusicTemplate.QuerySearchHistoryEvent = async () => {
    return new Promise<string[]>(async (resolve, reject) => {
      try {
        let searchHistory: string[] = ['搜索历史1', '搜索历史2', '搜索历史3', '搜索历史4', '搜索历史5'];
        resolve(searchHistory);
      } catch (e) {
        console.error(`querySearchHistoryEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_query_search_history]
  // [EndExclude register_clear_search_history]
  private clearSearchHistoryEvent: avMusicTemplate.ClearSearchHistoryEvent = async () => {
    return new Promise<avMusicTemplate.OperResult>(async (resolve, reject) => {
      try {
        let operResult: avMusicTemplate.OperResult = await this.createOperResult();
        resolve(operResult);
      } catch (e) {
        console.error(`clearSearchHistoryEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_clear_search_history]
  // [EndExclude register_on_login]
  private loginEvent: avMusicTemplate.LoginEvent = async (controlType: avMusicTemplate.LoginType, id?: string) => {
    return new Promise<avMusicTemplate.QrCodeInfo[]>(async (resolve, reject) => {
      try {
        let qrCodeInfo: avMusicTemplate.QrCodeInfo = await this.createQrCodeInfo();
        let qrCodeInfos: avMusicTemplate.QrCodeInfo[] = [qrCodeInfo];
        resolve(qrCodeInfos);
      } catch (e) {
        console.error(`loginEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_on_login]
  // [EndExclude register_request_dialog_info]
  private requestDialogInfoEvent: avMusicTemplate.RequestDialogInfoEvent =
    async (actionType: avMusicTemplate.DialogActionType, actionInfo?: avMusicTemplate.DialogActionInfo) => {
      return new Promise<avMusicTemplate.DialogInfo>(async (resolve, reject) => {
        try {
          let dialogInfo: avMusicTemplate.DialogInfo = await this.createDialogInfo();
          resolve(dialogInfo);
        } catch (e) {
          console.error(`requestDialogInfoEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_request_dialog_info]
  // [EndExclude register_handle_member_purchase]
  private handleMemberPurchaseEvent: avMusicTemplate.HandleMemberPurchaseEvent =
    async (info: avMusicTemplate.MemberPurchaseInfo) => {
      return new Promise<avMusicTemplate.DialogInfo>(async (resolve, reject) => {
        try {
          let dialogInfo: avMusicTemplate.DialogInfo = await this.createDialogInfo();
          resolve(dialogInfo);
        } catch (e) {
          console.error(`handleMemberPurchaseEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_handle_member_purchase]
  // [EndExclude register_query_member_purchase]
  private queryMemberPurchaseEvent: avMusicTemplate.QueryMemberPurchaseEvent =
    async (memberPurchaseType: avMusicTemplate.MemberPurchaseType) => {
      return new Promise<avMusicTemplate.MemberPurchaseInfo[]>(async (resolve, reject) => {
        try {
          let memberPurchaseInfo: avMusicTemplate.MemberPurchaseInfo = await this.createQueryMemberPurchase();
          let memberPurchaseInfos: avMusicTemplate.MemberPurchaseInfo[] = [memberPurchaseInfo];
          resolve(memberPurchaseInfos);
        } catch (e) {
          console.error(`queryMemberPurchaseEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_query_member_purchase]
  // [EndExclude register_query_custom_content]
  private queryCustomContentEvent: avMusicTemplate.QueryCustomContentEvent =
    async (queryTypes: avMusicTemplate.CustomType[]) => {
      return new Promise<avMusicTemplate.CustomElement>(async (resolve, reject) => {
        try {
          let customElement: avMusicTemplate.CustomElement = await this.createCustomContent();
          resolve(customElement);
        } catch (e) {
          console.error(`queryCustomContentEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_query_custom_content]
  // [EndExclude register_download_media_entity]
  private downloadMediaEntityEvent: avMusicTemplate.DownloadMediaEntityEvent =
    async (controlType: avMusicTemplate.DownloadControlType, mediaEntity: avMusicTemplate.MediaEntity) => {
      return new Promise<avMusicTemplate.OperResult>(async (resolve, reject) => {
        try {
          let operResult: avMusicTemplate.OperResult = await this.createOperResult();
          this.downloadMediaEntity(mediaEntity);
          resolve(operResult);
        } catch (e) {
          console.error(`downloadMediaEntityEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_download_media_entity]
  // [EndExclude register_settings_change]
  private settingsChangeEvent: avMusicTemplate.SettingsChangeEvent =
    async (settingItem: avMusicTemplate.SettingItem) => {
      return new Promise<avMusicTemplate.SettingItem>(async (resolve, reject) => {
        try {
          let settingItem: avMusicTemplate.SettingItem = await this.settingsChange();
          resolve(settingItem);
        } catch (e) {
          console.error(`settingsChangeEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_settings_change]
  // [EndExclude register_problem_and_advice]
  private problemAndAdviceEvent: avMusicTemplate.ProblemAndAdviceEvent = async (advice: string) => {
    return new Promise<avMusicTemplate.OperResult>(async (resolve, reject) => {
      try {
        let operResult: avMusicTemplate.OperResult = await this.createOperResult();
        resolve(operResult);
      } catch (e) {
        console.error(`problemAndAdviceEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_problem_and_advice]
  // [EndExclude register_play_for_search]
  private playForSearchEvent: avMusicTemplate.PlayForSearchEvent = async (command: avMusicTemplate.SearchPlayInfoType,
    args: avMusicTemplate.SearchPlayInfo) => {
    return new Promise<avMusicTemplate.OperResult>(async (resolve, reject) => {
      try {
        let operResult: avMusicTemplate.OperResult = await this.createOperResult();
        resolve(operResult);
      } catch (e) {
        console.error(`playForSearchEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_play_for_search]
  // [EndExclude register_execute_action]
  private executeActionEvent: avMusicTemplate.ExecuteActionEvent = async (actionType: string, params: string) => {
    return new Promise<string>(async (resolve, reject) => {
      try {
        let result: string = 'success';
        resolve(result);
      } catch (e) {
        console.error(`executeActionEvent fail, errCode: ${e?.code}`);
        reject(e);
      }
    });
  };
  // [StartExclude register_execute_action]
  // [EndExclude register_play_media_entity]
  private playMediaEntityEvent: avMusicTemplate.PlayMediaEntityEvent =
    async (mediaEntity: avMusicTemplate.MediaEntity) => {
      console.info('playMediaEntity');
    };
  // [StartExclude register_play_media_entity]
  // [EndExclude register_favorite_media_entity]
  private favoriteMediaEntityEvent: avMusicTemplate.FavoriteMediaEntityEvent =
    async (actionType: avMusicTemplate.MediaFavoriteType, mediaEntity: avMusicTemplate.MediaEntity) => {
      return new Promise<avMusicTemplate.OperResult>(async (resolve, reject) => {
        try {
          let operResult: avMusicTemplate.OperResult = await this.createOperResult();
          resolve(operResult);
        } catch (e) {
          console.error(`favoriteMediaEntityEvent fail, errCode: ${e?.code}`);
          reject(e);
        }
      });
    };
  // [StartExclude register_favorite_media_entity]

  // [EndExclude manager_create_template]
  private constructor() {
  }

  /**
   * 获取模板控制器实例
   *
   * @returns 模板控制器实例
   */
  public static getInstance(): TemplateManager {
    if (!TemplateManager.sInstance) {
      TemplateManager.sInstance = new TemplateManager();
    }
    return TemplateManager.sInstance;
  };

  /**
   * 创建音频模板
   */
  public createTemplate() {
    if (this.template) {
      console.warn('createTemplate: template not undefined');
      return
    }
    try {
      this.template = avMusicTemplate.createAVMusicTemplate(avMusicTemplate.AVMusicTemplateType.DEFAULT);
      console.info('createTemplate: success');
      // [StartExclude manager_create_template]
      this.registerListener();
      // [EndExclude manager_create_template]
    } catch (e) {
      console.error(`createTemplate, errCode: ${e?.code}`);
    }
  }
  // [StartExclude manager_create_template]
  // [EndExclude register_query_main_tabs]
  // [EndExclude register_query_media_tab_content]
  // [EndExclude template_register_listener]
  // [EndExclude register_query_media_entity]
  // [EndExclude register_query_compilation]
  // [EndExclude register_query_play_list]
  // [EndExclude register_query_current_single]
  // [EndExclude register_query_compilation_by_keyword]
  // [EndExclude register_query_media_entity_by_keyword]
  // [EndExclude register_query_recommend_media_entity_list]
  // [EndExclude register_query_hot_words]
  // [EndExclude register_query_search_history]
  // [EndExclude register_clear_search_history]
  // [EndExclude register_on_login]
  // [EndExclude register_request_dialog_info]
  // [EndExclude register_handle_member_purchase]
  // [EndExclude register_query_member_purchase]
  // [EndExclude register_query_custom_content]
  // [EndExclude register_download_media_entity]
  // [EndExclude register_settings_change]
  // [EndExclude register_problem_and_advice]
  // [EndExclude register_play_for_search]
  // [EndExclude register_execute_action]
  // [EndExclude register_play_media_entity]
  // [EndExclude register_favorite_media_entity]

  /**
   * 注册监听。
   */
  private registerListener() {
    // [StartExclude register_query_media_tab_content]
    // [StartExclude register_query_media_entity]
    // [StartExclude register_query_compilation]
    // [StartExclude register_query_play_list]
    // [StartExclude register_query_current_single]
    // [StartExclude register_query_compilation_by_keyword]
    // [StartExclude register_query_media_entity_by_keyword]
    // [StartExclude register_query_recommend_media_entity_list]
    // [StartExclude register_query_hot_words]
    // [StartExclude register_query_search_history]
    // [StartExclude register_clear_search_history]
    // [StartExclude register_on_login]
    // [StartExclude register_request_dialog_info]
    // [StartExclude register_handle_member_purchase]
    // [StartExclude register_query_member_purchase]
    // [StartExclude register_query_custom_content]
    // [StartExclude register_download_media_entity]
    // [StartExclude register_settings_change]
    // [StartExclude register_problem_and_advice]
    // [StartExclude register_play_for_search]
    // [StartExclude register_execute_action]
    // [StartExclude register_play_media_entity]
    // [StartExclude register_favorite_media_entity]
    this.template?.onQueryMainTabs(this.queryMainTabsEvent);
    // [StartExclude register_query_main_tabs]
    // [EndExclude register_query_media_tab_content]
    this.template?.onQueryMediaTabContent(this.queryMediaTabContentEvent);
    // [StartExclude template_register_listener]
    // [StartExclude register_query_media_tab_content]
    // [EndExclude register_query_media_entity]
    this.template?.onQueryMediaEntity(this.queryMediaEntityEvent);
    // [StartExclude register_query_media_entity]
    // [EndExclude register_query_compilation]
    this.template?.onQueryCompilation(this.queryCompilationEvent);
    // [StartExclude register_query_compilation]
    // [EndExclude register_query_play_list]
    this.template?.onQueryPlaylist(this.queryPlaylistEvent);
    // [StartExclude register_query_play_list]
    // [EndExclude register_query_current_single]
    this.template?.onQueryCurrentSingle(this.queryCurrentSingleEvent);
    // [StartExclude register_query_current_single]
    // [EndExclude register_query_compilation_by_keyword]
    this.template?.onQueryCompilationByKeyword(this.queryCompilationByKeywordEvent);
    // [StartExclude register_query_compilation_by_keyword]
    // [EndExclude register_query_media_entity_by_keyword]
    this.template?.onQueryMediaEntityByKeyword(this.queryMediaEntityByKeywordEvent);
    // [StartExclude register_query_media_entity_by_keyword]
    // [EndExclude register_query_recommend_media_entity_list]
    this.template?.onQueryRecommendMediaEntityList(this.queryRecommendMediaEntityListEvent);
    // [StartExclude register_query_recommend_media_entity_list]
    // [EndExclude register_query_hot_words]
    this.template?.onQueryHotWords(this.queryHotWordsEvent);
    // [StartExclude register_query_hot_words]
    // [EndExclude register_query_search_history]
    this.template?.onQuerySearchHistory(this.querySearchHistoryEvent);
    // [StartExclude register_query_search_history]
    // [EndExclude register_clear_search_history]
    this.template?.onClearSearchHistory(this.clearSearchHistoryEvent);
    // [StartExclude register_clear_search_history]
    // [EndExclude register_on_login]
    this.template?.onLogin(this.loginEvent);
    // [StartExclude register_on_login]
    // [EndExclude register_request_dialog_info]
    this.template?.onRequestDialogInfo(this.requestDialogInfoEvent);
    // [StartExclude register_request_dialog_info]
    // [EndExclude register_handle_member_purchase]
    this.template?.onHandleMemberPurchase(this.handleMemberPurchaseEvent);
    // [StartExclude register_handle_member_purchase]
    // [EndExclude register_query_member_purchase]
    this.template?.onQueryMemberPurchase(this.queryMemberPurchaseEvent);
    // [StartExclude register_query_member_purchase]
    // [EndExclude register_query_custom_content]
    this.template?.onQueryCustomContent(this.queryCustomContentEvent);
    // [StartExclude register_query_custom_content]
    // [EndExclude register_download_media_entity]
    this.template?.onDownloadMediaEntity(this.downloadMediaEntityEvent);
    // [StartExclude register_download_media_entity]
    // [EndExclude register_settings_change]
    this.template?.onSettingsChange(this.settingsChangeEvent);
    // [StartExclude register_settings_change]
    // [EndExclude register_problem_and_advice]
    this.template?.onProblemAndAdvice(this.problemAndAdviceEvent);
    // [StartExclude register_problem_and_advice]
    // [EndExclude register_play_for_search]
    this.template?.onPlayForSearch(this.playForSearchEvent);
    // [StartExclude register_play_for_search]
    // [EndExclude register_execute_action]
    this.template?.onExecuteAction(this.executeActionEvent);
    // [StartExclude register_execute_action]
    // [EndExclude register_play_media_entity]
    this.template?.onPlayMediaEntity(this.playMediaEntityEvent);
    // [StartExclude register_play_media_entity]
    // [EndExclude register_favorite_media_entity]
    this.template?.onFavoriteMediaEntity(this.favoriteMediaEntityEvent);
    // [EndExclude template_register_listener]
    // [EndExclude register_query_main_tabs]
    // [EndExclude register_query_media_tab_content]
    // [EndExclude register_query_media_entity]
    // [EndExclude register_query_compilation]
    // [EndExclude register_query_play_list]
    // [EndExclude register_query_current_single]
    // [EndExclude register_query_compilation_by_keyword]
    // [EndExclude register_query_media_entity_by_keyword]
    // [EndExclude register_query_recommend_media_entity_list]
    // [EndExclude register_query_hot_words]
    // [EndExclude register_query_search_history]
    // [EndExclude register_clear_search_history]
    // [EndExclude register_on_login]
    // [EndExclude register_request_dialog_info]
    // [EndExclude register_handle_member_purchase]
    // [EndExclude register_query_member_purchase]
    // [EndExclude register_query_custom_content]
    // [EndExclude register_download_media_entity]
    // [EndExclude register_settings_change]
    // [EndExclude register_problem_and_advice]
    // [EndExclude register_play_for_search]
    // [EndExclude register_execute_action]
    // [EndExclude register_play_media_entity]
  };
  // [EndExclude destroy]

  // [StartExclude template_register_listener]
  // [EndExclude unregister_listener]
  /**
   * 注销监听。
   */
  public unregisterListener() {
    // [StartExclude register_query_media_tab_content]
    // [StartExclude register_query_media_entity]
    // [StartExclude register_query_compilation]
    // [StartExclude register_query_play_list]
    // [StartExclude register_query_current_single]
    // [StartExclude register_query_compilation_by_keyword]
    // [StartExclude register_query_media_entity_by_keyword]
    // [StartExclude register_query_recommend_media_entity_list]
    // [StartExclude register_query_hot_words]
    // [StartExclude register_query_search_history]
    // [StartExclude register_clear_search_history]
    // [StartExclude register_on_login]
    // [StartExclude register_request_dialog_info]
    // [StartExclude register_handle_member_purchase]
    // [StartExclude register_query_member_purchase]
    // [StartExclude register_query_custom_content]
    // [StartExclude register_download_media_entity]
    // [StartExclude register_settings_change]
    // [StartExclude register_problem_and_advice]
    // [StartExclude register_play_for_search]
    // [StartExclude register_execute_action]
    // [StartExclude register_play_media_entity]
    // [StartExclude register_favorite_media_entity]
    // [StartExclude destroy]
    this.template?.offQueryMainTabs();
    // [EndExclude register_query_media_tab_content]
    // [StartExclude register_query_main_tabs]
    this.template?.offQueryMediaTabContent();
    // [StartExclude register_query_media_tab_content]
    // [EndExclude register_query_media_entity]
    this.template?.offQueryMediaEntity();
    // [StartExclude register_query_media_entity]
    // [EndExclude register_query_compilation]
    this.template?.offQueryCompilation();
    // [StartExclude register_query_compilation]
    // [EndExclude register_query_play_list]
    this.template?.offQueryPlaylist();
    // [StartExclude register_query_play_list]
    // [EndExclude register_query_current_single]
    this.template?.offQueryCurrentSingle();
    // [StartExclude register_query_current_single]
    // [EndExclude register_query_compilation_by_keyword]
    this.template?.offQueryCompilationByKeyword();
    // [StartExclude register_query_compilation_by_keyword]
    // [EndExclude register_query_media_entity_by_keyword]
    this.template?.offQueryMediaEntityByKeyword();
    // [StartExclude register_query_media_entity_by_keyword]
    // [EndExclude register_query_recommend_media_entity_list]
    this.template?.offQueryRecommendMediaEntityList();
    // [StartExclude register_query_recommend_media_entity_list]
    // [EndExclude register_query_hot_words]
    this.template?.offQueryHotWords();
    // [StartExclude register_query_hot_words]
    // [EndExclude register_query_search_history]
    this.template?.offQuerySearchHistory();
    // [StartExclude register_query_search_history]
    // [EndExclude register_clear_search_history]
    this.template?.offClearSearchHistory();
    // [StartExclude register_clear_search_history]
    // [EndExclude register_on_login]
    this.template?.offLogin();
    // [StartExclude register_on_login]
    // [EndExclude register_request_dialog_info]
    this.template?.offRequestDialogInfo();
    // [StartExclude register_request_dialog_info]
    // [EndExclude register_handle_member_purchase]
    this.template?.offHandleMemberPurchase();
    // [StartExclude register_handle_member_purchase]
    // [EndExclude register_query_member_purchase]
    this.template?.offQueryMemberPurchase();
    // [StartExclude register_query_member_purchase]
    // [EndExclude register_query_custom_content]
    this.template?.offQueryCustomContent();
    // [StartExclude register_query_custom_content]
    // [EndExclude register_download_media_entity]
    this.template?.offDownloadMediaEntity();
    // [StartExclude register_download_media_entity]
    // [EndExclude register_settings_change]
    this.template?.offSettingsChange();
    // [StartExclude register_settings_change]
    // [EndExclude register_problem_and_advice]
    this.template?.offProblemAndAdvice();
    // [StartExclude register_problem_and_advice]
    // [EndExclude register_play_for_search]
    this.template?.offPlayForSearch();
    // [StartExclude register_play_for_search]
    // [EndExclude register_execute_action]
    this.template?.offExecuteAction();
    // [StartExclude register_execute_action]
    // [EndExclude register_play_media_entity]
    this.template?.offPlayMediaEntity();
    // [StartExclude register_play_media_entity]
    // [EndExclude register_favorite_media_entity]
    this.template?.offFavoriteMediaEntity();
    // [StartExclude register_favorite_media_entity]
    // [EndExclude destroy]
    this.template?.destroy();
    this.template = undefined;
    // [EndExclude register_query_main_tabs]
    // [EndExclude register_query_media_tab_content]
    // [EndExclude register_query_media_entity]
    // [EndExclude register_query_compilation]
    // [EndExclude register_query_play_list]
    // [EndExclude register_query_current_single]
    // [EndExclude register_query_compilation_by_keyword]
    // [EndExclude register_query_media_entity_by_keyword]
    // [EndExclude register_query_recommend_media_entity_list]
    // [EndExclude register_query_hot_words]
    // [EndExclude register_query_search_history]
    // [EndExclude register_clear_search_history]
    // [EndExclude register_on_login]
    // [EndExclude register_request_dialog_info]
    // [EndExclude register_handle_member_purchase]
    // [EndExclude register_query_member_purchase]
    // [EndExclude register_query_custom_content]
    // [EndExclude register_download_media_entity]
    // [EndExclude register_settings_change]
    // [EndExclude register_problem_and_advice]
    // [EndExclude register_play_for_search]
    // [EndExclude register_execute_action]
    // [EndExclude register_play_media_entity]
    // [EndExclude register_favorite_media_entity]
  };
  // [StartExclude unregister_listener]
  // [EndExclude start_template]
  // [StartExclude register_query_hot_words]
  // [StartExclude register_query_search_history]
  // [StartExclude register_execute_action]
  // [StartExclude register_play_media_entity]
  // [StartExclude destroy]

  // [StartExclude register_query_main_tabs]
  // [StartExclude register_query_media_tab_content]
  // [StartExclude register_query_media_entity]
  // [StartExclude register_query_compilation]
  // [StartExclude register_query_play_list]
  // [StartExclude register_query_current_single]
  // [StartExclude register_query_compilation_by_keyword]
  // [StartExclude register_query_media_entity_by_keyword]
  // [StartExclude register_query_recommend_media_entity_list]
  // [StartExclude register_clear_search_history]
  // [StartExclude register_on_login]
  // [StartExclude register_request_dialog_info]
  // [StartExclude register_handle_member_purchase]
  // [StartExclude register_query_member_purchase]
  // [StartExclude register_query_custom_content]
  // [StartExclude register_download_media_entity]
  // [StartExclude register_settings_change]
  // [StartExclude register_problem_and_advice]
  // [StartExclude register_play_for_search]
  // [StartExclude register_favorite_media_entity]
  /**
   * 模拟开启模板
   */
  public startTemplate() {
    this.template?.startTemplate();
  }
  // [StartExclude start_template]
  // [EndExclude set_user_info]

  /**
   * 模拟登录状态改变
   *
   * @param isLogin 是否登录
   */
  public setLoginState(isLogin: boolean) {
    this.isLogin = isLogin;
    this.setUserInfo();
  }

  /**
   * 用户信息发生变化后通知界面刷新用户信息，如登陆账号后
   */
  public setUserInfo() {
    let userInfo: avMusicTemplate.UserInfo = {
      userInfoId: this.isLogin ? 'userInfoId' : '',
      nickName: this.isLogin ? '昵称' : '',
      profilePicUrl: this.isLogin ? 'profilePicUrl' : '',
      tips: this.isLogin ? 'tips' : '',
      isLogin: this.isLogin,
      isVip: false
    };
    this.template?.setUserInfo(userInfo);
  };
  // [StartExclude set_user_info]
  // [EndExclude set_dialog_command]

  /**
   * 弹框相关的操作，如：打开，关闭
   */
  public setDialogCommand() {
    let type: avMusicTemplate.DialogControlType = 'open';
    let qrCodeInfo: avMusicTemplate.QrCodeInfo[] = [{
      id: 'id',
      price: '10',
      titleName: 'title',
      detailName: 'detail',
      tips: 'tip',
      content: 'content',
      validPeriod: 1
    }];
    let dialogInfo: avMusicTemplate.DialogInfo = {
      dialogId: 'dialogId',
      dialogType: avMusicTemplate.DialogType.LOGIN,
      qrCodes: qrCodeInfo
    };
    this.template?.setDialogCommand(type, dialogInfo);
  };
  // [StartExclude set_dialog_command]
  // [EndExclude set_current_single]

  public async setCurrentSingle() {
    let single: avMusicTemplate.Single = await this.createCurrentSingle()
    this.template?.setCurrentSingle(single);
  };
  // [EndExclude set_media_entities]

  // [StartExclude set_current_single]
  /**
   * 媒体播放后信息后，如：歌单的播放状态
   */
  public setMediaEntities() {
    let mediaEntities: avMusicTemplate.MediaEntity[] = [{
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    }];
    this.template?.setMediaEntities(mediaEntities);
  };
  // [StartExclude set_media_entities]
  // [EndExclude set_tab_content]

  /**
   * 某个tab页签下的内容发生变化后通知界面刷新
   */
  public setTabContent() {
    let mediaEntity: avMusicTemplate.MediaEntity[] = [{
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    }]
    let compilation: avMusicTemplate.Compilation[] = [{
      errorCode: 0,
      errorMsg: 'success',
      id: 'id',
      title: 'title',
      hasMoreData: true,
      totalSize: 2,
      memberMediaType: avMusicTemplate.EntityType.SINGLE,
      topElements: mediaEntity
    }]
    let mediaTabContent: avMusicTemplate.MediaTabContent = {
      errorCode: 0,
      errorMsg: 'success',
      tabId: 'tabId',
      compilations: compilation
    }
    this.template?.setTabContent('tabId', mediaTabContent);
  };
  // [StartExclude set_tab_content]
  // [EndExclude set_play_list]

  /**
   * 播放列表发送变化后通知界面刷新
   */
  public setPlaylist() {
    let mediaEntity: avMusicTemplate.MediaEntity = {
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    }
    let pageMediaEntity: avMusicTemplate.PageMediaEntity = {
      errorCode: 0,
      errorMsg: 'success',
      pageIndex: 0,
      pageSize: 1,
      hasMoreData: true,
      totalSize: 2,
      memberMediaType: avMusicTemplate.EntityType.SINGLE,
      elements: [mediaEntity]
    }
    this.template?.setPlaylist(pageMediaEntity);
  };
  // [StartExclude set_play_list]

  // [EndExclude register_download_media_entity]
  /**
   * 下载状态，进度刷新
   */
  public setDownloadMediaEntityStatus(mediaEntity: avMusicTemplate.MediaEntity) {
    this.template?.setDownloadMediaEntityStatus(mediaEntity);
  };
  // [EndExclude set_custom_elements]

  // [StartExclude register_download_media_entity]
  /**
   * 自定义数据发生变化后通知
   */
  public setCustomElements() {
    let mediaEntity: avMusicTemplate.MediaEntity = {
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    }
    let compilation: avMusicTemplate.Compilation = {
      errorCode: 0,
      errorMsg: 'success',
      id: 'id',
      title: 'title',
      hasMoreData: true,
      totalSize: 2,
      memberMediaType: avMusicTemplate.EntityType.SINGLE,
      topElements: [mediaEntity]
    }
    let customElement: avMusicTemplate.CustomElement = {
      errorCode: 0,
      errorMsg: 'success',
      customCompilations: [compilation]
    }
    this.template?.setCustomElements('add', 'COMPILATION', customElement);
  };
  // [StartExclude set_custom_elements]
  // [EndExclude set_settings]

  /**
   * 设置项变化后通知
   */
  public setSettings() {
    let settingItems: avMusicTemplate.SettingItem[] = [{
      id: 'id',
      title: 'title',
      desc: 'desc',
      mediaId: 'mediaId',
      settingType: avMusicTemplate.SettingType.SWITCH,
      settingValue: false
    }];
    this.template?.setSettings(settingItems);
  };
  // [StartExclude set_settings]
  // [EndExclude report_execute_action]

  /**
   * 模拟向媒体中心同步执行操作信息
   */
  public reportExecuteAction() {
    let actionType: string = 'actionType';
    let params: string = 'params';
    this.template?.reportExecuteAction(actionType, params);
  };
  // [StartExclude report_execute_action]
  // [EndExclude set_extension_ability]

  /**
   * 媒体应用需要拉起应用的自定义界面时调用
   */
  public setExtensionAbility() {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: 'com.example.templateprovider',
          abilityName: 'EntryAbility',
          type: 'action',
          parameters: {
            'ability.want.params.uiExtensionType': 'action'
          }
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITIES,
      requestCode: 0
    }
    wantAgent.getWantAgent(wantAgentInfo).then((agent) => {
      this.template?.setExtensionAbility(agent);
    }).catch((e: BusinessError) => {
      console.error(`getWantAgent, errCode: ${e?.code}`);
    })
  };
  // [StartExclude set_extension_ability]

  // [EndExclude template_register_listener]
  // [EndExclude register_query_main_tabs]
  /**
   * 模拟获取主界面的所有TAB。
   *
   * @returns Promise类型MediaTab数组
   */
  private async getMainTabs(): Promise<avMusicTemplate.MediaTab[]> {
    let homeTab: avMusicTemplate.MediaTab = {
      tabId: 'home',
      tabName: '首页'
    };
    let mineTab: avMusicTemplate.MediaTab = {
      tabId: 'mine',
      tabName: '我的'
    };
    let mainTabs: avMusicTemplate.MediaTab[] = [homeTab, mineTab];
    return mainTabs;
  };
  // [StartExclude register_query_main_tabs]

  // [EndExclude register_query_media_tab_content]
  /**
   * 模拟获取TAB内容。
   *
   * @returns 标签页内容。
   */
  private async createMediaTabContent(): Promise<avMusicTemplate.MediaTabContent> {
    let compilation: avMusicTemplate.Compilation = await this.createCompilation();
    let mediaTabContent: avMusicTemplate.MediaTabContent = {
      errorCode: 0,
      tabId: 'tabId',
      compilations: [compilation]
    }
    return mediaTabContent;
  };

  // [EndExclude register_query_compilation_by_keyword]
  /**
   * 模拟获取合集数据。
   *
   * @returns 合集
   */
  private async createCompilation(): Promise<avMusicTemplate.Compilation> {
    let mediaEntity: avMusicTemplate.MediaEntity = await this.createMediaEntity();
    let compilation: avMusicTemplate.Compilation = {
      errorCode: 0,
      id: '',
      title: '',
      hasMoreData: false,
      totalSize: 1,
      memberMediaType: avMusicTemplate.EntityType.SINGLE,
      topElements: [mediaEntity],
    }
    return compilation;
  };

  // [EndExclude register_query_media_entity]
  // [EndExclude register_query_compilation]
  // [EndExclude register_query_play_list]
  // [EndExclude register_query_media_entity_by_keyword]
  // [EndExclude register_query_recommend_media_entity_list]
  /**
   * 模拟获取媒体数据
   *
   * @returns 媒体数据
   */
  private async createMediaEntity(): Promise<avMusicTemplate.MediaEntity> {
    let mediaEntity: avMusicTemplate.MediaEntity = {
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    };
    return mediaEntity;
  };
  // [StartExclude template_register_listener]
  // [StartExclude register_query_media_tab_content]
  // [StartExclude register_query_compilation_by_keyword]
  // [StartExclude register_query_recommend_media_entity_list]

  /**
   * 模拟获取PageMediaEntity。
   *
   * @returns PageMediaEntity
   */
  private async createPageMediaEntity(): Promise<avMusicTemplate.PageMediaEntity> {
    let mediaEntity: avMusicTemplate.MediaEntity = await this.createMediaEntity();
    let pageMediaEntity: avMusicTemplate.PageMediaEntity = {
      errorCode: 0,
      pageIndex: 0,
      pageSize: 1,
      hasMoreData: false,
      totalSize: 1,
      memberMediaType: avMusicTemplate.EntityType.SINGLE,
      elements: [mediaEntity]
    }
    return pageMediaEntity;
  };
  // [StartExclude register_query_media_entity]
  // [StartExclude register_query_compilation]
  // [StartExclude register_query_play_list]
  // [StartExclude register_query_media_entity_by_keyword]

  // [EndExclude register_query_current_single]
  // [EndExclude set_current_single]
  /**
   * 模拟获取当前单曲
   *
   * @returns 当前单曲
   */
  private async createCurrentSingle(): Promise<avMusicTemplate.Single> {
    let playInfo: avMusicTemplate.PlayInfo = {
      playCounts: '100w',
      isSupportNext: true,
      isSupportPrev: false,
      isSupportQuickForward: true,
      isSupportQuickBackward: true,
      quickForwardStep: 10,
      quickBackwardStep: 10,
      isSupportSkipHead: false,
      isSupportSkipTail: true,
      isSupportPlayMode: true,
      isSupportPlayRate: true,
      supportedPlayRate: ['1', '2', '3'],
      currentPlayRate: 'string;',
      isSupportSoundQuality: false,
      isSupportSoundEffect: true,
      totalDuration: 60,
      currentPlayDuration: 10,
      isSupportProgress: false,
    }
    let favoriteData: avMusicTemplate.FavoriteData = {
      isSupportFav: true,
      isFavorite: false,
      favCounts: '1000+'
    }
    let single: avMusicTemplate.Single = {
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: '歌曲标题',
      desc: '歌曲描述',
      imageUrl: '',
      playState: 0,
      isVip: false,
      singer: '',
      tags: [],
      playInfo: playInfo,
      favSubscribeData: favoriteData
    }
    return single;
  };
  // [StartExclude register_query_current_single]
  // [StartExclude set_current_single]

  // [EndExclude register_clear_search_history]
  // [EndExclude register_download_media_entity]
  // [EndExclude register_problem_and_advice]
  // [EndExclude register_play_for_search]
  // [EndExclude register_favorite_media_entity]
  /**
   * 模拟操作结果
   *
   * @returns 操作结果
   */
  private async createOperResult(): Promise<avMusicTemplate.OperResult> {
    let operResult: avMusicTemplate.OperResult = {
      errorCode: 0,
    }
    return operResult;
  };
  // [StartExclude register_clear_search_history]
  // [StartExclude register_problem_and_advice]
  // [StartExclude register_play_for_search]
  // [StartExclude register_favorite_media_entity]

  // [StartExclude register_download_media_entity]
  // [EndExclude register_on_login]
  /**
   * 模拟创建二维码信息数组
   *
   * @returns Promise类型的二维码信息数组
   */
  private async createQrCodeInfo(): Promise<avMusicTemplate.QrCodeInfo> {
    let qrCodeInfo: avMusicTemplate.QrCodeInfo = {
      id: 'id',
      price: '10',
      titleName: 'title',
      detailName: 'detail',
      tips: 'tip',
      content: 'content',
      validPeriod: 1
    };
    return qrCodeInfo;
  };
  // [StartExclude register_on_login]

  // [EndExclude register_request_dialog_info]
  // [EndExclude register_handle_member_purchase]
  /**
   * 模拟弹框信息
   *
   * @returns 弹框信息
   */
  private async createDialogInfo(): Promise<avMusicTemplate.DialogInfo> {
    let qrCodeInfo: avMusicTemplate.QrCodeInfo[] = [{
      id: 'id',
      price: '10',
      titleName: 'title',
      detailName: 'detail',
      tips: 'tip',
      content: 'content',
      validPeriod: 1
    }
    ];
    let dialogInfo: avMusicTemplate.DialogInfo = {
      dialogId: 'dialogId',
      dialogType: avMusicTemplate.DialogType.LOGIN,
      qrCodes: qrCodeInfo
    };
    return dialogInfo;
  };
  // [StartExclude register_request_dialog_info]
  // [StartExclude register_handle_member_purchase]

  // [EndExclude register_query_member_purchase]
  /**
   * 模拟查询会员购买信息
   *
   * @returns Promise类型的购买会员信息数组
   */
  private async createQueryMemberPurchase(): Promise<avMusicTemplate.MemberPurchaseInfo> {
    let memberPurchaseInfo: avMusicTemplate.MemberPurchaseInfo = {
      id: 'id',
      diagramUrl: 'diagramUrl',
      diagramContent: 'diagramContent',
      memberPurchaseType: avMusicTemplate.MemberPurchaseType.NORMAL
    };
    return memberPurchaseInfo;
  };
  // [StartExclude register_query_member_purchase]

  // [EndExclude register_query_custom_content]
  /**
   * 模拟获取自定义内容
   *
   * @returns 自定义元素
   */
  private async createCustomContent(): Promise<avMusicTemplate.CustomElement> {
    let mediaEntity: avMusicTemplate.MediaEntity = {
      mediaId: 'mediaId',
      mediaType: avMusicTemplate.EntityType.SINGLE,
      parentId: 'parentId',
      parentMediaType: avMusicTemplate.EntityType.SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: avMusicTemplate.PlaybackState.PLAYBACK_STATE_PREPARE
    }
    let compilation: avMusicTemplate.Compilation = {
      errorCode: 0,
      errorMsg: 'success',
      id: 'id',
      title: 'title',
      hasMoreData: false,
      totalSize: 1,
      memberMediaType: avMusicTemplate.EntityType.SINGLE,
      topElements: [mediaEntity]
    };
    let customElement: avMusicTemplate.CustomElement = {
      errorCode: 0,
      customCompilations: [compilation],
    };
    return customElement;
  };
  // [StartExclude register_query_custom_content]

  // [EndExclude register_download_media_entity]
  /**
   * 模拟下载过程
   *
   * @param mediaEntity 媒体实体
   */
  private async downloadMediaEntity(mediaEntity: avMusicTemplate.MediaEntity) {
    // 下载完成之后。
    this.setDownloadMediaEntityStatus(mediaEntity);
  };
  // [StartExclude register_download_media_entity]

  // [EndExclude register_settings_change]
  /**
   * 模拟设置改变
   *
   * @returns Promise类型的设置条目
   */
  private async settingsChange(): Promise<avMusicTemplate.SettingItem> {
    let setting: avMusicTemplate.SettingItem = {
      id: 'id',
      title: 'title',
      desc: 'desc',
      mediaId: 'mediaId',
      settingType: avMusicTemplate.SettingType.SWITCH,
      settingValue: false
    }
    return setting;
  };
  // [EndExclude manager_create_template]
  // [EndExclude template_register_listener]
  // [EndExclude set_user_info]
  // [EndExclude unregister_listener]
  // [EndExclude start_template]
  // [EndExclude register_query_main_tabs]
  // [EndExclude register_query_media_tab_content]
  // [EndExclude register_query_media_entity]
  // [EndExclude register_query_compilation]
  // [EndExclude register_query_play_list]
  // [EndExclude register_query_current_single]
  // [EndExclude register_query_compilation_by_keyword]
  // [EndExclude register_query_media_entity_by_keyword]
  // [EndExclude register_query_recommend_media_entity_list]
  // [EndExclude register_query_hot_words]
  // [EndExclude register_query_search_history]
  // [EndExclude register_clear_search_history]
  // [EndExclude register_on_login]
  // [EndExclude register_request_dialog_info]
  // [EndExclude register_handle_member_purchase]
  // [EndExclude register_query_member_purchase]
  // [EndExclude register_query_custom_content]
  // [EndExclude register_download_media_entity]
  // [EndExclude register_problem_and_advice]
  // [EndExclude register_play_for_search]
  // [EndExclude register_execute_action]
  // [EndExclude register_play_media_entity]
  // [EndExclude register_favorite_media_entity]
  // [EndExclude set_dialog_command]
  // [EndExclude set_current_single]
  // [EndExclude set_media_entities]
  // [EndExclude set_tab_content]
  // [EndExclude set_play_list]
  // [EndExclude set_custom_elements]
  // [EndExclude set_settings]
  // [EndExclude report_execute_action]
  // [EndExclude set_extension_ability]
  // [EndExclude destroy]
}
// [End manager_create_template]
// [End template_register_listener]
// [End set_user_info]
// [End unregister_listener]
// [End start_template]
// [End register_query_main_tabs]
// [End register_query_media_tab_content]
// [End register_query_media_entity]
// [End register_query_compilation]
// [End register_query_play_list]
// [End register_query_current_single]
// [End register_query_compilation_by_keyword]
// [End register_query_media_entity_by_keyword]
// [End register_query_recommend_media_entity_list]
// [End register_query_hot_words]
// [End register_query_search_history]
// [End register_clear_search_history]
// [End register_on_login]
// [End register_request_dialog_info]
// [End register_handle_member_purchase]
// [End register_query_member_purchase]
// [End register_query_custom_content]
// [End register_download_media_entity]
// [End register_settings_change]
// [End register_problem_and_advice]
// [End register_play_for_search]
// [End register_execute_action]
// [End register_play_media_entity]
// [End register_favorite_media_entity]
// [End set_dialog_command]
// [End set_current_single]
// [End set_media_entities]
// [End set_tab_content]
// [End set_play_list]
// [End set_custom_elements]
// [End set_settings]
// [End report_execute_action]
// [End set_extension_ability]
// [End destroy]