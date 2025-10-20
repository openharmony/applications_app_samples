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

// [Start input_device]
import { inputDevice } from '@kit.InputKit';

@Entry
@Component
struct Index {
  @State isPhysicalKeyboardExist: boolean = false;
  @State message:string = "点击获取设备列表并监听设备热拔插";
  // [StartExclude input_device]
  // 结果展示
  @Builder
  ResultDisplay() {
    Column() {
        Text(`当前物理键盘连接状态为：${this.isPhysicalKeyboardExist}`)
          .fontSize(14)
          .width('100%')
          .wordBreak(WordBreak.BREAK_ALL)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .padding(12)
    }
    .width('100%')
    .backgroundColor('#F5F5F5')
    .borderRadius(8)
    .margin({ top: 20, bottom: 20 })
    .padding(0)
  }
  // [EndExclude  input_device]

  build() {
    RelativeContainer() {
      Column() {
        // [StartExclude input_device]
        this.ResultDisplay()
        // [EndExclude  input_device]

        Text(this.message)
          .onClick(() => {
            try {
              // 1.获取设备列表，判断是否有物理键盘连接
              inputDevice.getDeviceList().then(data => {
                for (let i = 0; i < data.length; ++i) {
                  inputDevice.getKeyboardType(data[i]).then(type => {
                    if (type === inputDevice.KeyboardType.ALPHABETIC_KEYBOARD) {
                      // 物理键盘已连接
                      this.isPhysicalKeyboardExist = true;
                    }
                  });
                }
              });
              // 2.监听设备热插拔
              inputDevice.on("change", (data) => {
                console.info(`Device event info: ${JSON.stringify(data)}`);
                inputDevice.getKeyboardType(data.deviceId).then((type) => {
                  console.info("The keyboard type is: " + type);
                  if (type === inputDevice.KeyboardType.ALPHABETIC_KEYBOARD && data.type == 'add') {
                    // 物理键盘已插入
                    this.isPhysicalKeyboardExist = true;
                  } else if (type == inputDevice.KeyboardType.ALPHABETIC_KEYBOARD && data.type == 'remove') {
                    // 物理键盘已拔掉
                    this.isPhysicalKeyboardExist = false;
                  }
                });
              });
              this.message = "开启设备监听成功"
            } catch (error) {
              console.error(`Execute failed, error: ${JSON.stringify(error, ["code", "message"])}`);
              this.message = `开启设备监听成功失败，点击重试。错误信息为${JSON.stringify(error, ["code", "message"])}`
            }
          })
          // [StartExclude input_device]
          .height('auto')
          .width('100%')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .textAlign(TextAlign.Center)
          .margin({ top: 8, bottom: 8 })
          .lineHeight(20)
          .wordBreak(WordBreak.BREAK_ALL)
          .maxLines(2)
          .backgroundColor('#F7F9FC')
          .borderRadius(4)
          .padding(8)
         // [EndExclude  input_device]
      }
      // [StartExclude input_device]
      .height('100%')
      .width('80%')
      .alignItems(HorizontalAlign.Center)
      .position({ left: '10%', right: '10%' })
      .margin({ bottom: 200 })
      // [EndExclude  input_device]
    }
  }
}
// [End input_device]
