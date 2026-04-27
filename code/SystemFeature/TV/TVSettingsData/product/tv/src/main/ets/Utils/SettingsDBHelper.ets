/**
 * @file Describe the file
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

import { preferences as dataStorage, relationalStore } from '@kit.ArkData';
import { deviceInfo, settings, systemParameter } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { i18n } from '@kit.LocalizationKit';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from './SettingsDataConfig';
import { Log } from '../Utils/Log';
import { promptAction } from '@kit.ArkUI';
import { GlobalContext } from './GlobalContext';
import { contextConstant } from '@kit.AbilityKit';
import { IContent, TableType } from '../common/Common';

let DDL_TABLE_CREATE = `CREATE TABLE IF NOT EXISTS ${settingsDataConfig.TABLE_NAME} (` +
  `${settingsDataConfig.FIELD_ID} INTEGER PRIMARY KEY AUTOINCREMENT, ` +
  `KEYWORD TEXT, ` +
  `VALUE TEXT CHECK (LENGTH(VALUE)<=1000))`;

const DEFAULT_JSON_FILE_NAME : string = 'default_settings.json';
const SETTINGSDATA_PREFERENCE : string = 'SettingsDataPreference';
const SETTINGSDATA_PREFERENCE_USER : string = 'SettingsDataPreferenceUser';
const EL2_DB_PATH: string = '/data/storage/el2/database/entry/rdb/settingsdata.db';
const EMULATOR_TYPE: string = 'emulator';

// 定义一个类型来表示时间格式，其中键是枚举值，值是字符串
interface TimeFormat {
  TIME_FORMAT_24: string;
  TIME_FORMAT_12: string;
}

interface SettingDefaultContentType {
  name: string;
  value: string;
}

class DefaultSetting {
  public settings: SettingDefaultContentType[] = [];
}

// 给 defaultKvGlobal 添加类型
const defaultKvGlobal: Record<string, string> = {
  'settings.screen.brightness.default': '50',
  'settings.time.format.default': '24',
  'settings.audio.ringtone.default': '5',
  'settings.audio.media.default': '5',
  'settings.audio.voicecall.default': '5',
  'settings.display.navigationbar_status.default': '1',
  'cellular_data_enable.default': '1',
};

// 给TIME_FORMAT添加类型
const TIME_FORMAT: TimeFormat = {
  TIME_FORMAT_24: '24',
  TIME_FORMAT_12: '12',
};

const INITIAL_KEY: string = '_CreatedTime';
const VALID_DB_LENGTH: number = 48;
const SETTINGS_CLONED_STATUS: string = 'settingsClonedStatus';

class SettingsDBHelper {

  public static readonly SHARED_TABLE_CREATE_PREFIX: string =
    `CREATE TABLE IF NOT EXISTS ${settingsDataConfig.TABLE_NAME}`;
  // 需要在在表名后拼接当前的userid
  public static readonly CURRENT_USER_TABLE_CREATE_PREFIX: string =
    `CREATE TABLE IF NOT EXISTS ${settingsDataConfig.USER_TABLE_NAME}_`;
  public static readonly CURRENT_SECURE_TABLE_CREATE_PREFIX: string =
    `CREATE TABLE IF NOT EXISTS ${settingsDataConfig.SECURE_TABLE_NAME}_`;
  public static readonly TABLE_CREATE_SUFFIX =
    ` (${settingsDataConfig.FIELD_ID} INTEGER PRIMARY KEY AUTOINCREMENT, ` +
    `${settingsDataConfig.FIELD_KEYWORD} TEXT, ` +
    `${settingsDataConfig.FIELD_VALUE} TEXT CHECK (LENGTH(VALUE)<=1000))`;

  private firstStartupFlag: boolean;
  private rdbStore_ : relationalStore.RdbStore | undefined;
  private context_ : Context;
  private static instance_: SettingsDBHelper;
  private faultOccured: boolean = false;
  private area: contextConstant.AreaMode | undefined = undefined;


  private constructor() {
    this.firstStartupFlag = false;
    this.rdbStore_  = undefined;
    this.context_ = GlobalContext.getContext().getObject('abilityContext') as Context;
    Log.info('call construstor');
  }

  private async firstStartupConfig() : Promise<void> {
    Log.info('firstStartupConfig start');
    let storage = await dataStorage.getPreferences(this.context_, SETTINGSDATA_PREFERENCE);
    Log.info('firstStartupConfig getStorage = ' + storage);
    let isExist = await storage.has('isFirstStartUp');
    Log.info('firstStartupConfig has isFirstStartUp = ' + isExist);
    if (!isExist) {
      Log.info('The key of isFirstStartUp is not contained.');
      Log.info('firstStartupConfig put start');
      await storage.put('isFirstStartUp', 'true');
      Log.info('firstStartupConfig flush start');
      await storage.flush();
      Log.info('firstStartupConfig flush end');
      this.firstStartupFlag = true;
    } else {
      let startup = await storage.get('isFirstStartUp', 'null');
      if (startup != 'true') {
        Log.info('firstStartupConfig get startup = ' + startup);
        this.firstStartupFlag = true;
      }
    }
    Log.info('firstStartupConfig end');
    return;
  }

  public async initRdbStore() {
    Log.info('call initRdbStore start');
    this.rdbStore_ = await relationalStore.getRdbStore(this.context_, {
      name: settingsDataConfig.DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    });
    Log.info('call initRdbStore, rdbStore_ = ' + this.rdbStore_);

    Log.info('initRdbStore executeSql');
    await this.rdbStore_.executeSql(DDL_TABLE_CREATE, []);

    Log.info('getRdbStore firstStartupConfig');
    await this.firstStartupConfig();

    if (this.firstStartupFlag) {
      Log.info('initRdbStore getDefaultSettingsKV');
      let defaultKV = await this.getDefaultSettingsKV();
      Log.info('initRdbStore loadDefaultSettings');
      await this.loadDefaultSettings(defaultKV);
    } else {
      Log.info('initRdbStore not need loadDefaultSettings');
    }
    Log.info('call initRdbStore end');
    return this.rdbStore_;
  }

  public getArea() {
    const dbFile = EL2_DB_PATH;
    if (this.area === undefined) {
      try {
        let stat = fs.statSync(dbFile);
        if (stat.size > VALID_DB_LENGTH) {
          this.area = contextConstant.AreaMode.EL2;
        } else {
          this.area = contextConstant.AreaMode.EL1;
        }
      } catch {
        this.area = contextConstant.AreaMode.EL1;
      }
    }
    Log.info(`Area ${this.area}`);
    return this.area;
  }

  public async initialInsert(tableName: string): Promise<void> {
    try {
      Log.info(`insert ${tableName} with key: ${tableName + INITIAL_KEY} `);
      if (this.rdbStore_) {
        let ret = await this.rdbStore_.insert(tableName,
          { 'KEYWORD': tableName + INITIAL_KEY, 'VALUE': new Date().toString() });
        if (ret <= 0) {
          Log.error(`insert initial key-value failed for ${tableName}`);
        }
      } else {
        Log.error(`insert initial key-value failed for ${tableName}, no rdbStore`);
        this.faultOccured = true;
      }
    } catch (e) {
      Log.error(`insert initial key-value failed for ${tableName}`);
    }
  }

  public static getInstance() {
    if (!SettingsDBHelper.instance_) {
      Log.info('call getInstance start');
      SettingsDBHelper.instance_ = new SettingsDBHelper();
      Log.info('call getInstance end');
    }
    return SettingsDBHelper.instance_;
  }

  public async getRdbStore() {
    Log.info('call getRdbStore start');
    return await SettingsDBHelper.instance_.initRdbStore();
  }

  private async loadSettings(rdbStore_:relationalStore.RdbStore, key:string, value:string): Promise<void> {
    Log.info('key=' + key + ' value ' + value);
    if (this.rdbStore_!==undefined){
      this.rdbStore_.insert(
        settingsDataConfig.TABLE_NAME,
        { 'KEYWORD': key, 'VALUE': value },
        (err, ret) => {
          if (err) {
            Log.error('loadSettings insert error:' + JSON.stringify(err));
          }
          Log.info('loadSettings insert ret = ' + ret);
        });
    }
  }

  private async loadDefaultSettings(defaultKV:Record<string, string>) {
    Log.info('loadDefaultSettings start');
    if (this.rdbStore_!==undefined) {
      await this.loadSettings(this.rdbStore_,
        settings.display.SCREEN_BRIGHTNESS_STATUS, defaultKV[DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT]);

      await this.loadSettings(this.rdbStore_,
        settings.date.TIME_FORMAT, defaultKV[DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT]);

      await this.loadSettings(this.rdbStore_,
        DataSettingsKey.SETTINGS_AUDIO_RINGTONE, defaultKV[DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT]);

      await this.loadSettings(this.rdbStore_,
        DataSettingsKey.SETTINGS_AUDIO_MEDIA, defaultKV[DataDefaultKey.SETTINGS_AUDIO_MEDIA_DEFAULT]);

      await this.loadSettings(this.rdbStore_,
        DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL, defaultKV[DataDefaultKey.SETTINGS_AUDIO_VOICE_CALL_DEFAULT]);

      await this.loadSettings(this.rdbStore_,
        settings.general.DEVICE_NAME, defaultKV[DataDefaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT]);

      await this.loadSettings(this.rdbStore_,
        DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS,
        defaultKV[DataDefaultKey.SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT]);

      await this.loadSettings(this.rdbStore_,
        DataSettingsKey.CELLULAR_DATA_ENABLE, defaultKV[DataDefaultKey.CELLULAR_DATA_ENABLE_DEFAULT]);

      Log.info('loadDefaultSettings end');
      return;
    }else {
      promptAction.showToast({ message: '错误！未查询到数据！' });
    }

  }

  public  async readDefaultFile(): Promise<Object> {
    Log.info('readDefaultFile start');
    let rawStr: string = '';
    try {
      let resManager = this.context_.resourceManager;
      Log.info('readDefaultFile resManager=' + resManager);
      let content = await resManager.getRawFileContent(DEFAULT_JSON_FILE_NAME);
      rawStr = JSON.stringify(content);
    } catch (err) {
      Log.error('readDefaultFile readRawFile err' + err);
    }
    Log.info('readDefaultFile end');
    return rawStr;
  }

  private async getDefaultSettingsKV() {
    Log.info('getDefaultSettingsKV start');
    let defaultKV:Record<string, string> = {} ;
    try {
      let content : IContent= await this.readDefaultFile() as IContent;
      if (!content) {
        Log.info('getDefaultSettingsKV readDefaultFile err! content = ' + content);
        throw new Error('readfile error!');
      }
      let defaultJson = content;
      Log.info('getDefaultSettingsKV parse = ' + JSON.stringify(defaultJson));
      for (let  index = 0; index < defaultJson.settings.length; index++) {
        defaultKV[defaultJson.settings[index]['name']] = defaultJson.settings[index]['value'];
      }
    } catch (err) {
      Log.error('getDefaultSettingsKV catch err! err = ' + err);
      defaultKV = defaultKvGlobal;
    }
    let deviceName: string = deviceInfo.marketName;
    if (deviceName.startsWith('"') && deviceName.endsWith('"')) {
      deviceName = JSON.parse(deviceName);
    }
    defaultKV[DataDefaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT] = deviceName;

    if (i18n.is24HourClock()) {
      defaultKV[DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT] = TIME_FORMAT.TIME_FORMAT_24;
    } else {
      defaultKV[DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT] = TIME_FORMAT.TIME_FORMAT_12;
    }

    let defaultBrightness = systemParameter.getSync('const.display.brightness.default');
    if (defaultBrightness.length > 0) {
      defaultKV[DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT] = defaultBrightness;
    }
    return defaultKV;
  }

  public async loadTableData(content: IContent, tableType: TableType, userId: number): Promise<void> {
    if (!content) {
      Log.error('content is empty');
      return;
    }
    switch (tableType) {
      case TableType.SETTINGS:
        this.loadDefaultTaleData(content.settings, TableType.SETTINGS, userId);
        return;
      case TableType.USER:
        this.loadDefaultTaleData(content.user, TableType.USER, userId);
        return;
      case TableType.SETTINGS:
        this.loadDefaultTaleData(content.userSecure, TableType.USER_SECURE, userId);
        return;
      default:
        Log.error('invalid type');
    }
  }

  private async loadDefaultTaleData(tableData: Array<Map<string, string>>, tableType: TableType,
                                    userID: number): Promise<void> {
    if (tableData?.length <= 0) {
      Log.error(`${tableType} table data is empty`);
      return;
    }
    let tableName: string = this.getTableName(tableType, userID);
    for (let index = 0; index < tableData.length; index++) {
      await this.loadTableSettings(tableData[index]['name'], tableData[index]['value'], tableName);
    }
  }

  private  getTableName(tableType: TableType, userId: number): string {
    if (tableType === TableType.SETTINGS) {
      return settingsDataConfig.TABLE_NAME;
    }
    if (tableType === TableType.USER) {
      return `${settingsDataConfig.USER_TABLE_NAME}_${userId}`;
    }
    return `${settingsDataConfig.SECURE_TABLE_NAME}_${userId}`;
  }

  private async loadTableSettings(key: string, value: string, tableName: string): Promise<void> {
    if (!this.rdbStore_) {
      Log.error('rdbStore is null!');
      return
    }
    Log.info(`tableName: ${tableName}, key: ${key}, value: ${value}`);
    try {
      let ret = await this.rdbStore_.insert(tableName, { 'KEYWORD': key, 'VALUE': value });
      if (ret >= 0) {
        Log.info(`insert into DB success; ${ret}`);
      } else {
        this.faultOccured = true;
        Log.error(`insert into DB faild; ${ret}`);
      }
    } catch (err) {
      Log.warn(`insert key ${key} failed`);
    }
  }

}

export default SettingsDBHelper;
