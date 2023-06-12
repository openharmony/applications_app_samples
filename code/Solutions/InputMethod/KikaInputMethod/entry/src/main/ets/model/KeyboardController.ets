// @ts-nocheck
/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import deviceInfo from '@ohos.deviceInfo';
import inputMethodEngine from '@ohos.inputMethodEngine';
import display from '@ohos.display';
import windowManager from '@ohos.window';
import Log from './Log';
import { GetHardKeyValue } from './HardKeyUtils';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { StyleConfiguration } from '../common/StyleConfiguration';

const InputMethodEngine: inputMethodEngine.InputMethodAbility = inputMethodEngine.getInputMethodAbility();
const TAG: string = 'KeyboardController->';
const isDebug: boolean = false;

export class KeyboardController {
  private barPosition: number = 0;
  private keyCodes: Array<number> = [];
  private mContext: InputMethodExtensionContext;
  private panel: inputMethodEngine.Panel;
  private isSpecialKeyPress: boolean = false;
  private isKeyboardShow: boolean = false;
  private inputHandle: InputHandler = InputHandler.getInstance();
  private mKeyboardDelegate: inputMethodEngine.KeyboardDelegate;

  constructor(context) {
    this.inputHandle.addLog('constructor');
    this.mContext = context;
  }

  public onCreate(): void {
    this.inputHandle.addLog('onCreate');
    this.initWindow();
    this.registerListener();
  }

  public onDestroy(): void {
    this.inputHandle.addLog('onDestroy');
    this.unRegisterListener();
    this.destroyPanel();
  }

  private initWindow(): void {
    this.inputHandle.addLog('initWindow');
    let dis = display.getDefaultDisplaySync();
    this.inputHandle.addLog("initWindow-oncall display");
    var dWidth = dis.width;
    var dHeight = dis.height;
    var navigationbar_height = 75;
    var keyHeightRate = 0.43;
    AppStorage.SetOrCreate<number>('windowWidth', dis.width);
    AppStorage.SetOrCreate<number>('windowHeight', dis.height);
    let isLandscape = false;
    let isRkDevice = false;
    if (dis.width > dis.height) {
      isLandscape = true;
      AppStorage.SetOrCreate('isLandscape', true);
    } else {
      AppStorage.SetOrCreate('isLandscape', false);
    }
    if (dWidth === 1344 && dHeight === 2772) {
      navigationbar_height = 0;
      keyHeightRate = 0.38;
    }else if (dWidth === 2772 && dHeight === 1344) {
      navigationbar_height = 0;
      keyHeightRate = 0.5;
    }else if (dWidth === 720 && dHeight === 1280) {
      navigationbar_height = 72;
      AppStorage.SetOrCreate('isRkDevice', true);
      isRkDevice = true;
    }else if (dWidth === 2560 && dHeight === 1600) {
      navigationbar_height = 0;
      keyHeightRate = 0.38;
    } else if (dWidth === 1600 && dHeight === 2560) {
      navigationbar_height = 0;
      keyHeightRate = 0.3;
    }
    var keyHeight = dHeight * keyHeightRate;
    this.barPosition = dHeight - keyHeight - navigationbar_height;
    this.nonBarPosition = dHeight - keyHeight;
    this.inputHandle.addLog(`initWindow-dWidth = ${dWidth};dHeight = ${dHeight};keyboard height = ${keyHeight};;navibar height = navigationbar_height`);
    this.inputHandle.addLog(`initWindow-window = ${typeof (windowManager)}`);
    this.inputHandle.addLog(`initWindow-deviceType = ${deviceInfo.deviceType}`);
    let panelInfo: inputMethodEngine.PanelInfo = {
      type: inputMethodEngine.PanelType.SOFT_KEYBOARD,
      flag: inputMethodEngine.PanelFlag.FLG_FIXED
    }
    let inputStyle = StyleConfiguration.getInputStyle(isLandscape, isRkDevice, deviceInfo.deviceType);
    AppStorage.SetOrCreate('inputStyle', inputStyle);
    InputMethodEngine.createPanel(this.mContext, panelInfo).then(panel => {
      this.panel = panel;
      panel.resize(dWidth, keyHeight).then(() => {
        panel.moveTo(0, this.barPosition).then(() => {
          panel.setUiContent('pages/Index').then(() => {
            this.inputHandle.addLog('loadContent finished');
          })
        })
      })
    })
  }

  private destroyPanel(): void {
    this.inputHandle.addLog('destroyPanel');
    try {
      InputMethodEngine.destroyPanel(this.panel);
    } catch (error) {
      this.inputHandle.addLog(`Failed to find the Panel. Cause: ${JSON.stringify(error)}`);
    }
  }

  private resizePanel(): void {
    this.inputHandle.addLog('resizeWindow');

    let dis = display.getDefaultDisplaySync();
    this.inputHandle.addLog('resizeWindow-oncall display');

    var dWidth = dis.width;
    var dHeight = dis.height;
    var navigationbar_height = dHeight * 0.07; //todo:有些产品导航栏高度为0，默认为0.07
    var keyHeightRate = 0.43;
    AppStorage.SetOrCreate<number>('windowWidth', dis.width);
    AppStorage.SetOrCreate<number>('windowHeight', dis.height);
    let isLandscape = false;
    let isRkDevice = false;
    if (dis.width > dis.height) {
      isLandscape= true;
      AppStorage.SetOrCreate('isLandscape', true);
    } else {
      AppStorage.SetOrCreate('isLandscape', false);
    }
    if (dWidth === 1344 && dHeight === 2772) {
      navigationbar_height = 0;
      keyHeightRate = 0.38;
    }else if (dWidth === 2772 && dHeight === 1344) {
      navigationbar_height = 0;
      keyHeightRate = 0.5;
    }else if (dWidth === 720 && dHeight === 1280) {
      navigationbar_height = 72;
      AppStorage.SetOrCreate('isRkDevice', true);
      isRkDevice = true;
    }else if (dWidth === 2560 && dHeight === 1600) {
      navigationbar_height = 0;
      keyHeightRate = 0.38;
    } else if (dWidth === 1600 && dHeight === 2560) {
      navigationbar_height = 0;
      keyHeightRate = 0.3;
    }
    let keyHeight = dHeight * keyHeightRate;
    let inputStyle = StyleConfiguration.getInputStyle(isLandscape, isRkDevice, deviceInfo.deviceType);
    AppStorage.SetOrCreate('inputStyle', inputStyle);
    this.panel.resize(dWidth, keyHeight).then(() => {
      this.panel.moveTo(0, dHeight - keyHeight - navigationbar_height).then(() => {
        this.inputHandle.addLog('resizePanel-moveTo success');
      })
    }).catch(err=>{
      this.inputHandle.addLog('resizePanel-moveTo err' + JSON.stringify(err));
    })
  }

  private registerListener(): void {
    this.inputHandle.addLog('registerListener');

    display.on('change', (screenEvent) => {
      this.inputHandle.addLog('screenChangeEvent');
      this.resizePanel();
    });
    InputMethodEngine.on('inputStart', (kbController, textInputClient) => {
      this.inputHandle.addLog('keyboard inputStart');
      this.inputHandle.onInputStart(kbController, textInputClient);
    })
    InputMethodEngine.on('inputStop', () => {
      this.inputHandle.addLog('keyboard inputStop');
      this.mContext.destroy();
    });
    InputMethodEngine.on('keyboardShow', () => {
      this.inputHandle.addLog('keyboard show');
      this.showWindow();
    });

    InputMethodEngine.on('setCallingWindow', () => {
      this.inputHandle.addLog('setCallingWindow');
      this.initWindow();
    });

    InputMethodEngine.on('keyboardHide', () => {
      this.inputHandle.addLog('keyboard hide');
      AppStorage.SetOrCreate('submenuType', 0);
      this.hideWindow();
    });

    this.mKeyboardDelegate = inputMethodEngine.getKeyboardDelegate();

    this.mKeyboardDelegate.on('keyDown', (keyEvent) => {
      if (this.isKeyboardShow) {
        this.inputHandle.hideKeyboardSelf();
      }
      this.inputHandle.addLog(`keyDown: code = ${keyEvent.keyCode}`);
      let result = this.onKeyDown(keyEvent);
      this.inputHandle.addLog(`keyDown: result = ${result}`);
      return result;
    });

    this.mKeyboardDelegate.on('keyUp', (keyEvent) => {
      this.inputHandle.addLog(`keyUp: code = ${keyEvent.keyCode}`);
      let result = this.onKeyUp(keyEvent);
      this.inputHandle.addLog(`keyUp: result = ${result}`);
      return result;
    });
    this.mKeyboardDelegate.on('cursorContextChange', (x, y, height) => {
      this.inputHandle.setCursorInfo({ x: x, y: y, height: height });
    });
    if (isDebug) {
      this.mKeyboardDelegate.on('selectionChange', (oldBegin, oldEnd, newBegin, newEnd) => {
        this.inputHandle.setSelectInfo('selectInfo: from(' + oldBegin + ',' + oldEnd + ') to (' + newBegin + ',' + newEnd + ')');
      });
      this.mKeyboardDelegate.on('textChange', (text) => {
        this.inputHandle.setTextInfo('textInfo: ' + text);
      });
    }
  }

  public isShiftKeyHold(): boolean {
    if (this.keyCodes.length === 0) {
      return false;
    }
    let preDownKey = this.keyCodes[0];
    return preDownKey === KeyCode.KEYCODE_SHIFT_LEFT || preDownKey === KeyCode.KEYCODE_SHIFT_RIGHT;
  }

  public onKeyDown(keyEvent): boolean {
    this.inputHandle.addLog('onKeyDown: code = ' + keyEvent.keyCode);
    let keyCode = keyEvent.keyCode;
    let idx = this.keyCodes.indexOf(keyCode);
    if (idx === -1) {
      this.keyCodes.push(keyCode);
    } else {
      this.inputHandle.addLog(`keyCode down is intercepted: ${keyCode}}`);
    }
    this.inputHandle.addLog(`onKeyDown: this.keyCodes =  ${JSON.stringify(this.keyCodes)}}`);
    if (this.isShiftKeyHold() && this.keyCodes.length === 2 && !this.isKeyCodeAZ(keyCode)) {
      this.isSpecialKeyPress = true;
      return false;
    }
    if (this.isSpecialKeyPress || keyCode === KeyCode.KEYCODE_ALT_LEFT || keyCode === KeyCode.KEYCODE_ALT_RIGHT) {
      return false;
    }
    var keyValue = GetHardKeyValue(keyCode, this.isShiftKeyHold());
    if (!keyValue) {
      this.inputHandle.addLog('onKeyDown: unknown keyCode');
      this.isSpecialKeyPress = true;
      return false;
    }
    try {
      return this.inputHardKeyCode(keyValue, keyCode);
    } catch (error) {
      // 方向键api需要优化
      this.inputHandle.addLog(`inputHardKeyCode error: ${JSON.stringify(error)}`);
      return false;
    }
  }

  public onKeyUp(keyEvent): boolean {
    this.inputHandle.addLog('OnKeyUp: code = ' + keyEvent.keyCode);
    var keyCode = keyEvent.keyCode;
    let idx = this.keyCodes.indexOf(keyCode);
    if (idx !== -1) {
      this.keyCodes.splice(idx, 1);
    } else {
      this.inputHandle.addLog(`keyCode KeyUp is intercepted: ${keyCode}`);
    }
    this.inputHandle.addLog(`OnKeyUp: this.keyCodes = ${JSON.stringify(this.keyCodes)}`);

    // For KEYCODE_DEL/KEYCODE_FORWARD_DEL, processed in OnKeyDown, so just intercept it
    if (keyCode === 2055 || keyCode === 2071 || (keyCode >= 2012 && keyCode <= 2016)) {
      this.inputHandle.addLog(`special code: ${keyCode}`);
      return true;
    }

    if (this.isSpecialKeyPress) {
      var keyValue = GetHardKeyValue(keyCode, this.isShiftKeyHold());
      if (!keyValue) {
        this.isSpecialKeyPress = true;
      }
      if (this.keyCodes.length === 0) {
        this.isSpecialKeyPress = false;
      }
      this.inputHandle.addLog(`OnKeyUp: this.isSpecialKeyPress: ${this.isSpecialKeyPress}`);
      return false;
    }
    return true;
  }

  public isKeyCodeAZ(keyCode: number): void {
    return keyCode >= KeyCode.KEYCODE_A && keyCode <= KeyCode.KEYCODE_Z;
  }

  public isKeyCodeNumber(keyCode: number): void {
    return (keyCode >= KeyCode.KEYCODE_0 && keyCode <= KeyCode.KEYCODE_9) || (keyCode >= KeyCode.KEYCODE_NUMPAD_0 && keyCode <= KeyCode.KEYCODE_NUMPAD_9);
  }

  public inputHardKeyCode(keyValue: string, keyCode: number): boolean {
    this.inputHandle.addLog(`inputHardKeyCode keyValue is: ${keyValue}`);
    if (this.processFunctionKeys(keyValue)) {
      return true;
    }
    if (this.shiftKeys(keyValue)) {
      return false;
    }
    this.inputHandle.insertText(keyValue);
    return true;
  }

  public shiftKeys(keyValue: string): boolean {
    this.inputHandle.addLog(`shiftKeys keyValue is: ${keyValue}`);
    switch (keyValue) {
      case 'KEYCODE_SHIFT_LEFT':
      case 'KEYCODE_SHIFT_RIGHT':
        return true;
      default:
        return false;
    }
  }

  public processFunctionKeys(keyValue: string): boolean {
    this.inputHandle.addLog(`processFunctionKeys keyValue is: ${keyValue}`);
    switch (keyValue) {
      case "KEYCODE_DEL":
        this.inputHandle.deleteForward(1);
        return true;
      case "KEYCODE_FORWARD_DEL":
        this.inputHandle.deleteBackward(1);
        return true;
      case "KEYCODE_DPAD_UP":
        this.inputHandle.MoveCursor(inputMethodEngine.CURSOR_UP);
        return true;
      case "KEYCODE_DPAD_DOWN":
        this.inputHandle.MoveCursor(inputMethodEngine.CURSOR_DOWN);
        return true;
      case "KEYCODE_DPAD_LEFT":
        this.inputHandle.MoveCursor(inputMethodEngine.CURSOR_LEFT);
        return true;
      case "KEYCODE_DPAD_RIGHT":
        this.inputHandle.MoveCursor(inputMethodEngine.CURSOR_RIGHT);
        return true;
      default:
        return false;
    }
  }

  private unRegisterListener(): void {
    this.inputHandle.addLog('unRegisterListener');

    InputMethodEngine.off('inputStop', () => {
      this.inputHandle.addLog('inputStop off');
    });

    InputMethodEngine.off('keyboardShow');

    InputMethodEngine.off('keyboardHide');

    this.mKeyboardDelegate.off('keyDown');

    this.mKeyboardDelegate.off('keyUp');

    if (isDebug) {
      this.mKeyboardDelegate.off('cursorContextChange');

      this.mKeyboardDelegate.off('selectionChange');

      this.mKeyboardDelegate.off('textChange');
    }
  }

  private showWindow(): void {
    this.inputHandle.addLog('showWindow');
    this.panel.show();
  }

  private hideWindow(): void {
    this.inputHandle.addLog('hideWindow');
    this.panel.hide()
  }
}

export class InputHandler {
  private constructor() {
  }

  public static getInstance(): InputHandler {
    if (globalThis.instance === undefined) {
      globalThis.instance = new InputHandler();
    }
    return globalThis.instance;
  }

  public onInputStart(kbController, textInputClient): void {
    globalThis.mKbController = kbController;
    globalThis.mTextInputClient = textInputClient;
    globalThis.mEditorAttribute = globalThis.mTextInputClient.getEditorAttribute();
    this.addLog(`onInputStart mEditorAttribute = ${JSON.stringify(globalThis.mEditorAttribute)}`);
    globalThis.mEditorAttribute.then(res => {
      globalThis.enterKeyType = res.enterKeyType;
      globalThis.inputPattern = res.inputPattern;
      AppStorage.SetOrCreate('enterKeyType', globalThis.enterKeyType);
      AppStorage.SetOrCreate('inputPattern', globalThis.inputPattern);
      this.setInputInfo("EditorInfo：enterKeyType = " + globalThis.enterKeyType + ";inputPattern = " + globalThis.inputPattern);
    })
  }

  public hideKeyboardSelf(): void {
    this.addLog('hideKeyboardSelf');
    if (globalThis.mKbController !== undefined) {
      globalThis.mKbController.hideKeyboard();
    } else {
      this.addLog('hideKeyboardSelf globalThis.mKbController is undefined');
    }
  }

  public sendKeyFunction(): void {
    this.addLog('sendKeyFunction')
    if (globalThis.mTextInputClient !== undefined) {
      globalThis.mTextInputClient.sendKeyFunction(globalThis.enterKeyType);
    } else {
      this.addLog('sendKeyFunction globalThis.mTextInputClient is undefined');
    }
  }

  public deleteBackward(length: number): void {
    this.addLog('deleteBackward');
    if (globalThis.mTextInputClient !== undefined) {
      globalThis.mTextInputClient.deleteBackward(length);
    } else {
      this.addLog('deleteBackward globalThis.mTextInputClient is undefined');
    }
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public deleteForward(length: number): void {
    this.addLog('deleteForward');
    if (globalThis.mTextInputClient !== undefined) {
      globalThis.mTextInputClient.deleteForward(length);
    } else {
      this.addLog('deleteForward globalThis.mTextInputClient is undefined');
    }
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public insertText(text: string): void {
    this.addLog(`insertText = ${text}`);
    if (globalThis.mTextInputClient !== undefined) {
      globalThis.mTextInputClient.insertText(text);
    } else {
      this.addLog('insertText globalThis.mTextInputClient is undefined');
    }
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public addLog(message): void {
    Log.showInfo(TAG, `kikaInput-js: ${message}`);
  }

  public setCursorInfo(info): void {
    this.addLog(`setCursorInfo info = ${JSON.stringify(info)}`);
    globalThis.cursorInfo = info;
  }

  public moveCursor(direction: inputMethodEngine.Direction): void {
    if (globalThis.mTextInputClient !== undefined) {
      globalThis.mTextInputClient.moveCursor(direction);
    } else {
      this.addLog('moveCursor globalThis.mTextInputClient is undefined');
    }
  }

  public async moveCursorToBegin(): Promise<void> {
    if (globalThis.mTextInputClient !== undefined) {
      globalThis.mTextInputClient.selectByRange({ start: 0, end: 0 });
    } else {
      this.addLog('moveCursor globalThis.mTextInputClient is undefined');
    }
  }

  public async moveCursorToEnd(): Promise<void> {
    if (globalThis.mTextInputClient !== undefined) {
      this.addLog(`moveCursorToEnd`);
      globalThis.mTextInputClient.selectByRange({ start: 1000, end: 1000 });
    } else {
      this.addLog('moveCursor globalThis.mTextInputClient is undefined');
    }
  }

  public selectByMovement(direction: inputMethodEngine.Direction): void {
    if (globalThis.mTextInputClient !== undefined) {
      globalThis.mTextInputClient.selectByMovement({ direction: direction }, (err) => {
        this.addLog(`selectByMovement err is ${JSON.stringify(err)}`);
      });
    } else {
      this.addLog('selectByMovement globalThis.mTextInputClient is undefined');
    }
  }

  public async selectToBegin(): Promise<void> {
    if (globalThis.mTextInputClient !== undefined) {
      let index = await globalThis.mTextInputClient.getTextIndexAtCursor();
      this.addLog(`selectToBegin index= ${index}, x = ${globalThis.cursorInfo.x}`);
      if (index > 0) {
        globalThis.mTextInputClient.selectByRange({ start: 0, end: index });
      } else {
        globalThis.mTextInputClient.selectByRange({ start: 0, end: globalThis.cursorInfo.x });
      }
    } else {
      this.addLog('selectToBegin globalThis.mTextInputClient is undefined');
    }
  }

  public async selectToEnd(): Promise<void> {
    if (globalThis.mTextInputClient !== undefined) {
      let index = await globalThis.mTextInputClient.getTextIndexAtCursor();
      this.addLog(`selectToEnd index= ${index}, x = ${globalThis.cursorInfo.x}`);
      if (index > 0) {
        globalThis.mTextInputClient.selectByRange({ start: index, end: 1000 });
      } else {
        globalThis.mTextInputClient.selectByRange({ start: globalThis.cursorInfo.x, end: 1000 });
      }
    } else {
      this.addLog('selectToEnd globalThis.mTextInputClient is undefined');
    }
  }

  public setSelectInfo(info): void {
    globalThis.selectInfo = info;
    this.addLog(`setSelectInfo info = ${info}`);
  }

  public setTextInfo(info): void {
    globalThis.textInfo = info;
    this.addLog(`setTextInfo info = ${info}`);
  }

  public setInputInfo(info): void {
    globalThis.inputInfo = info;
    this.addLog(`setInputInfo info = ${info}`);
  }

  public refreshInfo(): void {
    this.addLog('refreshInfo');
    var showText = '';
    this.addLog('refreshInfo1');
    showText += 'five chars: before：[' + globalThis.mTextInputClient.getForward(5) + '];after：[' + globalThis.mTextInputClient.getBackward(5) + ']\n';
    this.addLog('refreshInfo2');
    showText += globalThis.cursorInfo + "\n";
    this.addLog('refreshInfo3');
    showText += globalThis.selectInfo + "\n";
    this.addLog('refreshInfo4');
    showText += globalThis.textInfo + "\n";
    this.addLog('refreshInfo5');
    showText += globalThis.inputInfo;
    this.addLog('refreshInfo6');
    AppStorage.Set<string>('showLog', showText);
    this.addLog('refreshInfo7');
    this.addLog('result is = ' + showText);
  }
}
