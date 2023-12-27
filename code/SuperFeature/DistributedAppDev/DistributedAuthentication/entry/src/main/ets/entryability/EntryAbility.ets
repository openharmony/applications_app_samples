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

import hilog from '@ohos.hilog';
import Ability from '@ohos.app.ability.UIAbility';
import Window from '@ohos.window';
import remoteDeviceModel from '../model/RemoteDeviceModel';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { GlobalContext, getGlobalObject, setGlobalObject } from '../common/GlobalThis'

export default class EntryAbility extends Ability {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    hilog.info(0x0000, 'testTag', '%{public}s', 'want param:' + JSON.stringify(want) ?? '');
    hilog.info(0x0000, 'testTag', '%{public}s', 'launchParam:' + JSON.stringify(launchParam) ?? '');
    setGlobalObject('this.context', this.context);
    setGlobalObject('this.context.resourceManager', this.context.resourceManager);
    this.initFilterOption();
    remoteDeviceModel.createDeviceManager();
  }

  getStringByResource(r: Resource) {
    return this.context.resourceManager.getStringSync(r.id);
  }

  initFilterOption() {
    let DeviceTypeItemList: Array<string> = [
    this.context.resourceManager.getStringSync($r('app.string.no_filter')),
    this.context.resourceManager.getStringSync($r('app.string.tablet')),
    this.context.resourceManager.getStringSync($r('app.string.phone')),
    this.context.resourceManager.getStringSync($r('app.string.other')),
    ];
    setGlobalObject('DeviceTypeItemList', DeviceTypeItemList);
    let AuthFormItemList: Array<string> = [
    this.context.resourceManager.getStringSync($r('app.string.no_filter')),
    this.context.resourceManager.getStringSync($r('app.string.identical_account')),
    this.context.resourceManager.getStringSync($r('app.string.across_account')),
    this.context.resourceManager.getStringSync($r('app.string.no_account')),
    ];
    setGlobalObject('AuthFormItemList', AuthFormItemList);
    let IsOnlineItemList: Array<string> = [
    this.context.resourceManager.getStringSync($r('app.string.no_filter')),
    this.context.resourceManager.getStringSync($r('app.string.online')),
    this.context.resourceManager.getStringSync($r('app.string.offline')),
    ];
    setGlobalObject('IsOnlineItemList', IsOnlineItemList);
    let IsTrustedItemList: Array<string> = [
    this.context.resourceManager.getStringSync($r('app.string.no_filter')),
    this.context.resourceManager.getStringSync($r('app.string.credible')),
    this.context.resourceManager.getStringSync($r('app.string.incredible')),
    ];
    setGlobalObject('IsTrustedItemList', IsTrustedItemList);
    let RangeItemList: Array<string> = [
    this.context.resourceManager.getStringSync($r('app.string.no_filter')), '50', '80', '100'];
    setGlobalObject('RangeItemList', RangeItemList);

  }

  onDestroy() {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    remoteDeviceModel.unregisterDeviceListCallback();
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.ERROR);
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
