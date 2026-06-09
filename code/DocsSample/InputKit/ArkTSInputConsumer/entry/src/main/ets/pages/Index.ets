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
import { inputConsumer, KeyEvent, inputDevice, KeyCode } from '@kit.InputKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct TestDemo14 {
  @State showComponent: boolean = false
  @State text: string = "Default monitoring for Volume Up and Down keys has been added."
  private volumeUpCallBackFunc: (event: KeyEvent) => void = () => {
  }
  private volumeDownCallBackFunc: (event: KeyEvent) => void = () => {
  }
  private slideUpCallBackFunc: (event: KeyEvent) => void = () => {
  }
  private slideDownCallBackFunc: (event: KeyEvent) => void = () => {
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
  options3: inputConsumer.KeyPressedConfig = {
    key: KeyCode.KEYCODE_FINGERPRINT_SLIDE_UP,
    action: 1, // 按下按键的行为
    isRepeat: false, // 优先消费掉按键事件，不上报
  }
  options4: inputConsumer.KeyPressedConfig = {
    key: KeyCode.KEYCODE_FINGERPRINT_SLIDE_DOWN,
    action: 1, // 按下按键的行为
    isRepeat: false, // 优先消费掉按键事件，不上报
  }
  // 判断设备是否支持KEYCODE_FINGERPRINT_SLIDE_UP 和 KEYCODE_FINGERPRINT_SLIDE_DOWN
  private isFingerprintSlideKeySupported(): Promise<boolean> {
    return new Promise<boolean>((resolve) => {
      inputDevice.getDeviceList((error: BusinessError, ids: Array<Number>) => {
        if (error) {
          console.error(`keyPressed Failed to get device id list, error: ${
            JSON.stringify(error, ['code', 'message'])}`);
          resolve(false);
          return;
        }
        console.info(`keyPressed Device id list: ${JSON.stringify(ids)}`);
        for (let idTemp of ids) {
          let res = inputDevice.supportKeysSync(Number(idTemp), [KeyCode.KEYCODE_FINGERPRINT_SLIDE_UP,
            KeyCode.KEYCODE_FINGERPRINT_SLIDE_DOWN]);
          if (res[0] && res[1]) {
            console.info(`keyPressed ${idTemp} Device id list supportKeysSync : ${JSON.stringify(res)}`);
            resolve(true);
            return;
          }
        }
        resolve(false);
      });
    });
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
      // 智控键事件上滑回调
      this.slideUpCallBackFunc = (event: KeyEvent) => {
        this.getUIContext().getPromptAction().showToast({ message: 'Slide Up key pressed' })
        // do something
      }

      // 智控键事件下滑回调
      this.slideDownCallBackFunc = (event: KeyEvent) => {
        this.getUIContext().getPromptAction().showToast({ message: 'Slide Down key pressed' })
        // do something
      }
      this.isFingerprintSlideKeySupported().then((supported: boolean) => {
        this.showComponent = supported;
      }).catch((error: Error) => {
        console.error(`Failed to check fingerprint support: ${JSON.stringify(error)}`);
        this.showComponent = false;
      });
    } catch (error) {
      hilog.error(DOMAIN, 'InputConsumer', `Subscribe execute failed, error: %{public}s`,
        JSON.stringify(error, ["code", "message"]));
    }
  }

  build() {
    Column() {
      // 注册及去注册音量键事件
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
      .margin({ top: 20, bottom: 20 })

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
      .margin({ top: 20, bottom: 20 })

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
      .margin({ top: 20, bottom: 20 })

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
      .margin({ top: 20, bottom: 20 })

      // 注册及去注册智控键事件
      // 若不支持智控键上滑及智控键下滑按键，则关闭用户入口
      if (this.showComponent) {
        Row() {
          Button('Add monitoring for Slide Up key')
            .onClick(() => {
              try {
                // 添加指定回调函数
                inputConsumer.on('keyPressed', this.options3, this.slideUpCallBackFunc);
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: 'Successfully added monitoring for Slide Up key!' })
                this.text = "Monitoring for Slide Up key has been added."
              } catch (error) {
                hilog.error(DOMAIN, 'InputConsumer', `Unsubscribe execute failed, error: %{public}s`,
                  JSON.stringify(error, ["code", "message"]));
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: 'Failed to add monitoring for Slide Up key!' })
                this.text = `Failed to add monitoring for Slide Up key: ${JSON.stringify(error, ["code", "message"])}`
              }
            })
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20, bottom: 20 })

        Row() {
          Button('Remove monitoring for Slide Up key')
            .onClick(() => {
              try {
                // 取消指定回调函数
                inputConsumer.off('keyPressed', this.slideUpCallBackFunc);
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: 'Successfully removed monitoring for Slide Up key!' })
                this.text = "Monitoring for Slide Up key has been removed."
              } catch (error) {
                hilog.error(DOMAIN, 'InputConsumer', `Unsubscribe execute failed, error: %{public}s`,
                  JSON.stringify(error, ["code", "message"]));
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: 'Failed to remove monitoring for Slide Up key!' })
                this.text =
                  `Failed to remove monitoring for Slide Up key: ${JSON.stringify(error, ["code", "message"])}`
              }
            })
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20, bottom: 20 })

        Row() {
          Button('Add monitoring for Slide Down key')
            .onClick(() => {
              try {
                // 添加指定回调函数
                inputConsumer.on('keyPressed', this.options4, this.slideDownCallBackFunc);
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: 'Successfully added monitoring for Slide Down key!' })
                this.text = "Monitoring for Slide Down key has been added."
              } catch (error) {
                hilog.error(DOMAIN, 'InputConsumer', `Unsubscribe execute failed, error: %{public}s`,
                  JSON.stringify(error, ["code", "message"]));
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: 'Failed to add monitoring for Slide Down key!' })
                this.text = `Failed to add monitoring for Slide Down key: ${JSON.stringify(error, ["code", "message"])}`
              }
            })
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20, bottom: 20 })

        Row() {
          Button('Remove monitoring for Slide Down key')
            .onClick(() => {
              try {
                // 取消指定回调函数
                inputConsumer.off('keyPressed', this.slideDownCallBackFunc);
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: 'Successfully removed monitoring for Slide Down key!' })
                this.text = "Monitoring for Slide Down key has been removed."
              } catch (error) {
                hilog.error(DOMAIN, 'InputConsumer', `Unsubscribe execute failed, error: %{public}s`,
                  JSON.stringify(error, ["code", "message"]));
                this.getUIContext()
                  .getPromptAction()
                  .showToast({ message: 'Failed to remove monitoring for Slide Down key!' })
                this.text =
                  `Failed to remove monitoring for Slide Down key: ${JSON.stringify(error, ["code", "message"])}`
              }
            })
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20, bottom: 20 })
      }

      Row() {
        Text(this.text)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }.width('100%').height('100%')
  }
}

// [End input_monitor]