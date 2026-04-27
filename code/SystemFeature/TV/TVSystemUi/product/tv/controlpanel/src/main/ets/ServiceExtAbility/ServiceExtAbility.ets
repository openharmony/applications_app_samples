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
 

import { inputConsumer } from '@kit.InputKit';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import { display, window } from '@kit.ArkUI';
import AbilityManager, {
  rectAttribute
} from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';
import { emitter } from '@kit.BasicServicesKit';

import { ServiceExtensionAbility as ServiceExtension } from '@kit.AbilityKit';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import { Want } from '@kit.AbilityKit';
import { KeyCode } from '@kit.InputKit';
import { promptAction } from '@kit.ArkUI';

const TAG = 'ControlPanel_ServiceExtAbility';
let mWindowHandler: window.Window | null = null

class ServiceExtAbility extends ServiceExtension {
  onCreate(want: Want): void {
    let backKeyCallback = (keyOptions: inputConsumer.KeyOptions) => {
      // console.log('systemui111-->短按返回按钮执行成功')
      setTimeout(() => {
        mWindowHandler!.hide().then(() => {
          // 控制中心隐藏时，取消监听返回按钮
          // console.log('systemui111-->取消监听短按返回按钮')
          inputConsumer.off('key', backKeyOption, backKeyCallback)
        })
      }, 400)
    }
    let backKeyOption: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_BACK,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    };

    // let dis = await display.getDefaultDisplay();
    // 获取屏幕尺寸
    let dis = display.getDefaultDisplaySync();
    // 设置控制中心窗口尺寸和位置
    let rect: rectAttribute = {
      left: 0,
      top: 0,
      width: dis.width,
      height: dis.height,
    };
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_CONTROL_PANEL, this.context);
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_CONTROL_PANEL, 'rect', rect);
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_CONTROL_PANEL, 'dis', {
      width: dis.width,
      height: dis.height,
    });

    // 创建控制中心窗口
    WindowManager.createWindow(this.context, WindowType.CONTROL_PANEL, rect, 'pages/Index')
      .then((win: window.Window) => {
        mWindowHandler = win
        if (mWindowHandler) {
          // 接收控制中心的通知关闭窗口
          emitter.on('CONTROLLER_CENTER_EVENT', () => {
            mWindowHandler!.hide()
          })
          // 接收亮度条通知关闭窗口
          emitter.on('BRIGHTNESS_DIALOG_TIMER_EVENT', () => {
            mWindowHandler!.hide()
          })

          // 长按菜单按钮
          inputConsumer.on('key', {
            preKeys: [],
            finalKey: KeyCode.KEYCODE_MENU,
            isFinalKeyDown: true,
            finalKeyDownDuration: 1000
          }, (t) => {
            // console.log('systemui111-->长按菜单按钮执行成功')
            // 长按菜单按钮后打开窗口
            mWindowHandler!.showWindow().then(async () => {
              // 设置窗口背景色为透明
              mWindowHandler!.setWindowBackgroundColor('#00000000')
              // 将焦点转移到当前窗口
              mWindowHandler!.setWindowFocusable(true).then(() => {
                // 控制中心展示时，监听返回按钮
                inputConsumer.on('key', backKeyOption, backKeyCallback)
                mWindowHandler!.showWindow()
              })
            })
          })
        }
      }).catch(() => {
    });

    //截屏，录屏按键监听
    let keyOptionsScreenRecorder: inputConsumer.KeyOptions = {
      preKeys: [KeyCode.KEYCODE_MENU],
      finalKey: KeyCode.KEYCODE_VOLUME_DOWN,
      isFinalKeyDown: false,
      finalKeyDownDuration: 0
    }
    let cbScreenRecorder = (keyOptions: inputConsumer.KeyOptions) => {
      // promptAction.showToast({
      //   message:'录屏组合键已响应'
      // })
      this.context.startAbility({
        bundleName: 'ohos.samples.screenrecorder',
        abilityName: 'ScreenRecorderAbility'
      })
    }

    inputConsumer.on('key', keyOptionsScreenRecorder, cbScreenRecorder)

    let keyOptionsScreenshot: inputConsumer.KeyOptions = {
      preKeys: [KeyCode.KEYCODE_MENU],
      finalKey: KeyCode.KEYCODE_VOLUME_UP,
      isFinalKeyDown: false,
      finalKeyDownDuration: 0
    }
    let cbScreenshot = (keyOptions: inputConsumer.KeyOptions) => {
      // promptAction.showToast({
      //   message:'截屏组合键已响应'
      // })
      this.context.startAbility({
        bundleName: 'com.ohos.screenshot',
        abilityName: 'com.ohos.screenshot.ServiceExtAbility'
      })
    }

    inputConsumer.on('key', keyOptionsScreenshot, cbScreenshot)
  }

  onDestroy(): void {
    if (mWindowHandler) {
      mWindowHandler!.destroyWindow()
    }
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
