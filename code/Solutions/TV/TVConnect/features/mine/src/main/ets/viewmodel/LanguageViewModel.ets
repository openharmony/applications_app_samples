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
import { InternationalManager } from '../model/manager/InternationalManager';
import { Language } from '../model/entity/Language';
import { Logger } from '@ohos/common';

/**
 * 语言组件信息
 */
@Observed
export class LanguageComponentInfo {
  public static newSelectedLanguageList: ItemArray = []; // 页面新选择的语言
  public static oldSelectedLanguageList: ItemArray = []; // 数据库中存储的语言
  public static languageList: ItemArray = []; // 所有可用语言列表
  public static internationalManager: InternationalManager;
  private static instance: LanguageComponentInfo;

  public static async getInstance() {
    if (!LanguageComponentInfo.instance) {
      let internationalManager: InternationalManager = await InternationalManager.getInstance();
      LanguageComponentInfo.internationalManager = internationalManager;
      LanguageComponentInfo.instance = new LanguageComponentInfo();
      InternationalManager.registerLanguageChangeListener(LanguageComponentInfo.updateLanguageComponentInfo);
    }
    LanguageComponentInfo.updateLanguageComponentInfo();
    return LanguageComponentInfo.instance;
  }

  /**
   * 更新语言组件信息
   */
  public static updateLanguageComponentInfo() {
    LanguageComponentInfo.languageList = [];
    if (LanguageComponentInfo.internationalManager != null) {
      for (let i of LanguageComponentInfo.internationalManager.getLanguageList()) {
        Logger.error(`ppppppp ${i.languageDisplay}`);
        LanguageComponentInfo.languageList.push(new LanguageItemInfo(i));
      }
      let old = new LanguageItemInfo(LanguageComponentInfo.internationalManager.getCurrentLanguage());
      old.isSelected = true;
      LanguageComponentInfo.oldSelectedLanguageList = [old];
    }
  }

  /**
   * 设置应用偏好语言
   */
  public static async setAppLanguage(language: Language) {
    if (LanguageComponentInfo.internationalManager != null) {
      await LanguageComponentInfo.internationalManager.setCurrentLanguage(language);
      LanguageComponentInfo.updateLanguageComponentInfo();
    }
  }
}

/**
 * 语言项信息
 */
@Observed
export class LanguageItemInfo {
  public language: Language;
  public isSelected: boolean = false;

  constructor(language: Language) {
    this.language = language;
  }

  showFunc(isShow: boolean) {
    this.isSelected = isShow;
  }

  handleFunc() {
  }
}

@Observed
export class ItemArray extends Array<LanguageItemInfo> {
}