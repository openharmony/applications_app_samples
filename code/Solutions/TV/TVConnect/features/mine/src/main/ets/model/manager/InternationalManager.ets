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
import I18n from '@ohos.i18n';
import { Country } from '../entity/Country';
import { Language } from '../entity/Language';
import { Logger, PreferencesHelper } from '@ohos/common';
import Base from '@ohos.base';
import commonEventManager from '@ohos.commonEventManager';

/**
 * 语言类型
 */
enum LanguageType {
  FOLLOW_SYSTEM = 'FOLLOW_SYSTEM', ZH = 'ZH', EN = 'EN', UN_SUPPORT = 'UN_SUPPORT'
}

/**
 * 国际化管理
 */
@Observed
export class InternationalManager {
  public static readonly CURRENT_COUNTRY_KEY = 'current_country';
  public static readonly CURRENT_LANGUAGE_KEY = 'current_language';
  public static readonly AVAILABLE_LANGUAGES = 'available_language';
  public static languageChangeListener: Array<(error: Error | null, data: string) => void> = []; // 语言变更回调函数列表
  private static instance: InternationalManager;
  public currentLanguageCode: string = ''; //当前语言code
  public currentCountryCode: string = ''; //当前国家code
  public availableLanguageCodeList: string[] = []; //可用语言code列表
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;

  private constructor() {
  }

  /**
   * 注册语言变更监听器
   */
  static registerLanguageChangeListener(callback: (error: Error | null, data: string) => void) {
    InternationalManager.languageChangeListener.push(callback);
  }

  /**
   * 回调注册语言变更监听器
   */
  static onLanguageChange() {
    InternationalManager.getInstance().then((mgr) => {
      InternationalManager.languageChangeListener.forEach((callback) => {
        callback(null, mgr.currentLanguageCode);
      });
    });
  }

  public static async getInstance() {
    Logger.info('InternationalManager getInstance new instance & getCurrentCountry');
    if (!InternationalManager.instance) { //第一次获取单例对象
      InternationalManager.instance = new InternationalManager(); //创建对象
      await InternationalManager.instance.init(); //初始化
    }
    return InternationalManager.instance;
  }

  public systemLanguage = () => { //获取当前系统语言code
    return I18n.System.getSystemLanguage();
  };

  /**
   * 初始化国际化管理
   */
  async init() {
    Logger.info('InternationalManager init');
    if (!await this.getLocalCountryInfo()) { //如果数据库中没有存储地区信息，初始化地区信息
      await this.initCurrentCountry();
    }
    if (!await this.getLocalLanguageInfo()) { //如果数据库中没有存储语言信息，初始化语言信息
      await this.initCurrentLanguage();
      await this.initAvailableLanguageCodeList();
    }
    this.initSystemLanguageChangeListener();
  }

  /**
   * 监听系统语言变化
   */
  initSystemLanguageChangeListener() {
    let _this = this;
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['usual.event.LOCALE_CHANGED'],
    };
    commonEventManager.createSubscriber(subscribeInfo,
      (err: Base.BusinessError, data: commonEventManager.CommonEventSubscriber) => {
        if (err) {
          console.error(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        console.info('Succeeded in creating subscriber.');
        this.subscriber = data;
        _this.systemLanguageChangeListenerOpen();
      });
  }

  /**
   * 获取当前存储的地区信息
   */
  async getLocalCountryInfo(): Promise<boolean> {
    let currentCountryCode: string =
      (await PreferencesHelper.get(InternationalManager.CURRENT_COUNTRY_KEY, '')) as string;
    console.error('InternationalManager getLocalCountryInfo currentCountryCode:', currentCountryCode);
    if (currentCountryCode == '') {
      return false;
    }
    this.currentCountryCode = currentCountryCode;
    return true;
  }

  /**
   * 获取当前存储的语言信息
   */
  async getLocalLanguageInfo(): Promise<boolean> {
    let currentLanguageCode: string =
      (await PreferencesHelper.get(InternationalManager.CURRENT_LANGUAGE_KEY, '')) as string;
    if (currentLanguageCode == '') {
      return false;
    }
    this.currentLanguageCode = currentLanguageCode;
    let availableLanguagesCodes: string =
      (await PreferencesHelper.get(InternationalManager.AVAILABLE_LANGUAGES, '')) as string;
    let resAvailableLanguageList = availableLanguagesCodes.split(',');
    this.availableLanguageCodeList = resAvailableLanguageList;
    return true;
  }

  /**
   * 初始化当前国家
   */
  async initCurrentCountry(): Promise<boolean> {
    Logger.info('InternationalManager init database current country');
    return await this.setLocalCurrentCountry('CN'); //持久化
  }

  /**
   * 初始化当前语言
   */
  async initCurrentLanguage(): Promise<boolean> {
    Logger.info('InternationalManager init database current language');
    return await this.setLocalCurrentLanguage(LanguageType.FOLLOW_SYSTEM); //持久化
  }

  /**
   * 初始化可用语言列表
   */
  async initAvailableLanguageCodeList(): Promise<boolean> {
    Logger.info('InternationalManager init database available language code list');
    this.availableLanguageCodeList = [LanguageType.ZH, LanguageType.EN];
    return await this.setLocalAvailableLanguageCodeList(this.availableLanguageCodeList); //持久化
  }

  /**
   * 持久化可用语言列表
   */
  async setLocalAvailableLanguageCodeList(list: Array<string>): Promise<boolean> {
    Logger.info('InternationalManager setLocalAvailableLanguageCodeList');
    let tmp: string = '';
    for (let i of list) {
      tmp += i + ',';
    }
    tmp = tmp.substring(0, tmp.lastIndexOf(','));
    return await PreferencesHelper.put(InternationalManager.AVAILABLE_LANGUAGES, tmp);
  }

  /**
   * 获取可用语言列表
   */
  async getLocalAvailableLanguageCodeList(): Promise<Array<string>> {
    Logger.info('InternationalManager getAvailableLanguages');
    let languageInfo: string = (await PreferencesHelper.get(InternationalManager.AVAILABLE_LANGUAGES, '')) as string;
    let resAvailableLanguageList = languageInfo.split(',');
    this.availableLanguageCodeList = resAvailableLanguageList;
    return this.availableLanguageCodeList;
  }

  /**
   * 持久化当前地区
   */
  async getLocalCurrentCountry(): Promise<string | undefined> {
    let res: string = (await PreferencesHelper.get(InternationalManager.CURRENT_COUNTRY_KEY, '')) as string;
    if (res == '') {
      return undefined;
    }
    this.currentCountryCode = res;
    return this.currentCountryCode;
  }

  /**
   * 持久化当前地区
   */
  async setLocalCurrentCountry(countryCode: string): Promise<boolean> {
    Logger.info('InternationalManager setCurrentCountry');
    this.currentCountryCode = countryCode;
    return await PreferencesHelper.put(InternationalManager.CURRENT_COUNTRY_KEY, countryCode);
  }

  /**
   * 获取当前语言
   */
  async getLocalCurrentLanguage(): Promise<string | undefined> {
    let resCurrentLanguageCode: string =
      (await PreferencesHelper.get(InternationalManager.CURRENT_LANGUAGE_KEY, '')) as string;
    if (resCurrentLanguageCode == '') {
      return undefined;
    }
    this.currentLanguageCode = resCurrentLanguageCode;
    return this.currentLanguageCode;
  }

  /**
   * 持久化当前语言
   */
  async setLocalCurrentLanguage(languageCode: string): Promise<boolean> {
    this.currentLanguageCode = languageCode;
    return await PreferencesHelper.put(InternationalManager.CURRENT_LANGUAGE_KEY, languageCode);
  }

  /**
   * 获取当前地区
   */
  getCurrentCountry(): Country {
    return new Country(this.currentCountryCode, this.getDisplayCode(this.currentLanguageCode));
  }

  /**
   * 设置当前地区
   */
  async setCurrentCountry(country: Country) {
    await this.setLocalCurrentCountry(country.countryCode);
  }

  /**
   * 获取当前语言
   */
  getCurrentLanguage(): Language {
    let res: Language = new Language(this.systemLanguage(), this.systemLanguage());
    if (this.currentLanguageCode == LanguageType.FOLLOW_SYSTEM) {
      res.isFollowSystemLanguage = true;
      res.languageDisplay = $r('app.string.follow_system');
    } else {
      res = new Language(this.currentLanguageCode, this.getDisplayCode(this.currentLanguageCode));
    }
    return res;
  }

  /**
   * 设置当前语言
   */
  async setCurrentLanguage(language: Language) {
    let code = '';
    if (language.isFollowSystemLanguage) {
      code = LanguageType.FOLLOW_SYSTEM;
      await this.setLocalCurrentLanguage(code);
      InternationalManager.onLanguageChange();
      I18n.System.setAppPreferredLanguage(this.systemLanguage());
      this.systemLanguageChangeListenerOpen();
    } else {
      code = language.languageCode;
      await this.setLocalCurrentLanguage(code);
      InternationalManager.onLanguageChange();
      I18n.System.setAppPreferredLanguage(language.languageCode);
      this.systemLanguageChangeListenerClose();
    }
  }

  /**
   * 监听系统语言变化开启
   */
  systemLanguageChangeListenerOpen() {
    if (this.subscriber !== null) {
      commonEventManager.subscribe(this.subscriber,
        (err: Base.BusinessError, data: commonEventManager.CommonEventData) => {
          if (err) {
            console.error(`Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
            return;
          }
          I18n.System.setAppPreferredLanguage(this.systemLanguage());
          InternationalManager.onLanguageChange();
        });
    } else {
      console.error(`Need create subscriber`);
    }
  }

  /**
   * 监听系统语言变化关闭
   */
  systemLanguageChangeListenerClose() {
    if (this.subscriber !== null) {
      commonEventManager.unsubscribe(this.subscriber, (err: Base.BusinessError) => {
        if (err) {
          console.error(`UnsubscribeCallBack err = ${JSON.stringify(err)}`);
        } else {
          console.error(`UnsubscribeCallBack`);
        }
      });
    } else {
      console.error(`UnsubscribeCallBack err`);
    }
  }

  /**
   * 获取所有地区列表
   */
  getCountryList(): Array<Country> {
    let res: Country[] = [];
    let languageCode = this.getCurrentLanguage().languageCode;
    let codeList = I18n.System.getSystemCountries(languageCode);
    for (let code of codeList) {
      res.push(new Country(code, this.getDisplayCode(this.currentLanguageCode)));
    }
    return res;
  }

  /**
   * 获取所有可用语言列表
   */
  getLanguageList(): Array<Language> {
    let res: Language[] = [];
    let sysTmpLangStr = this.systemLanguage(); //跟随系统
    let sysTmpLang: Language = new Language(sysTmpLangStr, this.getDisplayCode(this.currentLanguageCode));
    sysTmpLang.isFollowSystemLanguage = true;
    sysTmpLang.languageDisplay = $r('app.string.follow_system');
    res.push(sysTmpLang);

    for (let language of this.availableLanguageCodeList) { //应用偏好语言
      let tmp = new Language(language, this.getDisplayCode(this.currentLanguageCode));
      res.push(tmp);
    }
    return res;
  }

  /**
   * 根据语言判断对应本地化标识符
   */
  getDisplayCode(language: string): string {
    if (language == LanguageType.ZH) {
      return 'zh-CN';
    } else if (language == LanguageType.EN) {
      return 'en-US';
    } else if (language == LanguageType.FOLLOW_SYSTEM) {
      return this.systemLanguage();
    }
    return 'zh-CN';
  }
}

