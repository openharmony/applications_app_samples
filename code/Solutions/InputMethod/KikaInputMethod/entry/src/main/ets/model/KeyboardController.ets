/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import InputMethodExtensionContext from '@ohos.InputMethodExtensionContext';
import display from '@ohos.display';
import windowManager from '@ohos.window';
import Log from './Log';
import { BusinessError } from '@ohos.base';
import { GetHardKeyValue } from './HardKeyUtils';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { StyleConfiguration } from '../common/StyleConfiguration';

interface DeviceSize {
  width: number;
  height: number;
}

interface CursorInfo {
  x: number;
  y: number;
  height: number
}
const previewContent: string  = 'hello world';
const InputMethodEngine: inputMethodEngine.InputMethodAbility = inputMethodEngine.getInputMethodAbility();
const TAG: string = 'KeyboardController->';
const isDebug: boolean = false;
// 定义不同设备的宽高，用于键盘显示适配不同设备
const DEVICE_PHONE: DeviceSize = {
  width: 1344,
  height: 2772
}
const DEVICE_RK: DeviceSize = {
  width: 720,
  height: 1280
}
const DEVICE_BIG: DeviceSize = {
  width: 2560,
  height: 1600
}
// 定义键盘在不同设备上占设备高度的比例，用于键盘显示适配不同设备
const KEYBOARD_HEIGHT_RATE_DEFAULT: number = 0.43;
const KEYBOARD_HEIGHT_RATE_PHONE: number = 0.38;
const KEYBOARD_HEIGHT_RATE_PHONE_LAND: number = 0.5;
const KEYBOARD_HEIGHT_RATE_BIG_LAND: number = 0.38;
const KEYBOARD_HEIGHT_RATE_BIG: number = 0.3;
// 定义默认的底部导航栏高度
const NAVIGATIONBAR_HEIGHT_DEFAULT: number = 72;

export class InputHandler {
  private mKbController: inputMethodEngine.KeyboardController | undefined;
  private mTextInputClient: inputMethodEngine.InputClient | undefined;
  private mEditorAttribute: inputMethodEngine.EditorAttribute | undefined;
  private cursorInfo: CursorInfo = { x: 0, y: 0, height: 0 };
  private selectInfo: string = '';
  private textInfo: string = '';
  private inputInfo: string = '';
  private intputText: string = '';

  private constructor() {
    this.mKbController = undefined;
    this.mTextInputClient = undefined;
    this.mEditorAttribute = undefined;
  }

  public static getInstance(): InputHandler {
    let instance = AppStorage.get<InputHandler>('inputHandler');
    if (instance === undefined) {
      instance = new InputHandler();
      AppStorage.setOrCreate('inputHandler', instance);
    }
    return instance;
  }

  public onInputStart(kbController: inputMethodEngine.KeyboardController, textInputClient: inputMethodEngine.InputClient): void {
    this.mKbController = kbController;
    this.mTextInputClient = textInputClient;
    let editorAttribute = this.mTextInputClient.getEditorAttribute();
    this.addLog(`onInputStart editorAttribute = ${JSON.stringify(editorAttribute)}`);
    editorAttribute.then((res: inputMethodEngine.EditorAttribute) => {
      this.mEditorAttribute = res;
      AppStorage.setOrCreate('enterKeyType', res.enterKeyType);
      AppStorage.setOrCreate('inputPattern', res.inputPattern);

      this.setInputInfo('EditorInfo：enterKeyType = ' + this.mEditorAttribute.enterKeyType + ';inputPattern = ' + this.mEditorAttribute.inputPattern +
        '; isTextPreviewSupported = ' + this.mEditorAttribute.isTextPreviewSupported);
    })
    try {
      this.addLog(`onInputStart sendPrivateCommand begin`);
      let record: Record<string, inputMethodEngine.CommandDataType> = {
        'previewTextStyle': 'underline'
      };

      this.mTextInputClient.sendPrivateCommand(record).then((err) => {
        this.addLog(`insertText sendPrivateCommand success`);
      }).catch((err:BusinessError) => {
        if (err !== undefined) {
          let error = err as BusinessError;
          this.addLog(`insertText sendPrivateCommand catch error: ${error.code} ${error.message}`);
        }
      });
    } catch (err) {
      let error = err as BusinessError;
      this.addLog(`insertText sendPrivateCommand catch error: ${error.code} ${error.message}`);
    }
  }

  public hideKeyboardSelf(): void {
    this.addLog('hideKeyboardSelf');
    if (this.mKbController !== undefined) {
      this.mKbController.hide();
    } else {
      this.addLog('hideKeyboardSelf this.mKbController is undefined');
    }
  }

  public sendKeyFunction(): void {
    this.addLog('sendKeyFunction')
    if (this.mTextInputClient && this.mEditorAttribute) {
      this.mTextInputClient.sendKeyFunction(this.mEditorAttribute.enterKeyType);

      //调用结束预上屏接口, 预上屏内容将被系统正式上屏
      this.mTextInputClient.finishTextPreview().then(() => {
        this.addLog('Succeeded in finishing text preview.');
      }).catch((err: BusinessError) => {
        console.error(`Failed to finishTextPreview: ${JSON.stringify(err)}`);
      });
    } else {
      this.addLog('sendKeyFunction this.mTextInputClient is undefined');
    }
  }

  public deleteBackward(length: number): void {
    this.addLog('deleteBackward');
    if (this.mTextInputClient !== undefined) {
      this.mTextInputClient.deleteBackward(length);
    } else {
      this.addLog('deleteBackward this.mTextInputClient is undefined');
    }
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public deleteForward(length: number): void {
    this.addLog('deleteForward');
    if (this.mTextInputClient !== undefined) {
      this.mTextInputClient.deleteForward(length);
    } else {
      this.addLog('deleteForward this.mTextInputClient is undefined');
    }
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public insertText(text: string): void {
    this.addLog(`insertText = ${text}`);
    if (this.mTextInputClient !== undefined) {
      this.mTextInputClient.insertText(text);

      let indexCursor: number = 0;
      indexCursor = this.mTextInputClient.getTextIndexAtCursorSync();
      this.intputText = this.mTextInputClient.getForwardSync(indexCursor);
      this.intputText = this.intputText + text;

      //设置预上屏数据
      let length = 2;
      let textPre: string = this.mTextInputClient.getForwardSync(length);
      this.addLog('insertText textPre:' + textPre);

      // 取出的内容为当前输入之前的字符，不包含当前的字符,需将当前字符加上
      textPre = textPre + text;
      if (textPre == 'hel') {
        this.addLog('insertText hel');
        try {
          //把当前字符计算在内
          let endRange: number = indexCursor + 1;
          this.addLog('insertText start ' + (indexCursor - length).toString());
          this.addLog('insertText end ' + (indexCursor).toString());
          let range: inputMethodEngine.Range = { start: indexCursor - length, end: endRange };
          this.mTextInputClient.setPreviewText(previewContent, range).then(() => {
            this.addLog('insertText preViewText Succeeded in setting preview text.');
          }).catch((err: BusinessError) => {
            this.addLog(`insertText preViewText Failed to setPreviewText: ${JSON.stringify(err)}`);
          });
        } catch (err) {
          this.addLog(`insertText preViewText Failed to setPreviewText: ${JSON.stringify(err)}`);
        }
      } else if (this.intputText.length > length + 1) {
        this.addLog('insertText this.intputText ' + this.intputText);

        let indexSubStrStart: number = this.intputText.lastIndexOf('hel');
        this.addLog('insertText indexSubStrStart ' + indexSubStrStart.toString());

        if (indexSubStrStart >= 0) {
          // 当前文本框存在预上屏的部分内容
          let subStr: string = this.intputText.substring(indexSubStrStart, indexCursor);
          this.addLog('insertText indexSubStrStart subStr ' + subStr);

          if((previewContent != subStr) && (previewContent.includes(subStr))) {
            // 文本框的子串与预上屏内容吻合，则调用预上屏接口，替换文本框的子串
            this.addLog('insertText previewContent indexSubStrStart ' + indexSubStrStart.toString());
            this.addLog('insertText previewContent end ' + (indexCursor).toString());
            let range: inputMethodEngine.Range = { start: indexSubStrStart, end: indexCursor + 1 };
            this.mTextInputClient.setPreviewText(previewContent, range).then(() => {
              this.addLog('insertText preViewText Succeeded in setting preview text.');
            }).catch((err: BusinessError) => {
              this.addLog(`insertText preViewText Failed to setPreviewText: ${JSON.stringify(err)}`);
            });
          }
        }
      }
    } else {
      this.addLog('insertText this.mTextInputClient is undefined');
    }
    if (isDebug) {
      this.refreshInfo();
    }

  }

  public addLog(message: string): void {
    Log.showInfo(TAG, `kikaInput-js: ${message}`);
  }

  public setCursorInfo(info: CursorInfo): void {
    this.addLog(`setCursorInfo info = ${JSON.stringify(info)}`);
    this.cursorInfo = info;
  }

  public moveCursor(direction: inputMethodEngine.Direction): void {
    if (this.mTextInputClient !== undefined) {
      this.addLog(`moveCursor direction = ${direction}`);
      this.mTextInputClient.moveCursor(direction);
    } else {
      this.addLog('moveCursor this.mTextInputClient is undefined');
    }
  }

  public async moveCursorToBegin(): Promise<void> {
    if (this.mTextInputClient !== undefined) {
      this.mTextInputClient.selectByRange({ start: 0, end: 0 });
    } else {
      this.addLog('moveCursor this.mTextInputClient is undefined');
    }
  }

  public async moveCursorToEnd(): Promise<void> {
    if (this.mTextInputClient !== undefined) {
      this.addLog(`moveCursorToEnd`);
      this.mTextInputClient.selectByRange({ start: 1000, end: 1000 });
    } else {
      this.addLog('moveCursor this.mTextInputClient is undefined');
    }
  }

  public selectByMovement(direction: inputMethodEngine.Direction): void {
    if (this.mTextInputClient !== undefined) {
      this.mTextInputClient.selectByMovement({ direction: direction }, (err: BusinessError) => {
        this.addLog(`selectByMovement err is ${JSON.stringify(err)}`);
      });
    } else {
      this.addLog('selectByMovement this.mTextInputClient is undefined');
    }
  }

  public async selectToBegin(): Promise<void> {
    if (this.mTextInputClient !== undefined) {
      let index = await this.mTextInputClient.getTextIndexAtCursor();
      this.addLog(`selectToBegin index= ${index}, x = ${this.cursorInfo.x}`);
      if (index > 0) {
        this.mTextInputClient.selectByRange({ start: 0, end: index });
      } else {
        this.mTextInputClient.selectByRange({ start: 0, end: this.cursorInfo.x });
      }
    } else {
      this.addLog('selectToBegin this.mTextInputClient is undefined');
    }
  }

  public async selectToEnd(): Promise<void> {
    if (this.mTextInputClient !== undefined) {
      let index = await this.mTextInputClient.getTextIndexAtCursor();
      this.addLog(`selectToEnd index= ${index}, x = ${this.cursorInfo.x}`);
      if (index > 0) {
        this.mTextInputClient.selectByRange({ start: index, end: 1000 });
      } else {
        this.mTextInputClient.selectByRange({ start: this.cursorInfo.x, end: 1000 });
      }
    } else {
      this.addLog('selectToEnd this.mTextInputClient is undefined');
    }
  }

  public sendExtendAction(action: inputMethodEngine.ExtendAction): void {
    if (this.mTextInputClient !== undefined) {
      this.mTextInputClient.sendExtendAction(action);
    } else {
      this.addLog('sendExtendAction this.mTextInputClient is undefined');
    }
  }

  public setSelectInfo(info: string): void {
    this.selectInfo = info;
    this.addLog(`setSelectInfo info = ${info}`);
  }

  public setTextInfo(info: string): void {
    this.textInfo = info;
    this.addLog(`setTextInfo info = ${info}`);
  }

  public setInputInfo(info: string): void {
    this.inputInfo = info;
    this.addLog(`setInputInfo info = ${info}`);
  }

  public refreshInfo(): void {
    this.addLog('refreshInfo');
    let showText = '';
    this.addLog('refreshInfo1');
    if (this.mTextInputClient) {
      showText += 'five chars: before：[' + this.mTextInputClient.getForward(5) + '];after：[' + this.mTextInputClient.getBackward(5) + ']\n';
    }
    this.addLog('refreshInfo2');
    showText += this.cursorInfo + "\n";
    this.addLog('refreshInfo3');
    showText += this.selectInfo + "\n";
    this.addLog('refreshInfo4');
    showText += this.textInfo + "\n";
    this.addLog('refreshInfo5');
    showText += this.inputInfo;
    this.addLog('refreshInfo6');
    AppStorage.set<string>('showLog', showText);
    this.addLog('refreshInfo7');
    this.addLog('result is = ' + showText);
  }
}

class KeyboardController {
  private barPosition: number = 0;
  private keyCodes: Array<number> = [];
  private mContext: InputMethodExtensionContext | undefined;
  private panel: inputMethodEngine.Panel | undefined;
  private isSpecialKeyPress: boolean = false;
  private isKeyboardShow: boolean = false;
  private inputHandle: InputHandler = InputHandler.getInstance();
  private mKeyboardDelegate: inputMethodEngine.KeyboardDelegate | undefined;

  constructor() {
    this.mContext = undefined;
    this.panel = undefined;
    this.mKeyboardDelegate = undefined;
  }

  public onCreate(context: InputMethodExtensionContext): void {
    this.mContext = context;
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
    if (this.mContext === undefined) {
      return;
    }
    this.inputHandle.addLog('initWindow');
    let dis = display.getDefaultDisplaySync();
    this.inputHandle.addLog("initWindow-oncall display");
    let dWidth = dis.width;
    let dHeight = dis.height;
    let navigationBar_height = NAVIGATIONBAR_HEIGHT_DEFAULT;
    let keyHeightRate = KEYBOARD_HEIGHT_RATE_DEFAULT;
    AppStorage.setOrCreate('windowWidth', dis.width);
    AppStorage.setOrCreate('windowHeight', dis.height);
    let isLandscape = false;
    let isRkDevice = false;
    if (dis.width > dis.height) {
      isLandscape = true;
      AppStorage.setOrCreate('isLandscape', true);
    } else {
      AppStorage.setOrCreate('isLandscape', false);
    }
    if (dWidth === DEVICE_PHONE.width && dHeight === DEVICE_PHONE.height) {
      navigationBar_height = 0;
      keyHeightRate = KEYBOARD_HEIGHT_RATE_PHONE;
    } else if (dWidth === DEVICE_PHONE.height && dHeight === DEVICE_PHONE.width) {
      navigationBar_height = 0;
      keyHeightRate = KEYBOARD_HEIGHT_RATE_PHONE_LAND;
    } else if (dWidth === DEVICE_RK.width && dHeight === DEVICE_RK.height) {
      navigationBar_height = KEYBOARD_HEIGHT_RATE_DEFAULT;
      AppStorage.setOrCreate('isRkDevice', true);
      isRkDevice = true;
    } else if (dWidth === DEVICE_BIG.width && dHeight === DEVICE_BIG.height) {
      navigationBar_height = 0;
      keyHeightRate = KEYBOARD_HEIGHT_RATE_BIG_LAND;
    } else if (dWidth === DEVICE_BIG.height && dHeight === DEVICE_BIG.width) {
      navigationBar_height = 0;
      keyHeightRate = KEYBOARD_HEIGHT_RATE_BIG;
    }
    let keyHeight = dHeight * keyHeightRate;
    this.barPosition = dHeight - keyHeight - navigationBar_height;
    this.inputHandle.addLog(`initWindow-dWidth = ${dWidth};dHeight = ${dHeight};keyboard height = ${keyHeight};;navibar height = navigationBar_height`);
    this.inputHandle.addLog(`initWindow-deviceType = ${deviceInfo.deviceType}`);
    let panelInfo: inputMethodEngine.PanelInfo = {
      type: inputMethodEngine.PanelType.SOFT_KEYBOARD,
      flag: inputMethodEngine.PanelFlag.FLG_FIXED
    }
    let inputStyle = StyleConfiguration.getInputStyle(isLandscape, isRkDevice, deviceInfo.deviceType);
    AppStorage.setOrCreate('inputStyle', inputStyle);
    InputMethodEngine.createPanel(this.mContext, panelInfo).then((panel: inputMethodEngine.Panel) => {
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
    if (this.panel) {
      InputMethodEngine.destroyPanel(this.panel);
    }
  }

  private resizePanel(): void {
    this.inputHandle.addLog('resizeWindow');
    let dis = display.getDefaultDisplaySync();
    this.inputHandle.addLog('resizeWindow-oncall display');
    let dWidth = dis.width;
    let dHeight = dis.height;
    let navigationBar_height = dHeight * 0.07; // 有些产品导航栏高度为0，默认为0.07
    let keyHeightRate = KEYBOARD_HEIGHT_RATE_DEFAULT;
    AppStorage.setOrCreate<number>('windowWidth', dis.width);
    AppStorage.setOrCreate<number>('windowHeight', dis.height);
    let isLandscape = false;
    let isRkDevice = false;
    if (dis.width > dis.height) {
      isLandscape = true;
      AppStorage.setOrCreate('isLandscape', true);
    } else {
      AppStorage.setOrCreate('isLandscape', false);
    }
    if (dWidth === DEVICE_PHONE.width && dHeight === DEVICE_PHONE.height) {
      navigationBar_height = 0;
      keyHeightRate = KEYBOARD_HEIGHT_RATE_PHONE;
    } else if (dWidth === DEVICE_PHONE.height && dHeight === DEVICE_PHONE.width) {
      navigationBar_height = 0;
      keyHeightRate = KEYBOARD_HEIGHT_RATE_PHONE_LAND;
    } else if (dWidth === DEVICE_RK.width && dHeight === DEVICE_RK.height) {
      navigationBar_height = KEYBOARD_HEIGHT_RATE_DEFAULT;
      AppStorage.setOrCreate('isRkDevice', true);
      isRkDevice = true;
    } else if (dWidth === DEVICE_BIG.width && dHeight === DEVICE_BIG.height) {
      navigationBar_height = 0;
      keyHeightRate = KEYBOARD_HEIGHT_RATE_BIG_LAND;
    } else if (dWidth === DEVICE_BIG.height && dHeight === DEVICE_BIG.width) {
      navigationBar_height = 0;
      keyHeightRate = KEYBOARD_HEIGHT_RATE_BIG;
    }
    let keyHeight = dHeight * keyHeightRate;
    let inputStyle = StyleConfiguration.getInputStyle(isLandscape, isRkDevice, deviceInfo.deviceType);
    AppStorage.setOrCreate('inputStyle', inputStyle);
    if (this.panel) {
      this.panel.resize(dWidth, keyHeight).then(() => {
        if (this.panel) {
          this.panel.moveTo(0, dHeight - keyHeight - navigationBar_height).then(() => {
            this.inputHandle.addLog('resizePanel-moveTo success');
          })
        }
      }).catch((err: BusinessError) => {
        this.inputHandle.addLog('resizePanel-moveTo err' + JSON.stringify(err));
      })
    }
  }

  private registerListener(): void {
    this.inputHandle.addLog('registerListener');

    display.on('change', () => {
      this.inputHandle.addLog('screenChangeEvent');
      this.resizePanel();
    });
    InputMethodEngine.on('inputStart', (kbController: inputMethodEngine.KeyboardController, textInputClient: inputMethodEngine.InputClient) => {
      this.inputHandle.addLog('keyboard inputStart');
      this.inputHandle.onInputStart(kbController, textInputClient);
    })
    InputMethodEngine.on('inputStop', () => {
      this.inputHandle.addLog('keyboard inputStop');
      this.onDestroy();
      if (this.mContext) {
        this.mContext.destroy();
      }
    });

    this.inputHandle.addLog('pre on privateCommand');
    try {
      InputMethodEngine.on('privateCommand', (record : Record<string, inputMethodEngine.CommandDataType>) => {
        this.inputHandle.addLog('keyboard privateCommand' + JSON.stringify(record));
        Object.keys(record).forEach((key: string) => {
          this.inputHandle.addLog(`onPageShow private command key: ${key}, value: ${record[key]}`);
        })
      });
    } catch (err) {
      let error = err as BusinessError;
      this.inputHandle.addLog(`on privateCommand sendPrivateCommand catch error: ${error.code} ${error.message}`);
    }

    this.mKeyboardDelegate = inputMethodEngine.getKeyboardDelegate();

    this.mKeyboardDelegate.on('keyDown', (keyEvent: inputMethodEngine.KeyEvent) => {
      if (this.isKeyboardShow) {
        this.inputHandle.hideKeyboardSelf();
      }
      this.inputHandle.addLog(`keyDown: code = ${keyEvent.keyCode}`);
      let result = this.onKeyDown(keyEvent);
      this.inputHandle.addLog(`keyDown: result = ${result}`);
      return result;
    });

    this.mKeyboardDelegate.on('keyUp', (keyEvent: inputMethodEngine.KeyEvent) => {
      this.inputHandle.addLog(`keyUp: code = ${keyEvent.keyCode}`);
      let result = this.onKeyUp(keyEvent);
      this.inputHandle.addLog(`keyUp: result = ${result}`);
      return result;
    });
    this.mKeyboardDelegate.on('cursorContextChange', (x: number, y: number, height: number) => {
      let cursorInfo: CursorInfo = { x: x, y: y, height: height };
      this.inputHandle.setCursorInfo(cursorInfo);
    });
    if (isDebug) {
      this.mKeyboardDelegate.on('selectionChange', (oldBegin: number, oldEnd: number, newBegin: number, newEnd: number) => {
        this.inputHandle.setSelectInfo('selectInfo: from(' + oldBegin + ',' + oldEnd + ') to (' + newBegin + ',' + newEnd + ')');
      });
      this.mKeyboardDelegate.on('textChange', (text: string) => {
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

  public onKeyDown(keyEvent: inputMethodEngine.KeyEvent): boolean {
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
    let keyValue: string = GetHardKeyValue(keyCode, this.isShiftKeyHold());
    if (keyValue === '') {
      this.inputHandle.addLog('onKeyDown: unknown keyCode');
      this.isSpecialKeyPress = true;
      return false;
    }
    return this.inputHardKeyCode(keyValue, keyCode);
  }

  public onKeyUp(keyEvent: inputMethodEngine.KeyEvent): boolean {
    this.inputHandle.addLog('OnKeyUp: code = ' + keyEvent.keyCode);
    let keyCode = keyEvent.keyCode;
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
      let keyValue = GetHardKeyValue(keyCode, this.isShiftKeyHold());
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

  public isKeyCodeAZ(keyCode: number): boolean {
    return keyCode >= KeyCode.KEYCODE_A && keyCode <= KeyCode.KEYCODE_Z;
  }

  public isKeyCodeNumber(keyCode: number): boolean {
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
        this.inputHandle.moveCursor(inputMethodEngine.Direction.CURSOR_UP);
        return true;
      case "KEYCODE_DPAD_DOWN":
        this.inputHandle.moveCursor(inputMethodEngine.Direction.CURSOR_DOWN);
        return true;
      case "KEYCODE_DPAD_LEFT":
        this.inputHandle.moveCursor(inputMethodEngine.Direction.CURSOR_LEFT);
        return true;
      case "KEYCODE_DPAD_RIGHT":
        this.inputHandle.moveCursor(inputMethodEngine.Direction.CURSOR_RIGHT);
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
    if (this.mKeyboardDelegate) {
      this.mKeyboardDelegate.off('keyDown');
      this.mKeyboardDelegate.off('keyUp');
      if (isDebug) {
        this.mKeyboardDelegate.off('cursorContextChange');
        this.mKeyboardDelegate.off('selectionChange');
        this.mKeyboardDelegate.off('textChange');
      }
    }
  }
}

export const keyboardController: KeyboardController = new KeyboardController();