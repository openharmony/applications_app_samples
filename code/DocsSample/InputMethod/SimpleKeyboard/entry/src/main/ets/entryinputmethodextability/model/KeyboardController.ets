'use static'
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

import { display, window } from '@kit.ArkUI';
import { inputMethodEngine, InputMethodExtensionContext, InputMethodSubtype, inputMethodEngine } from '@kit.IMEKit';
import hilog from '@ohos.hilog';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';

// 调用输入法框架的getInputMethodAbility方法获取实例，并由此实例调用输入法框架功能接口
const inputMethodAbility: inputMethodEngine.InputMethodAbility | null = inputMethodEngine.getInputMethodAbility();

export class KeyboardController {
  private mContext: InputMethodExtensionContext | undefined = undefined; // 保存InputMethodExtensionAbility中的context属性
  private panel: inputMethodEngine.Panel | undefined = undefined;
  private textInputClient: inputMethodEngine.InputClient | undefined = undefined;
  private keyboardController: inputMethodEngine.KeyboardController | undefined = undefined;

  constructor() {
  }

  public onCreate(context: InputMethodExtensionContext): void {
    this.mContext = context;
    this.initWindow(); // 初始化窗口
    this.registerListener(); // 注册对输入法框架的事件监听
  }

  public onDestroy(): void {  // 应用生命周期销毁
    this.unRegisterListener(); // 去注册事件监听
    if(this.panel) { // 销毁窗口
      inputMethodAbility?.destroyPanel(this.panel!);
    }
    if(this.mContext) {
      this.mContext?.destroy();
    }
  }

  public insertText(text: string): void {
    if(this.textInputClient) {
      this.textInputClient?.insertText(text);
    }
  }

  public deleteForward(length: int): void {
    if(this.textInputClient) {
      this.textInputClient?.deleteForward(length);
    }
  }

  public startAbility(): void {
    const targetWant: Want = {
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility'
    };

    this.mContext!.startAbility(targetWant).then(() => { hilog.info(0x0000, 'testTag', 'startAbility success') })
      .catch((err) => {
        let error :BusinessError = err as BusinessError;
        hilog.error(0x0000, 'testTag', 'StartAbility failed. Code: %{public}d, Message: %{public}s', error.code, error.message);
      });

  }

  private initWindow(): void {  // 初始化窗口
    if(this.mContext === undefined) {
      return;
    }
    let dis = display.getDefaultDisplaySync();
    let dWidth = dis.width as int;
    let dHeight = dis.height;
    let keyHeightRate = 0.47;
    let keyHeight = dHeight * keyHeightRate as int;
    let nonBarPosition = dHeight - keyHeight as int;
    let panelInfo: inputMethodEngine.PanelInfo = {
      type: inputMethodEngine.PanelType.SOFT_KEYBOARD,
      flag: inputMethodEngine.PanelFlag.FLG_FIXED
    };
    inputMethodAbility?.createPanel(this.mContext!, panelInfo).then((inputPanel: inputMethodEngine.Panel) => {
      this.panel = inputPanel;
      if(this.panel) {
        this.panel?.resize(dWidth, keyHeight)!;
        this.panel?.moveTo(0, nonBarPosition)!;
        this.panel?.setUiContent('entryinputmethodextability/pages/Index')!;
      }
    });
  }

  private registerListener(): void {
    this.registerInputListener(); // 注册对输入法框架服务的监听
    // 注册隐藏键盘事件监听等
  }

  private registerInputListener(): void { // 注册对输入法框架服务的开启及停止事件监听
    inputMethodAbility?.onInputStart((kbController, textInputClient) => {
      this.textInputClient = textInputClient; // 此为输入法客户端实例，由此调用输入法框架提供给输入法应用的功能接口
      this.keyboardController = kbController;
    })
    inputMethodAbility?.onInputStop(() => {
      //this.onDestroy(); // 销毁KeyboardController
    });
  }

  private unRegisterListener(): void {
    inputMethodAbility?.offInputStart();
    inputMethodAbility?.offInputStop(() => {});
  }

  public adjustPanelRect(): void {

    let landscapeRect: window.Rect = {
      left: 100,
      top: 100,
      width: 400,
      height: 400
    };

    let portraitRect: window.Rect = {
      left: 200,
      top: 200,
      width: 300,
      height: 300
    };

    // 目标面板状态类型
    let panelFlag: inputMethodEngine.PanelFlag = inputMethodEngine.PanelFlag.FLG_FIXED;
    // 目标面板横屏状态及竖屏状态的横坐标，纵坐标，宽度以及高度
    let panelRect: inputMethodEngine.PanelRect = {
      landscapeRect: landscapeRect,
      portraitRect: portraitRect
    };
    this.panel?.adjustPanelRect(panelFlag, panelRect);

  }

}

const keyboardController = new KeyboardController();

export default keyboardController;