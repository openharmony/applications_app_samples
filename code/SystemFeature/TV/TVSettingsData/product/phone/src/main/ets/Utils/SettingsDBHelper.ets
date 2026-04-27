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

import { preferences as data_storage, relationalStore } from '@kit.ArkData';
import { resourceManager, i18n } from '@kit.LocalizationKit';
import { deviceInfo, settings, systemParameter } from '@kit.BasicServicesKit';
import SettingsDataConfig from '../Utils/SettingsDataConfig';
import { Log } from '../Utils/Log';

let DDL_TABLE_CREATE = `CREATE TABLE IF NOT EXISTS ${SettingsDataConfig.TABLE_NAME} (` +
  `${SettingsDataConfig.FIELD_ID} INTEGER PRIMARY KEY AUTOINCREMENT, ` +
  `KEYWORD TEXT, ` +
  `VALUE TEXT CHECK (LENGTH(VALUE)<=1000))`;

const defaultSettings: string = 'default_settings.json';
const settingsDataPreference: string = 'SettingsDataPreference';

let defaultKey = SettingsDataConfig.DefaultKey;
let settingsKey = SettingsDataConfig.SettingsKey;

const defaultKvGlobal = {
  'settings.screen.brightness.default': '50',
  'settings.time.format.default': '24',
  'settings.audio.ringtone.default': '5',
  'settings.audio.media.default': '5',
  'settings.audio.voicecall.default': '5',
  'settings.display.navigationbar_status.default': '1',
  //饱和度
  'settings.screen.outputSaturation.default': '50',
  //对比度
  'settings.screen.outputContrast.default': '50',
  //色调
  'settings.screen.displayHue.default': '50',
  //HDRType
  'settings.screen.HDRType.default': 'SDR',
  //HDMI_adaptive
  'settings.HDMI.adaptive.default': 'true',
  //HDMI_CEC
  'settings.HDMI.CEC.default': 'true',
  //HDMI_HDCP
  'settings.HDMI.HDCP.default': 'true',
  //HDMI_CECRemote
  'settings.HDMI.CECRemote.default': 'true',
  //displayArea_x
  'settings.displayArea.X.default': '0',
  //displayArea_y
  'settings.displayArea.Y.default': '0',
  //displayArea_width
  'settings.displayArea.width.default': '200',
  //displayArea_height
  'settings.displayArea.height.default': '100',
  //displayFormat
  'settings.displayFormat.default': 'AUTO',
  //resolution
  'settings.resolution.default': '1080UI'
};

const TIME_FORMAT = {
  TIME_FORMAT_24: '24',
  TIME_FORMAT_12: '12',
};

class SettingsDBHelper {
  private firstStartupFlag: boolean;
  private rdbStore_;
  private context_;
  private static instance_: SettingsDBHelper;

  private constructor() {
    this.firstStartupFlag = false;
    this.rdbStore_ = undefined;
    this.context_ = globalThis.abilityContext;
    Log.I('call construstor');
  }

  private async firstStartupConfig(): Promise<void> {
    Log.I('firstStartupConfig start');
    let path: string = await this.context_.getFilesDir();
    let storage = await data_storage.getStorage(path + settingsDataPreference);
    Log.I('firstStartupConfig getStorage = ' + storage);
    let isExist = await storage.has('isFirstStartUp');
    Log.I('firstStartupConfig has isFirstStartUp = ' + isExist);
    if (!isExist) {
      Log.I('The key of isFirstStartUp is not contained.');
      Log.I('firstStartupConfig put start');
      await storage.put('isFirstStartUp', 'true');
      Log.I('firstStartupConfig flush start');
      await storage.flush();
      Log.I('firstStartupConfig flush end');
      this.firstStartupFlag = true;
    } else {
      let startup = await storage.get('isFirstStartUp', 'null');
      if (startup != 'true') {
        Log.I('firstStartupConfig get startup = ' + startup);
        this.firstStartupFlag = true;
      }
    }
    Log.I('firstStartupConfig end');
    return;
  }

  public async initRdbStore() {
    Log.I('call initRdbStore start');
    this.rdbStore_ = await relationalStore.getRdbStore(this.context_, { name: SettingsDataConfig.DB_NAME }, 1);
    Log.I('call initRdbStore, rdbStore_ = ' + this.rdbStore_);

    Log.I('initRdbStore executeSql');
    await this.rdbStore_.executeSql(DDL_TABLE_CREATE, []);

    Log.I('getRdbStore firstStartupConfig');
    await this.firstStartupConfig();

    if (this.firstStartupFlag) {
      Log.I('initRdbStore getDefaultSettingsKV');
      let defaultKV = await this.getDefaultSettingsKV();
      Log.I('initRdbStore loadDefaultSettings');
      await this.loadDefaultSettings(defaultKV);
    } else {
      Log.I('initRdbStore not need loadDefaultSettings');
    }
    Log.I('call initRdbStore end');
    return this.rdbStore_;
  }

  public static getInstance() {
    if (!SettingsDBHelper.instance_) {
      Log.I('call getInstance start');
      SettingsDBHelper.instance_ = new SettingsDBHelper();
      Log.I('call getInstance end');
    }
    return SettingsDBHelper.instance_;
  }

  public async getRdbStore() {
    Log.I('call getRdbStore start');
    return await SettingsDBHelper.instance_.initRdbStore();
  }

  private async loadSettings(rdbStore_, key, value): Promise<void> {
    Log.I('key=' + key + ' value ' + value);
    await this.rdbStore_.insert(
      SettingsDataConfig.TABLE_NAME,
      { 'KEYWORD': key, 'VALUE': value },
      (err, ret) => {
        if (err) {
          Log.E('loadSettings insert error:' + JSON.stringify(err));
        }
        Log.I('loadSettings insert ret = ' + ret);
      });
  }

  private async loadDefaultSettings(defaultKV) {
    Log.I('loadDefaultSettings start');

    await this.loadSettings(this.rdbStore_,
      settings.display.SCREEN_BRIGHTNESS_STATUS, defaultKV[defaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT]);

    await this.loadSettings(this.rdbStore_,
      settings.date.TIME_FORMAT, defaultKV[defaultKey.SETTINGS_TIME_FORMAT_DEFAULT]);

    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_AUDIO_RINGTONE, defaultKV[defaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT]);

    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_AUDIO_MEDIA, defaultKV[defaultKey.SETTINGS_AUDIO_MEDIA_DEFAULT]);

    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_AUDIO_VOICE_CALL, defaultKV[defaultKey.SETTINGS_AUDIO_VOICE_CALL_DEFAULT]);

    await this.loadSettings(this.rdbStore_,
      settings.general.DEVICE_NAME, defaultKV[defaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT]);

    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_DISPALY_NAVBAR_STATUS, defaultKV[defaultKey.SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT]);

    //饱和度
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_SCREEN_OUTPUTSATURATION, defaultKV[defaultKey.SETTINGS_SCREEN_OUTPUTSATURATION_DEFAULT]);
    //对比度
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_SCREEN_OUTPUTCONTRAST, defaultKV[defaultKey.SETTINGS_SCREEN_OUTPUTCONTRAST_DEFAULT]);
    //色调
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_SCREEN_DISPLAYHUE, defaultKV[defaultKey.SETTINGS_SCREEN_DISPLAYHUE_DEFAULT]);
    //HDRType
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_SCREEN_HDRTYPE, defaultKV[defaultKey.SETTINGS_SCREEN_HDRTYPE_DEFAULT]);
    //HDMI_adaptive
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_HDMI_ADAPTIVE, defaultKV[defaultKey.SETTINGS_HDMI_ADAPTIVE_DEFAULT]);
    //HDMI_CEC
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_HDMI_CEC, defaultKV[defaultKey.SETTINGS_HDMI_CEC_DEFAULT]);
    //HDMI_HDCP
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_HDMI_HDCP, defaultKV[defaultKey.SETTINGS_HDMI_HDCP_DEFAULT]);
    //HDMI_CECRemote
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_HDMI_CECREMOTE, defaultKV[defaultKey.SETTINGS_HDMI_CECREMOTE_DEFAULT]);
    //displayArea_x
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_DISPLAYAREA_X, defaultKV[defaultKey.SETTINGS_DISPLAYAREA_X_DEFAULT]);
    //displayArea_y
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_DISPLAYAREA_Y, defaultKV[defaultKey.SETTINGS_DISPLAYAREA_Y_DEFAULT]);
    //displayArea_width
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_DISPLAYAREA_WIDTH, defaultKV[defaultKey.SETTINGS_DISPLAYAREA_WIDTH_DEFAULT]);
    //displayArea_height
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_DISPLAYAREA_HEIGHT, defaultKV[defaultKey.SETTINGS_DISPLAYAREA_HEIGHT_DEFAULT]);
    //displayFormat
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_DISPLAYFORMAT, defaultKV[defaultKey.SETTINGS_DISPLAYFORMAT_DEFAULT]);
    //resolution
    await this.loadSettings(this.rdbStore_,
      settingsKey.SETTINGS_RESOLUTION, defaultKV[defaultKey.SETTINGS_RESOLUTION_DEFAULT]);

    console.log(TAG + 'loadDefaultSettings end');
    Log.I('loadDefaultSettings end');
    return;
  }

  private async readDefaultFile(): Promise<string> {
    Log.I('readDefaultFile start');
    let rawStr: string = '';
    try {
      let resManager = await resourceManager.getResourceManager();
      Log.I('readDefaultFile resManager=' + resManager);
      let content = await resManager.getRawFile(defaultSettings);
      rawStr = String.fromCharCode.apply(null, content);
    } catch (err) {
      Log.E('readDefaultFile readRawFile err' + err);
    }
    Log.I('readDefaultFile end');
    return rawStr;
  }

  private async getDefaultSettingsKV() {
    Log.I('getDefaultSettingsKV start');
    let defaultKV = {};
    try {
      let content: string = await this.readDefaultFile();
      if (!content) {
        Log.I('getDefaultSettingsKV readDefaultFile err! content = ' + content);
        throw new Error('readfile error!');
      }
      let defaultJson = JSON.parse(content);
      Log.I('getDefaultSettingsKV parse = ' + JSON.stringify(defaultJson));
      for (let index = 0; index < defaultJson.settings.length; index++) {
        defaultKV[defaultJson.settings[index].name] = defaultJson.settings[index].value;
      }
    } catch (err) {
      Log.E('getDefaultSettingsKV catch err! err = ' + err);
      defaultKV = defaultKvGlobal;
    }
    let deviceName: string = deviceInfo.marketName;
    if (deviceName.startsWith('"') && deviceName.endsWith('"')) {
      deviceName = JSON.parse(deviceName);
    }
    defaultKV[defaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT] = deviceName;

    if (i18n.is24HourClock()) {
      defaultKV[defaultKey.SETTINGS_TIME_FORMAT_DEFAULT] = TIME_FORMAT.TIME_FORMAT_24;
    } else {
      defaultKV[defaultKey.SETTINGS_TIME_FORMAT_DEFAULT] = TIME_FORMAT.TIME_FORMAT_12;
    }

    let defaultBrightness = systemParameter.getSync('const.display.brightness.default');
    if (defaultBrightness.length > 0) {
      defaultKV[defaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT] = defaultBrightness;
    }
    return defaultKV;
  }
}

export default SettingsDBHelper;
