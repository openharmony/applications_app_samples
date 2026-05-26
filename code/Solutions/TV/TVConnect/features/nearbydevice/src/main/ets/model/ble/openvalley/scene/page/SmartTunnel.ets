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
import HeadTitleComponent from '../component/HeadTitleComponent';
import { SmartTunnelDragView } from './SmartTunnelDragView';
import router from '@ohos.router';
import { CommonConstants, Logger } from '@ohos/common';
import TunnelSceneModel from '../model/TunnelSceneModel';
import TunnelScanManager from '../TunnelScanManager';


/**
 * 智慧隧道场景页面
 */
@Component
export struct SmartTunnel {
  @Provide model: TunnelSceneModel = TunnelScanManager.getInstance().getModel();

  isButtonAvailable(): boolean {
    return this.model.isFillComplete;
  }

  build() {
    Column() {
      Column() {
        HeadTitleComponent(
          {
            title: '智慧隧道',
            clickCallback: () => {
              router.back();
            }
          }
        );
      }
      .focusable(true)
      .defaultFocus(true);

      SmartTunnelDragView()
        .layoutWeight(1);
      Button(this.model.isSetFinish ? $r('app.string.finish_scenario') : $r('app.string.execution_scenario'), {
        type: ButtonType.Capsule,
        stateEffect: true
      })
        .width('50%')
        .opacity(this.isButtonAvailable() ? 1 : 0.4)
        .height($r('app.string.btn_height'))
        .margin({ bottom: $r('app.string.btn_margin_bottom') })
        .onClick(() => {
          Logger.debug('执行场景');
          if (this.isButtonAvailable()) {
            const invoke: boolean = !this.model.isSetFinish;
            Logger.debug(`执行场景invoke:${invoke}`);
            TunnelScanManager.getInstance().invokeOrStopScene(invoke);
          }
        });
    }
    .linearGradient({
      angle: 180,
      colors: [['rgba(10,89,247,0.1)', 0.1], ['rgba(255,255,255,0)', 0.21], ['rgba(255,255,255,0)', 0.77],
        ['rgba(10,89,247,0.1)', 1.0]]
    })
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT);
  }
}

