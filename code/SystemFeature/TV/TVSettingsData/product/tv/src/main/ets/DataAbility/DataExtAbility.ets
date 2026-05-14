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
import { audio } from '@kit.AudioKit';
import { abilityAccessCtrl, Want, contextConstant } from '@kit.AbilityKit';
import { bluetooth } from '@kit.ConnectivityKit';
import { DataShareExtensionAbility, dataSharePredicates, relationalStore, ValuesBucket } from '@kit.ArkData';
import { rpc } from '@kit.IPCKit';
import { AsyncCallback, BusinessError, settings } from '@kit.BasicServicesKit';
import SettingsDBHelper from '../Utils/SettingsDBHelper';
import { Log } from '../Utils/Log';
import process from '@ohos.process';
import { DataSettingsKey, settingsDataConfig } from '../Utils/SettingsDataConfig';
import { GlobalContext } from '../Utils/GlobalContext';

interface IRequest {
  operation: string;
  columns: string[];
  predicates: dataSharePredicates.DataSharePredicates | relationalStore.RdbPredicates | null;
  value: relationalStore.ValuesBucket | null;
}

let rdbStore: relationalStore.RdbStore | undefined = undefined;
let requests: IRequest[] = [];
let ret: number = 0;
let err: BusinessError = { 'code': -1 } as BusinessError;

export default class UserDsExtAbility extends DataShareExtensionAbility {
  onCreate(want: Want) {
    console.info('[ttt] [DataShareTest] <<Extension>> DataShareExtAbility onCreate, want:' + want.abilityName);
    console.info('[ttt] [DataShareTest] <<Extension>> this.context:' + this.context);
    GlobalContext.getContext().setObject('abilityContext', this.context);
    this.context.area = contextConstant.AreaMode.EL2;
    this.context.area = SettingsDBHelper.getInstance().getArea();
    this.onInitialized();
    Log.info('onCreate  context' + JSON.stringify(this.context));
  }

  onInitialized() {
    Log.info('onInitialize getContext start');
    let context = GlobalContext.getContext().getObject('abilityContext') as Context;
    Log.info('onInitialize start context: ' + JSON.stringify(this.context));
    if (context != null) {
      SettingsDBHelper.getInstance().getRdbStore().then((rdb: relationalStore.RdbStore | undefined) => {
        Log.info(' onInitialized rdb:' + rdb);
        rdbStore = rdb;
        if (!rdbStore) {
          Log.error('onInitialized: get rdb store failed!');
          return;
        }
        Log.info(' onInitialized requests:' + JSON.stringify(requests));
        for (let i = 0; i < requests.length; i++) {
          if (requests[i]) {

            let opt: string = JSON.stringify(requests[i].operation);
            let columns = requests[i].columns;
            let predicates = requests[i].predicates as dataSharePredicates.DataSharePredicates;
            let value = requests[i].value;
            if (opt == 'insert') {
              rdbStore?.insert(settingsDataConfig.TABLE_NAME, value, (err, ret) => {
                Log.info('onInitialized insert ret: ' + ret);
              });
            } else if (opt == 'query') {
              if (predicates) {
                rdbStore?.query(settingsDataConfig.TABLE_NAME, predicates, columns, (err, resultSet) => {
                  Log.info('onInitialized query ret: ' + JSON.stringify(resultSet));
                });
              }
            } else if (opt == 'update') {
              if (value) {
                rdbStore?.update(settingsDataConfig.TABLE_NAME, value, predicates, (err, ret) => {
                  Log.info('onInitialized update ret: ' + ret);
                });
              }
            }
          }
        }
      }).catch((err: Error) => {
        Log.error('onInitialize failed:' + JSON.stringify(err));
      });
      Log.info('onInitialize end');
    } else {
      Log.info('onInitialize context error!');
    }
  }

  insert(uri: string, value: ValuesBucket, callback: AsyncCallback<number>) {
    Log.info('insert keyword = ' + value['KEYWORD'] + ' start:' + uri);
    let rdbInsert = (grantStatus: boolean) => {
      if (!grantStatus) {
        callback(err, ret);
        return;
      }
      this.doSystemSetting(value['KEYWORD'] == null ? '' : value['KEYWORD'].toString(),
        value['VALUE'] == null ? '' : value['VALUE'].toString());
      if (rdbStore == null) {
        let request: ValuesBucket = {
          'operation': 'insert', 'columns': null, 'predicates': null, value: JSON.stringify(value)
        };
        Log.info('insert request = ' + JSON.stringify(request));
        requests.push({
          operation: 'insert', columns: [], predicates: null, value: value
        });
        callback(err, ret);
      } else {
        rdbStore.insert(settingsDataConfig.TABLE_NAME, value, (err, ret) => {
          Log.info('insert before callback ');
          callback(err, ret);
          Log.info('insert after callback ');
          Log.info('insert result: ' + ret);
        });
      }
    };
    try {
      if (value['KEYWORD'] !== null && this.isTrustList((value['KEYWORD']).toString())) {
        Log.info('trustList data exists.');
        rdbInsert(true);
      } else {
        Log.info('Start to verify permissions.');
        this.verifyPermission(value, rdbInsert);
      }
    } catch (err) {
      Log.error('Insert Data error:' + JSON.stringify(err));
      callback(({
        code: -1
      } as BusinessError), 0);
    }
  }

  update(
    uri: string,
    predicates: dataSharePredicates.DataSharePredicates,
    value: ValuesBucket,
    callback: AsyncCallback<number>
  ) {
    Log.info('update keyword = ' + value['KEYWORD'] + ' start:' + uri);
    let rdbUpData = (grantStatus: boolean) => {
      if (!grantStatus) {
        callback(err, ret);
        return;
      }
      this.doSystemSetting(value['KEYWORD'] == null ? '' : value['KEYWORD'].toString(),
        value['VALUE'] == null ? '' : value['VALUE'].toString());
      if (rdbStore == null) {
        let request: IRequest = {
          operation: 'update', columns: [], predicates: predicates, value: value
        };
        Log.info('update request = ' + JSON.stringify(request));
        requests.push(request);
        callback(err, ret);
      } else {
        rdbStore.update(settingsDataConfig.TABLE_NAME, value, predicates, (err, ret) => {
          Log.info('update before callback ' + JSON.stringify(err));
          callback(err, ret);
          Log.info('update after callback ' + JSON.stringify(ret));
          Log.info('update result: ' + ret);
        });
      }
    };
    try {
      if (value['KEYWORD'] !== null && this.isTrustList(value['KEYWORD'].toString())) {
        Log.info('trustList data exists.');
        rdbUpData(true);
      } else {
        Log.info('Start to verify permissions.');
        this.verifyPermission(value, rdbUpData);
      }
    } catch (err) {
      Log.error('upData error:' + JSON.stringify(err));
      callback(err, ret);
    }
  }

  delete(uri: string, predicates: dataSharePredicates.DataSharePredicates, callback: AsyncCallback<number>) {
    Log.info('nothing to do');
  }

  query(
    uri: string,
    predicates: dataSharePredicates.DataSharePredicates,
    columns: string[],
    callback: AsyncCallback<Object>
  ) {
    Log.info('query start uri:' + uri);
    if (rdbStore == null) {
      let request: IRequest = {
        operation: 'query', columns: columns, predicates: predicates, value: null
      };
      Log.info('query request = ' + JSON.stringify(request));
      requests.push(request);
      callback(err, { '_napiwrapper': {} });
    } else {
      rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, columns,
        (err: BusinessError, resultSet: relationalStore.ResultSet) => {
          Log.info('query before callback err:' + JSON.stringify(err) + ' ResultSet' + JSON.stringify(resultSet));
          callback(err, { '_napiwrapper': resultSet });
          Log.info('query after callback ');
          Log.info('query result: ' + JSON.stringify(resultSet.rowCount) + 'columnNames' +
            JSON.stringify(resultSet.columnNames));
        });
    }
  }


  doSystemSetting(settingsKey: string | undefined, settingsValue: string | undefined) {
    switch (settingsKey) {
      case DataSettingsKey.SETTINGS_AUDIO_RINGTONE: {
        try {
          let volumeType = audio.AudioVolumeType.RINGTONE;
          Log.info('settings RINGTONE start');
          audio.getAudioManager().setVolume(volumeType, Number(settingsValue)).then(() => {
            Log.info('settings Promise returned to indicate a successful RINGTONE setting.');
          });
        } catch (err) {
          Log.error('settings RINGTONE failed error = ' + JSON.stringify(err));
        }
        break;
      }
      case DataSettingsKey.SETTINGS_AUDIO_MEDIA: {
        try {
          let volumeType = audio.AudioVolumeType.MEDIA;
          Log.info('settings MEDIA start');
          audio.getAudioManager().setVolume(volumeType, Number(settingsValue)).then(() => {
            Log.info('settings Promise returned to indicate a successful MEDIA setting.');
          });
        } catch (err) {
          Log.info('settings MEDIA failed error = ' + JSON.stringify(err));
        }
        break;
      }
      case DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL: {
        try {
          let volumeType = audio.AudioVolumeType.VOICE_CALL;
          Log.info('settings VOICE_CALL start');
          audio.getAudioManager().setVolume(volumeType, Number(settingsValue)).then(() => {
            Log.info('settings Promise returned to indicate a successful VOICE_CALL setting.');
          });
        } catch (err) {
          Log.info('settings VOICE_CALL failed error = ' + JSON.stringify(err));
        }
        break;
      }
      case settings.general.DEVICE_NAME: {
        try {
          let result = bluetooth.setLocalName(settingsValue);
          Log.info('settings bluetooth_name res = ' + result);
        } catch (err) {
          Log.info('settings bluetooth_name failed, error = ' + JSON.stringify(err));
        }
        break;
      }
      default: {
        Log.info(settingsKey + ' key is not brightness or audio or deviceName');
      }
    }
  }

  verifyPermission(value: relationalStore.ValuesBucket, callBack: (val: boolean) => void) {
    if (this.isTrustList(
      value[settingsDataConfig.FIELD_KEYWORD] as string) || process.uid == rpc.IPCSkeleton.getCallingUid()) {
      callBack(true);
      return;
    }
    try {
      let tokenID = rpc.IPCSkeleton.getCallingTokenId();
      Log.info('tokenID = ' + tokenID);
      let grantStatus = abilityAccessCtrl.createAtManager()
        .verifyAccessToken(tokenID, 'ohos.permission.MANAGE_SECURE_SETTINGS');
      grantStatus.then(data => {
        if (data == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          Log.info('MANAGE_SECURE_SETTINGS active');
          callBack(true);
        } else {
          Log.warn('MANAGE_SECURE_SETTINGS grantStatus= ' + JSON.stringify(data));
          callBack(false);
        }
      }).catch((err: BusinessError) => {
        Log.error('tokenID = ' + tokenID + ' verifyAccessToken is failed: ' + JSON.stringify(err));
        callBack(false);
      });
    } catch (err) {
      Log.error('err = ' + JSON.stringify(err));
      callBack(false);
    }
  }

  isTrustList(keyWord: string) {
    let trustList: string[] = [
      settings.display.SCREEN_BRIGHTNESS_STATUS,
      settings.display.AUTO_SCREEN_BRIGHTNESS,
      settings.display.SCREEN_OFF_TIMEOUT
    ];
    return trustList.includes(keyWord);
  }
}
