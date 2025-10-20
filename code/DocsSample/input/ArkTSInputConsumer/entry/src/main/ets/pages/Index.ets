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

// [Start input_monitor]
import { inputConsumer, KeyEvent } from '@kit.InputKit';
import { KeyCode } from '@kit.InputKit';

@Entry
@Component
struct TestDemo14 {
  private volumeUpCallBackFunc: (event: KeyEvent) => void = () => {
  }
  private volumeDownCallBackFunc: (event: KeyEvent) => void = () => {
  }

  aboutToAppear(): void {
    try {
      let options1: inputConsumer.KeyPressedConfig = {
        key: KeyCode.KEYCODE_VOLUME_UP,
        action: 1, // 按下按键的行为
        isRepeat: false, // 优先消费掉按键事件，不上报
      }
      let options2: inputConsumer.KeyPressedConfig = {
        key: KeyCode.KEYCODE_VOLUME_DOWN,
        action: 1, // 按下按键的行为
        isRepeat: false, // 优先消费掉按键事件，不上报
      }

      // 点击了音量按键上事件回调
      this.volumeUpCallBackFunc = (event: KeyEvent) => {
        this.getUIContext().getPromptAction().showToast({ message: '点击了音量按键上' })
        // do something
      }

      // 点击了音量按键下事件回调
      this.volumeDownCallBackFunc = (event: KeyEvent) => {
        this.getUIContext().getPromptAction().showToast({ message: '点击了音量按键下' })
        // do something
      }
      // 注册监听事件
      inputConsumer.on('keyPressed', options1, this.volumeUpCallBackFunc);
      inputConsumer.on('keyPressed', options2, this.volumeDownCallBackFunc);
    } catch (error) {
      console.error(`Subscribe execute failed, error: ${JSON.stringify(error, ["code", "message"])}`);
    }
  }

  build() {
    Column() {
      Row() {
        Button('取消监听音量按键上的监听')
          .onClick(() => {
            try {
              // 取消指定回调函数
              inputConsumer.off('keyPressed', this.volumeUpCallBackFunc);
              this.getUIContext().getPromptAction().showToast({ message: '取消监听音量按键上的监听事件成功！' })
            } catch (error) {
              console.error(`Unsubscribe execute failed, error: ${JSON.stringify(error, ["code", "message"])}`);
            }
          })
      }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 50 })

      Row() {
        Button('取消监听音量按键下的监听')
          .onClick(() => {
            try {
              // 取消指定回调函数
              inputConsumer.off('keyPressed', this.volumeDownCallBackFunc);
              this.getUIContext().getPromptAction().showToast({ message: '取消监听音量按键下的监听事件成功！' })
            } catch (error) {
              console.error(`Unsubscribe execute failed, error: ${JSON.stringify(error, ["code", "message"])}`);
            }
          })
      }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 50 })

      Row() {
        Text('已默认添加监听音量按键上和下的监听')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }.width('100%').height('100%')
  }
}
// [End input_monitor]