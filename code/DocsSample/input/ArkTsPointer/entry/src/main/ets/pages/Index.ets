/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { pointer } from '@kit.InputKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      Column() {
        // [Start pointer_visible]
        Text("点击隐藏光标")
          .onClick(() => {
            // 1.应用切换到全屏播放
            // 2.调用鼠标光标隐藏接口隐藏光标
            try {
              pointer.setPointerVisible(false, (error: Error) => {
                if (error) {
                  console.error(`Set pointer visible failed, error: ${JSON.stringify(error, ["code", "message"])}`);
                  return;
                }
                console.info(`Set pointer visible success.`);
              });
            } catch (error) {
              console.error(`The mouse pointer hide attributes is failed. ${JSON.stringify(error,
                ["code", "message"])}`);
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
        Text("点击显示光标")
          .onClick(() => {
            try {
              pointer.setPointerVisible(true, (error: Error) => {
                if (error) {
                  console.error(`Set pointer visible failed, error: ${JSON.stringify(error, ["code", "message"])}`);
                  return;
                }
                console.info(`Set pointer visible success.`);
              });
            } catch (error) {
              console.error(`Set pointer visible failed, ${JSON.stringify(error, ["code", "message"])}`);
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
        Text("点击设置鼠标光标样式为取色器样式")
          .onClick(() => {
            // 1.开发者使能取色功能
            // 2.调用窗口实例获取对应的窗口id
            window.getLastWindow(this.getUIContext().getHostContext(),
              (error: BusinessError, windowClass: window.Window) => {
                if (error.code) {
                  console.error('Failed to obtain the top window. Cause: ' + JSON.stringify(error));
                  return;
                }
                let windowId = windowClass.getWindowProperties().id;
                if (windowId < 0) {
                  console.info(`Invalid windowId`);
                  return;
                }
                try {
                  // 3.设置鼠标光标样式为取色器样式
                  pointer.setPointerStyle(windowId, pointer.PointerStyle.COLOR_SUCKER).then(() => {
                    console.info(`Successfully set mouse pointer style`);
                  });
                } catch (error) {
                  console.error(`Failed to set the pointer style, error=${JSON.stringify(error)}, msg=${error.message}`);
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
        // [EndExclude pointer_style]


        Text("点击设置鼠标光标样式为默认样式")
          .onClick(() => {
            // 4.取色结束
            window.getLastWindow(this.getUIContext().getHostContext(),
              (error: BusinessError, windowClass: window.Window) => {
                if (error.code) {
                  console.error('Failed to obtain the top window. Cause: ' + JSON.stringify(error));
                  return;
                }
                let windowId = windowClass.getWindowProperties().id;
                if (windowId < 0) {
                  console.info(`Invalid windowId`);
                  return;
                }
                try {
                  // 5.设置鼠标光标样式为默认样式
                  pointer.setPointerStyle(windowId, pointer.PointerStyle.DEFAULT).then(() => {
                    console.info(`Successfully set mouse pointer style`);
                  });
                } catch (error) {
                  console.error(`Failed to set the pointer style, error=${JSON.stringify(error)}, msg=${error.message}`);
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
      }
      .height('100%')
      .width('80%')
      .alignItems(HorizontalAlign.Center)
      .position({ left: '10%', right: '10%' })
      .margin({ bottom: 200 })
    }
  }
}