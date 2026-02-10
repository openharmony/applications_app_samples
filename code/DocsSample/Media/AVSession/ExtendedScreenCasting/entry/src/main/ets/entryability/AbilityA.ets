/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start create_avSession]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import  { avSession }  from '@kit.AVSessionKit'; // 导入AVSession模块
import { BusinessError } from '@kit.BasicServicesKit';

export default class AbilityA extends UIAbility{
  private session: avSession.AVSession | undefined = undefined;
  private extCastDisplayInfo: avSession.CastDisplayInfo | undefined = undefined;
  // 注册监听可投屏设备变化事件
  private onCastDisplayChangedCallback = (castDisplayInfo: avSession.CastDisplayInfo) => {
    // 新增扩展屏,进入扩展屏显示
    if (this.extCastDisplayInfo === undefined && castDisplayInfo.state === avSession.CastDisplayState.STATE_ON) {
      console.info('Succeeded in opening the cast display');
      this.extCastDisplayInfo = castDisplayInfo;
      this.startExternalDisplay();
    } else if (this.extCastDisplayInfo?.id == castDisplayInfo.id) {
      this.extCastDisplayInfo = castDisplayInfo;
      // 扩展屏不可用，退出扩展屏显示
      if (castDisplayInfo.state === avSession.CastDisplayState.STATE_OFF){
        console.info('Succeeded in closing the cast display');
        this.stopExternalDisplay();
        this.extCastDisplayInfo = undefined;
      }
    }
  };

  // 创建AVSession, 获取可用扩展屏投播设备并注册监听
  initAVSession(context: Context) {
    avSession.createAVSession(context, 'CastDisplay', 'video').then((session: avSession.AVSession) => {
      this.session = session;
      this.session?.on('castDisplayChange', this.onCastDisplayChangedCallback);

      // 获取当前系统可用的扩展屏显示设备
      session.getAllCastDisplays().then((infoArr: avSession.CastDisplayInfo[]) => {
        // 有多个扩展屏时可以提供用户选择，也可使用其中任一个作为扩展屏使用。
        if (infoArr.length > 0) {
          this.extCastDisplayInfo = infoArr[0];
          this.startExternalDisplay();
        }
      }).catch((err: BusinessError<void>) => {
        console.error(`Failed to get all CastDisplay. Code: ${err.code}, message: ${err.message}`);
      });
    });
  }

  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    super.onCreate(want, launchParam);
    this.initAVSession(this.context);
  }

  onDestroy() {
    this.stopExternalDisplay();
    // 去注册监听
    this.session?.off('castDisplayChange');
  }
  // [StartExclude create_avSession]
  // [Start start_abilityB]
  // 扩展屏启动UIAbilityB
  startExternalDisplay() {
    if (this.extCastDisplayInfo !== undefined &&
      this.extCastDisplayInfo.id !== 0 &&
      this.extCastDisplayInfo.state === avSession.CastDisplayState.STATE_ON) {
      let id = this.extCastDisplayInfo?.id;
      console.info(`Succeeded in starting ability and the id of display is ${id}`);
      this.context.startAbility({
        bundleName: 'com.example.myapplication', // 应用自有包名
        abilityName: 'AbilityB'
      }, {
        displayId: id // 扩展屏ID
      });
      AppStorage.setOrCreate('CastDisplayState', 1);
    }
  }

  // 停止使用扩展屏
  stopExternalDisplay() {
    AppStorage.setOrCreate('CastDisplayState', 0);
    // 更新本页面显示。
  }
  // [End start_abilityB]
  // [EndExclude create_avSession]
}
// [End create_avSession]