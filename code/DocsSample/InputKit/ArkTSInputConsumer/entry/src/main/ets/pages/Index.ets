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

// [Start input_monitor]
import { inputConsumer, KeyEvent } from '@kit.InputKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { KeyCode } from '@kit.InputKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct TestDemo14 {
  @State text: string = "Default monitoring for Volume Up and Down keys has been added."
  private volumeUpCallBackFunc: (event: KeyEvent) => void = () => {
  }
  private volumeDownCallBackFunc: (event: KeyEvent) => void = () => {
  }
  options1: inputConsumer.KeyPressedConfig = {
    key: KeyCode.KEYCODE_VOLUME_UP,
    action: 1, // 按下按键的行为
    isRepeat: false, // 优先消费掉按键事件，不上报
  }
  options2: inputConsumer.KeyPressedConfig = {
    key: KeyCode.KEYCODE_VOLUME_DOWN,
    action: 1, // 按下按键的行为
    isRepeat: false, // 优先消费掉按键事件，不上报
  }

  aboutToAppear(): void {
    try {
      // 点击了音量按键上事件回调
      this.volumeUpCallBackFunc = (event: KeyEvent) => {
        this.getUIContext().getPromptAction().showToast({ message: 'Volume Up key pressed' })
        // do something
      }

      // 点击了音量按键下事件回调
      this.volumeDownCallBackFunc = (event: KeyEvent) => {
        this.getUIContext().getPromptAction().showToast({ message: 'Volume Down key pressed' })
        // do something
      }
      // 注册监听事件
      inputConsumer.on('keyPressed', this.options1, this.volumeUpCallBackFunc);
      inputConsumer.on('keyPressed', this.options2, this.volumeDownCallBackFunc);
    } catch (error) {
      hilog.error(DOMAIN, 'InputConsumer', `Subscribe execute failed, error: %{public}s`,
        JSON.stringify(error, ["code", "message"]));
    }
  }

  build() {
    Column() {
      Row() {
        Button('Add monitoring for Volume Up key')
          .onClick(() => {
            try {
              // 添加指定回调函数
              inputConsumer.on('keyPressed', this.options1, this.volumeUpCallBackFunc);
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: 'Successfully added monitoring for Volume Up key!' })
              this.text = "Monitoring for Volume Up key has been added."
            } catch (error) {
              hilog.error(DOMAIN, 'InputConsumer', `Unsubscribe execute failed, error: %{public}s`,
                JSON.stringify(error, ["code", "message"]));
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: 'Failed to add monitoring for Volume Up key!' })
              this.text = `Failed to add monitoring for Volume Up key: ${JSON.stringify(error, ["code", "message"])}`
            }
          })
      }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 50 })

      Row() {
        Button('Remove monitoring for Volume Up key')
          .onClick(() => {
            try {
              // 取消指定回调函数
              inputConsumer.off('keyPressed', this.volumeUpCallBackFunc);
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: 'Successfully removed monitoring for Volume Up key!' })
              this.text = "Monitoring for Volume Up key has been removed."
            } catch (error) {
              hilog.error(DOMAIN, 'InputConsumer', `Unsubscribe execute failed, error: %{public}s`,
                JSON.stringify(error, ["code", "message"]));
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: 'Failed to remove monitoring for Volume Up key!' })
              this.text = `Failed to remove monitoring for Volume Up key: ${JSON.stringify(error, ["code", "message"])}`
            }
          })
      }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 50 })

      Row() {
        Button('Add monitoring for Volume Down key')
          .onClick(() => {
            try {
              // 添加指定回调函数
              inputConsumer.on('keyPressed', this.options2, this.volumeDownCallBackFunc);
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: 'Successfully added monitoring for Volume Down key!' })
              this.text = "Monitoring for Volume Down key has been added."
            } catch (error) {
              hilog.error(DOMAIN, 'InputConsumer', `Unsubscribe execute failed, error: %{public}s`,
                JSON.stringify(error, ["code", "message"]));
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: 'Failed to add monitoring for Volume Down key!' })
              this.text = `Failed to add monitoring for Volume Down key: ${JSON.stringify(error, ["code", "message"])}`
            }
          })
      }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 50 })

      Row() {
        Button('Remove monitoring for Volume Down key')
          .onClick(() => {
            try {
              // 取消指定回调函数
              inputConsumer.off('keyPressed', this.volumeDownCallBackFunc);
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: 'Successfully removed monitoring for Volume Down key!' })
              this.text = "Monitoring for Volume Down key has been removed."
            } catch (error) {
              hilog.error(DOMAIN, 'InputConsumer', `Unsubscribe execute failed, error: %{public}s`,
                JSON.stringify(error, ["code", "message"]));
              this.getUIContext()
                .getPromptAction()
                .showToast({ message: 'Failed to remove monitoring for Volume Down key!' })
              this.text =
                `Failed to remove monitoring for Volume Down key: ${JSON.stringify(error, ["code", "message"])}`
            }
          })
      }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 50 })

      Row() {
        Text(this.text)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }.width('100%').height('100%')
  }
}

// [End input_monitor]