/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import distributedAccount from '@ohos.account.distributedAccount';
import Account from '../common/database/Account';
import DatabaseUtils from '../common/utils/DatabaseUtils';
import Logger from './Logger';

const TAG: string = `[DistributedAccountModel]`

let accountAbility: distributedAccount.DistributedAccountAbility = distributedAccount.getDistributedAccountAbility();

export default class DistributedAccountModel {
  bind(localId, distributedAccountName, distributedAccountNickName, distributedAccountAvatar): Promise<void> {
    return new Promise((resolve, reject) => {
      let accountInfo = {
        // 随机生成帐号id
        id: Math.floor(Math.random() * 10000 + 1000).toString(),
        name: distributedAccountName,
        nickname: distributedAccountNickName,
        avatar: distributedAccountAvatar,
        event: 'Ohos.account.event.LOGIN'
      };
      try {
        accountAbility.setOsAccountDistributedInfoByLocalId(localId, accountInfo).then(() => {
          // 插入到数据表
          let account = new Account()
          account.distributedAccountName = accountInfo.name
          account.distributedAccountID = accountInfo.id
          account.localId = localId
          DatabaseUtils.insertAccount(account, globalThis.rdbStore)
          Logger.info(TAG, 'setOsAccountDistributedInfoByLocalId  Success');
          resolve()
        }).catch((err) => {
          Logger.error(TAG, "setOsAccountDistributedInfoByLocalId  err: " + JSON.stringify(err));
          reject(err)
        });
      } catch (e) {
        Logger.error(TAG, "setOsAccountDistributedInfoByLocalId  exception: " + e);
        reject(e)
      }
    })
  }

  unBind(localId, distributedAccountID, distributedAccountName): Promise<void> {
    return new Promise((resolve, reject) => {
      let accountInfo = {
        id: distributedAccountID,
        name: distributedAccountName,
        event: 'Ohos.account.event.LOGOUT'
      };
      try {
        accountAbility.setOsAccountDistributedInfoByLocalId(localId, accountInfo).then(() => {
          // 从数据表中删除
          DatabaseUtils.deleteAccountData(localId, globalThis.rdbStore)
          Logger.info(TAG, 'setOsAccountDistributedInfoByLocalId successfully');
          resolve()
        }).catch((err) => {
          Logger.error(TAG, "setOsAccountDistributedInfoByLocalId exception: " + JSON.stringify(err));
          reject(err)
        });
      } catch (e) {
        Logger.error(TAG, "setOsAccountDistributedInfoByLocalId exception: " + e);
        reject(e)
      }
    })
  }

  getOsAccountDistributedInfo(): Promise<distributedAccount.DistributedInfo> {
    return new Promise((resolve, reject) => {
      try {
        accountAbility.getOsAccountDistributedInfo().then((data) => {
          Logger.info(TAG, "getOsAccountDistributedInfo data: " + JSON.stringify(data));
          resolve(data)
        }).catch((err) => {
          Logger.error(TAG, "getOsAccountDistributedInfo err: " + JSON.stringify(err));
          reject(err)
        });
      } catch (e) {
        Logger.error(TAG, "getOsAccountDistributedInfo exception: " + JSON.stringify(e));
        reject(e)
      }
    })
  }

  getOsAccountDistributedInfoByLocalId(localId: number): Promise<distributedAccount.DistributedInfo> {
    return new Promise((resolve, reject) => {
      try {
        accountAbility.getOsAccountDistributedInfoByLocalId(localId).then((data) => {
          Logger.info(TAG, 'distributed information: ' + JSON.stringify(data));
          resolve(data)
        }).catch((err) => {
          Logger.error(TAG, 'getOsAccountDistributedInfoByLocalId exception: ' + JSON.stringify(err));
          reject(err)
        });
      } catch (e) {
        Logger.error(TAG, 'getOsAccountDistributedInfoByLocalId exception: ' + JSON.stringify(e));
        reject(e)
      }
    })
  }
}