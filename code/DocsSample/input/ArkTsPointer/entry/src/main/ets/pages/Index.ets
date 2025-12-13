/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { pointer } from '@kit.InputKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      Column() {
        // [Start pointer_visible]
        Text("Click to hide pointer")
          .onClick(() => {
            // 1.应用切换到全屏播放
            // 2.调用鼠标光标隐藏接口隐藏光标
            try {
              pointer.setPointerVisible(false, (error: Error) => {
                if (error) {
                  hilog.error(DOMAIN, 'Pointer', `Set pointer visible failed, error: %{public}s`,
                    JSON.stringify(error, ["code", "message"]));
                  return;
                }
                hilog.info(DOMAIN, 'Pointer', 'Set pointer visible success.');
              });
            } catch (error) {
              hilog.error(DOMAIN, 'Pointer', `The mouse pointer hide attributes is failed. %{public}s`,
                JSON.stringify(error, ["code", "message"]));
            }
          })
          // [StartExclude pointer_visible]
          .height('auto')
          .width('100%')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .textAlign(TextAlign.Start)
          .margin({ top: 8, bottom: 8 })
          .lineHeight(20)
          .wordBreak(WordBreak.BREAK_ALL)
          .maxLines(2)
          .backgroundColor('#F7F9FC')
          .borderRadius(4)
          .padding(8)
        // [EndExclude pointer_visible]

        // 3.应用退出全屏播放
        // 4.调用鼠标光标显示接口显示光标
        Text("Click to display pointer")
          .onClick(() => {
            try {
              pointer.setPointerVisible(true, (error: Error) => {
                if (error) {
                  hilog.error(DOMAIN, 'Pointer', `Set pointer visible failed, error: %{public}s`,
                    JSON.stringify(error, ["code", "message"]));
                  return;
                }
                hilog.info(DOMAIN, 'Pointer', 'Set pointer visible success.');
              });
            } catch (error) {
              hilog.error(DOMAIN, 'Pointer', `Set pointer visible failed, error: %{public}s`,
                JSON.stringify(error, ["code", "message"]));
            }
          })
          // [StartExclude pointer_visible]
          .height('auto')
          .width('100%')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .textAlign(TextAlign.Start)
          .margin({ top: 8, bottom: 8 })
          .lineHeight(20)
          .wordBreak(WordBreak.BREAK_ALL)
          .maxLines(2)
          .backgroundColor('#F7F9FC')
          .borderRadius(4)
          .padding(8)
        // [EndExclude pointer_visible]
        // [End pointer_visible]

        // [Start pointer_style]
        Text(`Click to set the mouse pointer style to the color picker style`)
          .onClick(() => {
            // 1.开发者使能取色功能
            // 2.调用窗口实例获取对应的窗口id
            window.getLastWindow(this.getUIContext().getHostContext(),
              (error: BusinessError, windowClass: window.Window) => {
                if (error.code) {
                  hilog.error(DOMAIN, 'Pointer', 'Failed to obtain the top window. Cause: %{public}s',
                    JSON.stringify(error));
                  return;
                }
                let windowId = windowClass.getWindowProperties().id;
                if (windowId < 0) {
                  hilog.info(DOMAIN, 'Pointer', 'Invalid windowId');
                  return;
                }
                try {
                  // 3.设置鼠标光标样式为取色器样式
                  pointer.setPointerStyle(windowId, pointer.PointerStyle.COLOR_SUCKER).then(() => {
                    hilog.info(DOMAIN, 'Pointer', 'Successfully set mouse pointer style');
                  });
                } catch (error) {
                  hilog.error(DOMAIN, 'Pointer', `Failed to set the pointer style, error=%{public}s, msg=%{public}s`,
                    JSON.stringify(error), error.message);
                }
              });
          })
          // [StartExclude pointer_style]
          .height('auto')
          .width('100%')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .textAlign(TextAlign.Start)
          .margin({ top: 8, bottom: 8 })
          .lineHeight(20)
          .wordBreak(WordBreak.BREAK_ALL)
          .maxLines(2)
          .backgroundColor('#F7F9FC')
          .borderRadius(4)
          .padding(8)
          .wordBreak(WordBreak.NORMAL)
        // [EndExclude pointer_style]


        Text(`Click to set the mouse pointer style to default style`)
          .onClick(() => {
            // 4.取色结束
            window.getLastWindow(this.getUIContext().getHostContext(),
              (error: BusinessError, windowClass: window.Window) => {
                if (error.code) {
                  hilog.error(DOMAIN, 'Pointer', 'Failed to obtain the top window. Cause: %{public}s',
                    JSON.stringify(error));
                  return;
                }
                let windowId = windowClass.getWindowProperties().id;
                if (windowId < 0) {
                  hilog.info(DOMAIN, 'Pointer', 'Invalid windowId');
                  return;
                }
                try {
                  // 5.设置鼠标光标样式为默认样式
                  pointer.setPointerStyle(windowId, pointer.PointerStyle.DEFAULT).then(() => {
                    hilog.info(DOMAIN, 'Pointer', 'Successfully set mouse pointer style');
                  });
                } catch (error) {
                  hilog.error(DOMAIN, 'Pointer', `Failed to set the pointer style, error=%{public}s, msg=%{public}s`,
                    JSON.stringify(error), error.message);
                }
              });
          })
          // [End pointer_style]
          .height('auto')
          .width('100%')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .textAlign(TextAlign.Start)
          .margin({ top: 8, bottom: 8 })
          .lineHeight(20)
          .wordBreak(WordBreak.BREAK_ALL)
          .maxLines(2)
          .backgroundColor('#F7F9FC')
          .borderRadius(4)
          .padding(8)
          .wordBreak(WordBreak.NORMAL)
      }
      .height('100%')
      .width('80%')
      .alignItems(HorizontalAlign.Center)
      .position({ left: '10%', right: '10%' })
      .margin({ bottom: 200 })
    }
  }
}