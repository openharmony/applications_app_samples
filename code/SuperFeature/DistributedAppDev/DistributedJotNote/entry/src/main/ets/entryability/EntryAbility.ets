/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import wantConstant from '@ohos.app.ability.wantConstant';
import distributedObject from '@ohos.data.distributedDataObject';
import { BusinessError } from '@ohos.base';
import commonType from '@ohos.data.commonType';
import Logger from '../utils/Logger';
import { LooperUtil } from '../utils/LooperUtil';
import CommonConstants from '../common/constants/CommonConstants';

const TAG = 'testTag_ability: ';

class SourceObject {
  notesTitle?: string;
  asset?: commonType.Asset;

  constructor(notesTitle: string) {
    this.notesTitle = notesTitle;
    this.asset = {
      name: CommonConstants.DISTRIBUTED_ASSET_NAME,
      uri: CommonConstants.DISTRIBUTED_ASSET_URI,
      path: CommonConstants.DISTRIBUTED_ASSET_PATH,
      createTime: CommonConstants.DISTRIBUTED_ASSET_CREATE_TIME,
      modifyTime: CommonConstants.DISTRIBUTED_ASSET_MODIFY_TIME,
      size: CommonConstants.DISTRIBUTED_ASSET_SIZE
    };
  }
}

export default class EntryAbility extends UIAbility {
  contentStorage?: LocalStorage;
  sessionId?: string;
  d_object?: distributedObject.DataObject;

  //获取当前应用的权限的授予状态：grantStatus（授予返回：0，未授予：-1）
  async checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = -1;

    //获取tokenId:
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (err) {
      Logger.error(TAG, `Failed to get bundle info for self,cause ${JSON.stringify(err)}`);
    }

    // 检验应用是否被授予此权限，授予返回：PERMISSION_GRANTED = 0，未授予：PERMISSION_DENIED = -1
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (err) {
      Logger.error(TAG, `Failed to get bundle info for self,cause', ${JSON.stringify(err)}`);
    }

    return grantStatus;
  }

  //检验权限授予情况&动态申请权限
  async checkPermissions(): Promise<void> {
    const permissions: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC'];

    let grantStatus: abilityAccessCtrl.GrantStatus = await this.checkAccessToken(permissions[0]);
    // 检验权限授予情况
    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      //已授予
      Logger.info(TAG, 'Permission already granted.');
    } else {
      //未授予,向用户弹框动态申请授权
      let atManager = abilityAccessCtrl.createAtManager();
      try {
        atManager.requestPermissionsFromUser(this.context, ['ohos.permission.DISTRIBUTED_DATASYNC'], (err, data) => {
          Logger.info(TAG, `data: ${JSON.stringify(data)}`);
          Logger.info(TAG, `data: data.permissions ${JSON.stringify(data.permissions)}`);
          Logger.info(TAG, `data: data.authResults ${JSON.stringify(data.authResults)}`);
        });
      } catch (err) {
        Logger.error(TAG, `catch err , ${JSON.stringify(err)}`);
        return;
      }
    }
  }

  /**
   * 处理流转中目标端的数据
   *
   * @param want 发起方传入的want参数
   * @param launchParam
   */
  handleContinueParam(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 迁移应用启动时（onCreate）&应用热启动时（onNewWant）:恢复保存的迁移数据
    if (launchParam.launchReason == AbilityConstant.LaunchReason.CONTINUATION) {
      // 从want中恢复迁移数据
      let isContinuation = want?.parameters?.isContinuation; // 是否迁移的标志
      let isSelectImg = want?.parameters?.isSelectImg; // 是否从图库中选择图片并写入到分布式文件路径中
      let swiperIndex = want?.parameters?.swiperIndex; // 对端变化后的swiper的index
      let inputTextArea = want?.parameters?.inputTextArea; // 对端变化后的notes多行文本
      let ability_isON = want?.parameters?.ability_isON; // 对端变化后的toggle：迁移能力的isON状态信息
      let pageStack_isON = want?.parameters?.pageStack_isON; // 对端变化后的toggle：迁移页面栈的 isON 状态信息
      let sourceEnd_isON = want?.parameters?.sourceEnd_isON; // 对端变化后的toggle：迁移后源端退出的isON状态信息
      let image2Path = want?.parameters?.image2Path;
      let testDate = want?.parameters?.testDate;

      AppStorage.setOrCreate<boolean>('isContinuation', isContinuation as boolean);
      AppStorage.setOrCreate<boolean>('isSelectImg', isSelectImg as boolean);
      AppStorage.setOrCreate<number>('swiperIndex', swiperIndex as number);
      AppStorage.setOrCreate<string>('inputTextArea', inputTextArea as string);
      AppStorage.setOrCreate<boolean>('ability_isON', ability_isON as boolean);
      AppStorage.setOrCreate<boolean>('pageStack_isON', pageStack_isON as boolean);
      AppStorage.setOrCreate<boolean>('sourceEnd_isON', sourceEnd_isON as boolean);
      AppStorage.setOrCreate<string>('image2Path', image2Path as string);
      AppStorage.setOrCreate<string>('testDate', testDate as string);

      //显式调用页面恢复
      this.contentStorage = new LocalStorage();
      Logger.info(TAG, 'handleContinueParam() ： ready to restore');
      this.context.restoreWindowStage(this.contentStorage);

      // 从分布式对象中恢复迁移数据
      this.getDistributedObject(want);
    }
  }

  /**
   * 从分布式对象中恢复迁移数据
   *
   * @param want 发起方传入的want参数
   */
  async getDistributedObject(want: Want) {
    if (!want.parameters) {
      return;
    }
    // 从want中恢复sessionId
    this.sessionId = want?.parameters?.session as string;
    Logger.info(TAG, `etDistributedObject() : continuation sessionId: ${this.sessionId},
      version = ${want?.parameters?.version}`);
    // 每次创建分布式对象时，先将上一次的对象置空
    if (this.d_object) {
      this.d_object = undefined;
    }
    // 创建分布式对象
    let source: SourceObject = new SourceObject('');
    this.d_object = distributedObject.create(this.context, source);

    if (this.d_object != undefined) {
      Logger.info(TAG, 'getDistributedObject() :this.d_object != null');

      this.d_object['notesTitle'] = undefined;
      this.d_object['asset'] = undefined;

      this.d_object.on('status', (sessionId: string, networkId: string, status: "online" | "offline" | "restored") => {
        if (status !== 'restored') {
          Logger.info(TAG, `status: ${status}`);
          return;
        }
        Logger.info(TAG, ` status == restored`);
        let image2Path = AppStorage.get<string>('image2Path');
        if (image2Path) {
          Logger.info(TAG, ` image2Path: ${image2Path}`);
          LooperUtil.emit(CommonConstants.EVENT_DATA_RESTORE);
        } else {
          Logger.info(TAG, ` image2Path == undefined`);
        }
        // 应用冷启动时先给组件属性赋初值\热启动时恢复分布式数据对象的值到双向绑定的'inputText'中
        if (this.d_object !== undefined && this.d_object['notesTitle']) {
          AppStorage.setOrCreate<string>('inputText', this.d_object['notesTitle']);
          Logger.info(TAG, `getDistributedObject() : d_object_notesTitle: ${this.d_object['notesTitle']}`);
        }
      });

      // 设置同步的sessionID,从want中获取同一个sessionID(可信组网中的多个设备间的对象如果设置为同一个sessionId，就能自动同步数据到远端设备)
      await this.d_object.setSessionId(this.sessionId, (): void => {
        Logger.info(TAG, 'join session');
      });
    }
  }

  /**
   *
   * @param want
   * @param launchParam
   */

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info(TAG, 'onCreate : Ability onCreate');

    //当应用创建时申请迁移权限
    this.checkPermissions();

    // 调用原因为迁移时，设置状态为可迁移，应对冷启动情况(保证迁移连续性)
    if (launchParam.launchReason == AbilityConstant.LaunchReason.CONTINUATION) {
      this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
        Logger.info(TAG, `setMissionContinueState ACTIVE result: ${JSON.stringify(result)}`);
      });
    }

    // 迁移应用启动时恢复保存的迁移数据
    this.handleContinueParam(want, launchParam);

    // 初始化时：默认迁移页面栈&源端退出
    PersistentStorage.persistProp('pageStack_isON', true);
    PersistentStorage.persistProp('sourceEnd_isON', true);
  }

  onContinue(wantParam: Record<string, Object>) {
    Logger.info(TAG, 'onContinue : wantParam.version,wantParam.targetDevice : ' + wantParam.version + wantParam.targetDevice);

    AppStorage.setOrCreate('isContinuation', true);
    //准备迁移数据
    let isContinuation: boolean = true;
    let isSelectImg: boolean = AppStorage.get<boolean>('isSelectImg') as boolean;
    let swiperIndex: number = AppStorage.get<number>('swiperIndex') as number;
    let inputTextArea: string = AppStorage.get<string>('inputTextArea') as string;
    let ability_isON: boolean = AppStorage.get<boolean>('ability_isON') as boolean;
    let pageStack_isON: boolean = AppStorage.get<boolean>('pageStack_isON') as boolean;
    let sourceEnd_isON: boolean = AppStorage.get<boolean>('sourceEnd_isON') as boolean;
    let image2Path: string = AppStorage.get<string>('image2Path') as string;

    // 将要迁移的数据保存在wantParam的``指定字段中
    wantParam['isContinuation'] = isContinuation;
    wantParam['isSelectImg'] = isSelectImg;
    wantParam['swiperIndex'] = swiperIndex;
    wantParam['inputTextArea'] = inputTextArea;
    wantParam['ability_isON'] = ability_isON;
    wantParam['pageStack_isON'] = pageStack_isON;
    wantParam['sourceEnd_isON'] = sourceEnd_isON;
    wantParam['image2Path'] = image2Path;

    Logger.info(TAG, `onContinue isContinuation ${isContinuation}`);
    Logger.info(TAG, `onContinue swiperIndex ${swiperIndex}`);
    Logger.info(TAG, `onContinue inputTextArea ${inputTextArea}`);
    Logger.info(TAG, `onContinue ability_isON ${ability_isON}`);
    Logger.info(TAG, `onContinue pageStack_isON ${pageStack_isON}`);
    Logger.info(TAG, `onContinue sourceEnd_isON ${sourceEnd_isON}`);

    // 每次创建分布式对象时，先将上一次的对象置空
    if (this.d_object) {
      this.d_object = undefined;
    }
    // 创建分布式对象
    let source: SourceObject = new SourceObject('');
    this.d_object = distributedObject.create(this.context, source);

    // 填充迁移的分布式数据对象
    if (this.d_object !== undefined) {
      // 随机创建一个sessionID
      this.sessionId = distributedObject.genSessionId();
      wantParam['session'] = this.sessionId;

      this.d_object['notesTitle'] = AppStorage.get<string>('inputText');
      Logger.info(TAG, `on Continue sessionId = ${this.sessionId}, inputText = ${this.d_object['notesTitle']}`);

      // 分布式对象d_object加入分布式组网：设置同步的sessionId
      this.d_object.setSessionId(this.sessionId, () => {
        Logger.info(TAG, 'join session');
      })

      // 保存分布式数据对象
      this.d_object.save(wantParam.targetDevice as string,
        (err: BusinessError, result: distributedObject.SaveSuccessResponse) => {
          if (err) {
            Logger.info(TAG, ' save failed, err: ' + JSON.stringify(err));
            return;
          }
          Logger.info(TAG, 'save callback, result: ' + JSON.stringify(result));
        })
    }
    // 设置是否迁移页面栈
    if (AppStorage.get<boolean>('pageStack_isON')) {
      wantParam[wantConstant.Params.SUPPORT_CONTINUE_PAGE_STACK_KEY] = true;
      Logger.info(TAG, 'onContinue : ' + 'wantParam[wantConstant.Params.SUPPORT_CONTINUE_PAGE_STACK_KEY] ' +
      wantParam[wantConstant.Params.SUPPORT_CONTINUE_PAGE_STACK_KEY])
    } else {
      wantParam[wantConstant.Params.SUPPORT_CONTINUE_PAGE_STACK_KEY] = false;
      Logger.info(TAG, 'onContinue : ' + 'wantParam[wantConstant.Params.SUPPORT_CONTINUE_PAGE_STACK_KEY] ' +
      wantParam[wantConstant.Params.SUPPORT_CONTINUE_PAGE_STACK_KEY])
    }

    // 设置是否退出迁移源端应用
    if (AppStorage.get<boolean>('sourceEnd_isON')) {
      wantParam[wantConstant.Params.SUPPORT_CONTINUE_SOURCE_EXIT_KEY] = true;
      Logger.info(TAG, 'onContinue : ' + 'wantParam[wantConstant.Params.SUPPORT_CONTINUE_SOURCE_EXIT_KEY] ' +
      wantParam[wantConstant.Params.SUPPORT_CONTINUE_SOURCE_EXIT_KEY])
    } else {
      wantParam[wantConstant.Params.SUPPORT_CONTINUE_SOURCE_EXIT_KEY] = false;
      Logger.info(TAG, 'onContinue : ' + 'wantParam[wantConstant.Params.SUPPORT_CONTINUE_SOURCE_EXIT_KEY] ' +
      wantParam[wantConstant.Params.SUPPORT_CONTINUE_SOURCE_EXIT_KEY])
    }

    return AbilityConstant.OnContinueResult.AGREE;
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam) {
    Logger.info(TAG, 'Ability onNewWant');
    Logger.info(TAG, 'onNewWant, want:' + want.abilityName);
    Logger.info(TAG, 'onNewWant, launchParams:' + JSON.stringify(launchParams));
    Logger.info(TAG, `onNewWant, want: ${want.abilityName}`);
    Logger.info(TAG, `onNewWant, launchParam: ${JSON.stringify(launchParams)}`);

    // 调用原因为迁移时，设置状态为可迁移，应对热启动情况（保证迁移连续性）
    if (launchParams.launchReason == AbilityConstant.LaunchReason.CONTINUATION) {
      this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
        Logger.info(`setMissionContinueState ACTIVE result: ${JSON.stringify(result)}`);
      });
    }

    //应用热启动时：恢复保存的迁移数据
    this.handleContinueParam(want, launchParams);
    Logger.info(TAG, 'onNewWant end')
  }

  onDestroy() {
    Logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', this.contentStorage);
  }


  onWindowStageRestore(windowStage: window.WindowStage) {
    Logger.info(TAG, 'onWindowStageRestore, pageStack_isON: ' + AppStorage.get<boolean>('pageStack_isON'));
    if (AppStorage.get<boolean>('pageStack_isON') == false) {
      Logger.info(TAG, 'onWindowStageRestore : ' + 'no pageStack');
      windowStage.loadContent('pages/Index', (err, data) => {
        if (err.code) {
          Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
          return;
        }
        Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`);
      });
    } else {
      Logger.info(TAG, 'onWindowStageRestore : have pageStack');
    }
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'Ability onBackground');
  }
}
