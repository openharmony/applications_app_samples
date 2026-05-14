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
import { commonEventManager, StaticSubscriberExtensionAbility } from '@kit.BasicServicesKit';
import { Log, CommonEventData} from '../Utils/Log';
import SettingsDBHelper from '../Utils/SettingsDBHelper';
import { IContent, TableType } from '../common/Common';
import { GlobalContext } from '../Utils/GlobalContext';
import { settingsDataConfig } from '../Utils/SettingsDataConfig';

const CURRENT_USER_TABLE_DROP: string = `DROP TABLE IF EXISTS ${settingsDataConfig.USER_TABLE_NAME}_`;
const CURRENT_SECURE_USER_TABLE_DROP: string = `DROP TABLE IF EXISTS ${settingsDataConfig.SECURE_TABLE_NAME}_`;
const TAG: string = 'UserChangeStaticSubscriber : ';

export default class UserChangeStaticSubscriber extends StaticSubscriberExtensionAbility {
  private init() {
    Log.info('UserChangeStaticSubscriber start');
    GlobalContext.getContext().setObject('abilityContext', this.context);
    this.context.area = SettingsDBHelper.getInstance().getArea();
  }
  async onReceiveEvent(event: CommonEventData) {
    if (!event || !event.code) {
      Log.error('invalid parameters');
      return;
    }
    Log.info(`onReceiveEvent, event: ${event.event}, userId: ${event.code}`);

    this.init();
    let rdb = await SettingsDBHelper.getInstance().getRdbStore();
    switch (event.event) {
      case commonEventManager.Support.COMMON_EVENT_USER_ADDED:
        // 鍒涘缓瀵瑰簲鐢ㄦ埛鐨勬暟鎹〃
        await rdb?.executeSql(SettingsDBHelper.CURRENT_USER_TABLE_CREATE_PREFIX + event.code +
        SettingsDBHelper.TABLE_CREATE_SUFFIX, []);
        await rdb?.executeSql(SettingsDBHelper.CURRENT_SECURE_TABLE_CREATE_PREFIX + event.code +
        SettingsDBHelper.TABLE_CREATE_SUFFIX, []);
        Log.info('create settings data table success!');
        // 鍔犺浇鐢ㄦ埛鏁版嵁琛ㄧ殑榛樿鍊?
        try {
          let content = await SettingsDBHelper.getInstance().readDefaultFile() as IContent;
          if (!content) {
            Log.error('readDefaultFile is failed!');
            return
          }
          // 鍒濆鍖栫敤鎴疯〃鏁版嵁
          await SettingsDBHelper.getInstance().initialInsert(settingsDataConfig.USER_TABLE_NAME + '_' + event.code);
          await SettingsDBHelper.getInstance().initialInsert(settingsDataConfig.SECURE_TABLE_NAME + '_' + event.code);
          // 鐢ㄦ埛鏁版嵁琛ㄥ寘鍚玌SER銆乁SER_SECURE
          await SettingsDBHelper.getInstance().loadTableData({ settings: content.settings,
            user: content.user,
            userSecure: content.userSecure }, TableType.USER, event.code as number);
          await SettingsDBHelper.getInstance().loadTableData({ settings: content.settings,
            user: content.user,
            userSecure: content.userSecure }, TableType.USER_SECURE, event.code as number);
        } catch (err) {
          Log.error('loadDefaultSettingsData failed! err = ' + err);
        }
        break
      case commonEventManager.Support.COMMON_EVENT_USER_REMOVED:
        // 鍒犻櫎瀵瑰簲鐢ㄦ埛鏁版嵁琛?
        rdb?.executeSql(CURRENT_USER_TABLE_DROP + event.code, []);
        rdb?.executeSql(CURRENT_SECURE_USER_TABLE_DROP + event.code, []);
        break
      default:
        break
    }
  }
}