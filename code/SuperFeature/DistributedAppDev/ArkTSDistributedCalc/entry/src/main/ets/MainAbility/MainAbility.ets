/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import UIAbility from '@ohos.app.ability.UIAbility';
import Logger from '../model/Logger';
import { KvStoreModel } from '../model/KvStoreModel';
import { AbilityConstant, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { emitter, } from '@kit.BasicServicesKit';

const TAG: string = 'MainAbility';

export default class MainAbility extends UIAbility {
  private kvStoreModel: KvStoreModel = new KvStoreModel();

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    AppStorage.setOrCreate('UIAbilityContext', this.context);
    AppStorage.setOrCreate('KvStoreModel', this.kvStoreModel);
    let isRemote = want.parameters?.isRemote;
    Logger.info(TAG, `MainAbility onCreate isRemote ${isRemote}`);
    if (isRemote) {
      AppStorage.setOrCreate('isRemote', isRemote);
    }

    Logger.info(TAG, `aboutToAppear, start setOnMessageReceivedListener`);
    // 应用启动时添加数据同步监听，减少因为注册时间晚导致无法收到同步数据的问题
    this.kvStoreModel.setOnMessageReceivedListener(this.context, 'dataChange', (value: string) => {
      emitter.emit('dataChange', {
        data: {
          value: value
        }
      });
    })
    Logger.info(TAG, `MainAbility onCreate`);
  }

  onDestroy() {
    Logger.info(TAG, `MainAbility onDestroy`);
    this.kvStoreModel.releaseMessageReceivedListener();
    this.kvStoreModel.deleteKvStore();
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, `MainAbility onWindowStageCreate`);
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.info(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`);
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `MainAbility onWindowStageDestroy`);
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, `MainAbility onForeground`);
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, `MainAbility onBackground`);
  }
}