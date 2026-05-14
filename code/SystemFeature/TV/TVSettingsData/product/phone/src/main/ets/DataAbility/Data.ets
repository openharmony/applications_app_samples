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
import { bluetooth } from '@kit.ConnectivityKit';
import { dataAbility } from '@kit.ArkData';
import featureAbility from '@ohos.ability.featureAbility';
import { settings } from '@kit.BasicServicesKit';
import SettingsDataConfig from '../Utils/SettingsDataConfig';
import SettingsDBHelper from '../Utils/SettingsDBHelper';
import { Log } from '../Utils/Log';

import { rpc } from '@kit.IPCKit';
import { abilityAccessCtrl } from '@kit.AbilityKit';

let rdbStore;
let requests: any[] = [];

function doSystemSetting(settingsKey: string, settingsValue: string) {
  switch (settingsKey) {
    case SettingsDataConfig.SettingsKey.SETTINGS_AUDIO_RINGTONE: {
      try {
        let volumeType = audio.AudioVolumeType.RINGTONE;
        Log.I('settings RINGTONE start');
        audio.getAudioManager().setVolume(volumeType, parseInt(settingsValue)).then(() => {
          Log.I('settings Promise returned to indicate a successful RINGTONE setting.');
        });
      } catch (err) {
        Log.I('settings RINGTONE failed error = ' + JSON.stringify(err));
      }
      break;
    }
    case SettingsDataConfig.SettingsKey.SETTINGS_AUDIO_MEDIA: {
      try {
        let volumeType = audio.AudioVolumeType.MEDIA;
        Log.I('settings MEDIA start');
        audio.getAudioManager().setVolume(volumeType, parseInt(settingsValue)).then(() => {
          Log.I('settings Promise returned to indicate a successful MEDIA setting.');
        });
      } catch (err) {
        Log.I('settings MEDIA failed error = ' + JSON.stringify(err));
      }
      break;
    }
    case SettingsDataConfig.SettingsKey.SETTINGS_AUDIO_VOICE_CALL: {
      try {
        let volumeType = audio.AudioVolumeType.VOICE_CALL;
        Log.I('settings VOICE_CALL start');
        audio.getAudioManager().setVolume(volumeType, parseInt(settingsValue)).then(() => {
          Log.I('settings Promise returned to indicate a successful VOICE_CALL setting.');
        });
      } catch (err) {
        Log.I('settings VOICE_CALL failed error = ' + JSON.stringify(err));
      }
      break;
    }
    case settings.general.DEVICE_NAME: {
      try {
        let result = bluetooth.setLocalName(settingsValue);
        Log.I('settings bluetooth_name res = ' + result);
      } catch (err) {
        Log.I('settings bluetooth_name failed, error = ' + JSON.stringify(err));
      }
      break;
    }
    default: {
      Log.I(settingsKey + ' key is not brightness or audio or deviceName');
    }
  }
}

function verifyPermission(callBack) {
  try {
    let tokenID = rpc.IPCSkeleton.getCallingTokenId();
    Log.I('tokenID = ' + tokenID);
    let grantStatus = abilityAccessCtrl.createAtManager()
      .verifyAccessToken(tokenID, 'ohos.permission.MANAGE_SECURE_SETTINGS');
    grantStatus.then(data => {
      if (data == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        Log.I('MANAGE_SECURE_SETTINGS active');
        callBack(true);
      } else {
        Log.W('MANAGE_SECURE_SETTINGS grantStatus= ' + JSON.stringify(data));
        callBack(false);
      }
    }).catch((err) => {
      Log.E('tokenID = ' + tokenID + ' verifyAccessToken is failed: ' + JSON.stringify(err));
      callBack(false);
    });
  } catch (err) {
    Log.E('err = ' + JSON.stringify(err));
    callBack(false);
  }
}

function isTrustList(keyWord: string) {
  let ret = -1;
  let trustList: string[] = [
    settings.display.SCREEN_BRIGHTNESS_STATUS,
    settings.display.AUTO_SCREEN_BRIGHTNESS,
    settings.display.SCREEN_OFF_TIMEOUT
  ];
  ret = trustList.findIndex((trustItem) => {
    return trustItem === keyWord;
  });
  return ret != -1;
}

export default {
  onInitialized(abilityInfo) {
    Log.I('onInitialize getContext start');
    let context = featureAbility.getContext();
    globalThis.abilityContext = context;
    if (context != null) {
      SettingsDBHelper.getInstance().getRdbStore().then((rdb: any) => {
        Log.I(' onInitialized rdb：' + rdb);
        rdbStore = rdb;
        Log.I(' onInitialized requests：' + JSON.stringify(requests));
        for (let i = 0; i < requests.length; i++) {
          let opt: string = requests[i]['operation'];
          let columns = requests[i]['columns'];
          let predicates = requests[i]['predicates'];
          let value = requests[i]['value'];
          if (opt == 'insert') {
            rdbStore.insert(SettingsDataConfig.TABLE_NAME, value, function (err, ret) {
              Log.I('onInitialized insert ret: ' + ret);
            });
          } else if (opt == 'query') {
            let rdbPredicates = dataAbility.createRdbPredicates(SettingsDataConfig.TABLE_NAME, predicates);
            rdbStore.query(rdbPredicates, columns, function (err, resultSet) {
              Log.I('onInitialized query ret: ' + JSON.stringify(resultSet));
            });
          } else if (opt == 'update') {
            let rdbPredicates = dataAbility.createRdbPredicates(SettingsDataConfig.TABLE_NAME, predicates);
            rdbStore.update(value, rdbPredicates, function (err, ret) {
              Log.I('onInitialized update ret: ' + ret);
            });
          }
        }
      }).catch(err => {
        Log.I('onInitialize failed');
      });
      Log.I('onInitialize end');
    } else {
      Log.I('onInitialize context error!');
    }
  },

  insert(uri, value, callback) {
    Log.I('insert keyword = ' + value['KEYWORD'] + ' start:' + uri);
    let rdbInsert = (grantStatus) => {
      if (!grantStatus) {
        callback(-1, 0);
        return;
      }
      doSystemSetting(value['KEYWORD'], value['VALUE']);
      if (rdbStore == null) {
        let request = {
          'operation': 'insert', 'columns': null, 'predicates': null, value: value
        };
        Log.I('insert request = ' + JSON.stringify(request));
        requests.push(request);
        callback(-1, 0);
      } else {
        rdbStore.insert(SettingsDataConfig.TABLE_NAME, value, function (err, ret) {
          Log.I('insert before callback ');
          callback(err, ret);
          Log.I('insert after callback ');
          Log.I('insert result: ' + ret);
        });
      }
    };

    try {
      if (isTrustList(value['KEYWORD'])) {
        Log.I('trustList data exists.');
        rdbInsert(true);
      } else {
        Log.I('Start to verify permissions.');
        verifyPermission(rdbInsert);
      }
    } catch (err) {
      Log.E('Insert Data error:' + JSON.stringify(err));
      callback(-1, 0);
    }
  },

  query(uri, columns, predicates, callback) {
    Log.I('query start uri:' + uri);
    if (rdbStore == null) {
      let request = {
        'operation': 'query', 'columns': columns, 'predicates': predicates, value: ''
      };
      Log.I('query request = ' + JSON.stringify(request));
      requests.push(request);
      callback(-1, {
        '_napiwrapper': {} as object
      });
    } else {
      let rdbPredicates = dataAbility.createRdbPredicates(SettingsDataConfig.TABLE_NAME, predicates);
      rdbStore.query(rdbPredicates, columns, function (err, resultSet) {
        Log.I('query before callback err:' + JSON.stringify(err) + ' ResultSet' + JSON.stringify(resultSet));
        callback(err, { '_napiwrapper': resultSet });
        Log.I('query after callback ');
        Log.I('query result: ' + JSON.stringify(resultSet));
      });
    }
  },

  update(uri, value, predicates, callback) {
    Log.I('update keyword = ' + value['KEYWORD'] + ' start:' + uri);
    let rdbUpData = (grantStatus) => {
      if (!grantStatus) {
        callback(-1, 0);
        return;
      }
      doSystemSetting(value['KEYWORD'], value['VALUE']);
      if (rdbStore == null) {
        let request = {
          'operation': 'update', 'columns': null, 'predicates': predicates, value: value
        };
        Log.I('update request = ' + JSON.stringify(request));
        requests.push(request);
        callback(-1, 0);
      } else {
        let rdbPredicates = dataAbility.createRdbPredicates(SettingsDataConfig.TABLE_NAME, predicates);
        rdbStore.update(value, rdbPredicates, function (err, ret) {
          Log.I('update before callback ' + JSON.stringify(err));
          callback(err, ret);
          Log.I('update after callback ' + JSON.stringify(ret));
          Log.I('update result: ' + ret);
        });
      }
    };

    try {
      if (isTrustList(value['KEYWORD'])) {
        Log.I('trustList data exists.');
        rdbUpData(true);
      } else {
        Log.I('Start to verify permissions.');
        verifyPermission(rdbUpData);
      }
    } catch (err) {
      Log.E('upData error:' + JSON.stringify(err));
      callback(-1, 0);
    }
  }
};
