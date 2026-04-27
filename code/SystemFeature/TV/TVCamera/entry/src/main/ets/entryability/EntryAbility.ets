/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import RemoteDeviceModel from '../models/RemoteDeviceModel';
import { setGlobalObject, EmptyObject } from '../utils/GlobalThis';


const TAG: string = 'EntryAbility';
// 业务背景：EntryAbility是应用的主入口Ability，负责应用生命周期管理
// 应用启动时记录启动时间戳，用于后续性能分析；保存全局上下文供其他模块使用
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: object) {
    const startTime = Date.now();
    hilog.info(0x0000, TAG, 'START_TIME: Application onCreate at %{public}s', new Date(startTime).toISOString());
    
    setGlobalObject('appStartTime', startTime as EmptyObject);
    setGlobalObject('context', this.context);
  }

  onDestroy() {
  }

  // 窗口创建回调
  // 业务背景：应用启动后需要判断是否为悬浮窗模式，决定是否显示悬浮窗
  // 策略：通过AppStorage传递状态，避免Ability间紧耦合
  onWindowStageCreate(windowStage: window.WindowStage) {
    // 移除对AppStorage的使用，因为该模块在当前SDK版本中不存在
    windowStage.loadContent('pages/Index', (err, data) => {
      if (!err || err.code === 0) {
        hilog.info(0x0000, TAG, 'START_TIME: Page loading initiated successfully');
      } else {
        hilog.error(0x0000, TAG, 'START_TIME: Page loading failed, error: %{public}s', JSON.stringify(err));
      }
    });
  }
  
  onWindowStageDestroy(): void {
    RemoteDeviceModel.release();
  }

}
