/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import dlpPermission from '@ohos.dlpPermission';
import fs from '@ohos.file.fs';
import account from '@ohos.account.distributedAccount'
import account_osAccount from '@ohos.account.osAccount';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { PreferencesManager } from '../feature/PreferencesManager';
import Logger from '../util/Logger';

const TAG: string = 'DlpManager';
const SOURCEURI: string = 'file://docs/storage/Users/currentUser';
let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
let accountAbility = account.getDistributedAccountAbility();
// 用户列表
let userList: Array<dlpPermission.AuthUser> = [{
  'authAccount': '123@ohos.com',
  'authAccountType': dlpPermission.AccountType.CLOUD_ACCOUNT,
  'dlpFileAccess': dlpPermission.DLPFileAccess.READ_ONLY,
  // 授权到期时间戳
  'permExpiryTime': 8888520175,
}, {
  'authAccount': '456@ohos.com',
  'authAccountType': dlpPermission.AccountType.CLOUD_ACCOUNT,
  'dlpFileAccess': dlpPermission.DLPFileAccess.FULL_CONTROL,
  // 授权到期时间戳
  'permExpiryTime': 8888520175,
}]

// dlp信息类型
export class TestDlpFileInfo {
  plaintextPath: string = '';
  ciphertextPath: string = '';
}

// 用户信息类型
interface UserInfo {
  name: string,
  id: string,
  event: string,
  nickname: string,
  avatar: string
}

export class DlpManager {
  // linkFile文件名
  private linkFileName: string = '';
  // link地址文件名
  private linkFilePath: string = '';
  // dlp文件
  private dlpFile: dlpPermission.DLPFile = {} as dlpPermission.DLPFile;
  // 沙箱包名
  private sandboxBundleName: string = 'com.example.fileEdit';
  private sandboxAbilityName: string = 'EntryAbility';
  // dlp文件的句柄
  private dlpFd: number = -1;
  // 账号信息
  private accountInfo?: account_osAccount.OsAccountInfo;
  // dlp文件路径地址
  private dlpFileUri: string = '';
  private preferencesManager: PreferencesManager = new PreferencesManager();

  constructor() {
  }

  // 获取用户id
  async getUserId(): Promise<number> {
    let accountMgr = account_osAccount.getAccountManager();
    return await accountMgr.getOsAccountLocalIdFromProcess();
  }

  // 获取帐号信息
  async getOsAccountInfo(): Promise<account_osAccount.OsAccountInfo> {
    let accountMgr = account_osAccount.getAccountManager();
    return await accountMgr.getCurrentOsAccount();
  }

  // 获取AuthPerm
  getAuthPerm(accountName: string, dlpProperty: dlpPermission.DLPProperty): dlpPermission.DLPFileAccess {
    let perm: dlpPermission.DLPFileAccess = dlpPermission.DLPFileAccess.NO_PERMISSION;
    if (accountName === dlpProperty.ownerAccount) {
      return dlpPermission.DLPFileAccess.FULL_CONTROL;
    }
    if ((dlpProperty.everyoneAccessList !== undefined) && (dlpProperty.everyoneAccessList.length > 0)) {
      perm = Math.max(...dlpProperty.everyoneAccessList);
    }
    let authUserList = dlpProperty.authUserList ?? [];
    for (let i = 0; i < authUserList.length; ++i) {
      let authUser = authUserList[i];
      if (authUser.authAccount === accountName) {
        return authUser.dlpFileAccess;
      }
    }
    return perm;
  }

  // 帐号登录
  async AccountLogin(accountName: string) {
    Logger.info('AccountLogin start');
    await this.AccountLogout();
    let info: UserInfo = {
      name: '',
      id: '1234',
      event: 'Ohos.account.event.LOGIN',
      nickname: 'nickname',
      avatar: 'avatar'
    };
    info.name = accountName;
    info.event = 'Ohos.account.event.LOGIN';
    try {
      await accountAbility.setOsAccountDistributedInfo(info);
    } catch (err) {
      console.error(TAG, `setOsAccountDistributedInfo LOGIN failed${err.code}, message:${err.message}`);
      return
    }
    let user = await accountAbility.getOsAccountDistributedInfo();
    Logger.info(`CurrentMessage is ${JSON.stringify(user)}`);
  }

  // 帐号登出
  async AccountLogout() {
    Logger.info('AccountLogout start');
    let accountInfo = await accountAbility.getOsAccountDistributedInfo();
    let info: UserInfo = {
      name: '',
      id: '1234',
      event: 'Ohos.account.event.LOGIN',
      nickname: 'nickname',
      avatar: 'avatar'
    }
    if (accountInfo.name === 'ohosAnonymousName') {
      return
    }
    info.name = accountInfo.name
    info.event = 'Ohos.account.event.LOGOUT'
    await accountAbility.setOsAccountDistributedInfo(info);
    Logger.info('AccountLogout end');
  }

  // 生成可选参数的DLP策略
  async genTestOptionalDlpProperty(): Promise<dlpPermission.DLPProperty> {
    let accountInfo = await this.getOsAccountInfo();
    let property: dlpPermission.DLPProperty = {
      'ownerAccount': accountInfo.distributedInfo.name,
      'ownerAccountID': accountInfo.distributedInfo.id,
      'ownerAccountType': dlpPermission.AccountType.CLOUD_ACCOUNT,
      'contactAccount': accountInfo.distributedInfo.name,
      'offlineAccess': true,
    };
    return property;
  }

  // 生成DLP策略
  async genTestDlpProperty(): Promise<dlpPermission.DLPProperty> {
    this.accountInfo = await this.getOsAccountInfo();
    let property: dlpPermission.DLPProperty = {
      'ownerAccount': this.accountInfo.distributedInfo.name,
      'ownerAccountID': this.accountInfo.distributedInfo.id,
      'ownerAccountType': dlpPermission.AccountType.CLOUD_ACCOUNT,
      'authUserList': userList,
      'contactAccount': this.accountInfo.distributedInfo.name,
      'offlineAccess': true,
      'everyoneAccessList': [dlpPermission.DLPFileAccess.READ_ONLY],
    };
    return property;
  }

  // 启动沙箱应用
  startSandboxApp(): void {
    let want: Want = {
      bundleName: this.sandboxBundleName,
      abilityName: this.sandboxAbilityName,
      uri: this.linkFilePath,
      parameters: {
        'linkFileName': {
          'name': this.linkFileName
        },
        'uri': this.linkFilePath,
        'dlpUri': {
          'name': this.dlpFileUri
        },
      }
    };
    context.startAbility(want, (err) => {
      Logger.info()
    });
  }

  // 生成测试DLP文件
  async genTestDlpFile(plaintextPath: string, ciphertextFd: number, displayName: string, currentPerssion: number, dlpFileInfos: Array<TestDlpFileInfo>) {
    Logger.info('GenTestDlpFile start');
    let file: fs.File = fs.openSync(plaintextPath, fs.OpenMode.READ_WRITE);
    this.dlpFd = ciphertextFd;
    this.dlpFileUri = `${SOURCEURI}/${displayName}`;
    let fileInfo: TestDlpFileInfo = new TestDlpFileInfo();
    fileInfo.plaintextPath = plaintextPath;
    fileInfo.ciphertextPath = this.dlpFileUri;
    dlpFileInfos.push(fileInfo);
    AppStorage.set<Array<TestDlpFileInfo>>('dlpFileInfos', dlpFileInfos);
    await this.preferencesManager.putDlpFileInfos(dlpFileInfos);
    Logger.info(`file.fd:${file.fd},dlpFd:${this.dlpFd}`);
    let property = await this.genTestDlpProperty();
    property.everyoneAccessList = [currentPerssion + 1];
    Logger.info(`everyoneList ${JSON.stringify(property.everyoneAccessList)},current`);
    try {
      this.dlpFile = await dlpPermission.generateDLPFile(file.fd, this.dlpFd, property);
      if (await dlpPermission.isDLPFile(this.dlpFd)) {
        Logger.info(`generateDLPFile success`);
      } else {
        Logger.info(`generateDLPFile fail`);
      }
      this.dlpFile.closeDLPFile();
    }

    catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error(`generateDLPFile failed, errCode:${error.code},message:${error.message}`);
      fs.closeSync(file.fd);
      fs.closeSync(this.dlpFd);
    }
  }
}


