// @ts-nocheck
/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { GetHardKeyValue } from './HardKeyUtils.ets'
import inputMethodEngine from '@ohos.inputMethodEngine'
import settings from '@ohos.settings';
import display from '@ohos.display'
import windowManager from '@ohos.window'
import featureAbility from '@ohos.ability.featureAbility'
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import Log from './Log'

let InputMethodEngine = inputMethodEngine.getInputMethodAbility();
let isDebug = false;
let TAG: string = 'KeyboardController->';
export class KeyboardController {
  private readonly uri = 'dataability:///com.ohos.settingsdata.DataAbility'
  private helper: any = null
  private getValueRes: string = "1"
  private nonBarPosition: number = 0
  private barPosition: number = 0
  private keyCodes: Array<number> = []
  mContext
  WINDOW_TYPE_INPUT_METHOD_FLOAT= 2105
  windowName = 'imeWindow';
  isSpecialKeyPress = false;
  keySum = 0;
  isKeyboardShow = false;
  inputHandle= InputHandler.getInstance();
  mKeyboardDelegate;
  constructor(context) {
    this.inputHandle.addLog('constructor')
    this.mContext = context;
    this.helper = featureAbility.acquireDataAbilityHelper(this.mContext, this.uri)
  }

  public getValue(settingDataKey: string) {
    this.getValueRes = settings.getValueSync(this.helper, settingDataKey, "1")
  }

  public onCreate(): void {
    this.inputHandle.addLog('onCreate')
    this.initWindow();
    this.registerListener()
  }

  public onDestroy(): void {
    this.inputHandle.addLog('onDestroy')
    this.unRegisterListener();
    this.destroyWindow();
  }

  private initWindow(): void {
    this.inputHandle.addLog('initWindow')
    display.getDefaultDisplay().then(dis => {
      this.inputHandle.addLog("initWindow-oncall display");
      var dWidth = dis.width;
      var dHeight = dis.height;
      var navigationbar_height = 75;
      var keyHeightRate = 0.43;
      AppStorage.SetOrCreate<number>('windowWidth', dis.width)
      AppStorage.SetOrCreate<number>('windowHeight', dis.height)
      if (dis.width > dis.height) {
        AppStorage.SetOrCreate('isLandscape', true)
      } else {
        AppStorage.SetOrCreate('isLandscape', false)
      }
      if (dWidth == 1080 && dHeight == 2376) {
        navigationbar_height = 105
        keyHeightRate = 35 / 99
      } else if(dWidth == 720 && dHeight == 1280) {
        navigationbar_height = 72
        AppStorage.SetOrCreate('isRkDevice', true)
      } else if (dWidth == 2376 && dHeight == 1080) {
        navigationbar_height = 90
        keyHeightRate = 0.63
      } else if (dWidth == 2560 && dHeight == 1600) {
        navigationbar_height = 88
        keyHeightRate = 0.5
      } else if (dWidth == 1600 && dHeight == 2560) {
        navigationbar_height = 88
        keyHeightRate = 0.34
      }
      var keyHeight = dHeight * keyHeightRate;
      this.barPosition = dHeight - keyHeight - navigationbar_height
      this.nonBarPosition = dHeight - keyHeight
      this.inputHandle.addLog("initWindow-dWidth = " + dWidth + ";dHeight = " + dHeight + ";keyboard height = " + keyHeight + ";navibar height = " + navigationbar_height);

      this.inputHandle.addLog(typeof (this.mContext))
      this.inputHandle.addLog('initWindow-window = ' + typeof (windowManager))
      windowManager.create(this.mContext, this.windowName, this.WINDOW_TYPE_INPUT_METHOD_FLOAT).then((win) => {
        win.resetSize(dWidth, keyHeight).then(() => {
          win.moveTo(0, this.barPosition).then(() => {
            win.loadContent('pages/index').then(() => {
              this.inputHandle.addLog('loadContent finished')
            })
          })
        })
      })
    });
  }

  private destroyWindow(): void {
    this.inputHandle.addLog('destroyWindow');
    try {
      let win = windowManager.findWindow(this.windowName);
      win.destroyWindow((err) => {
        if (err) {
          this.inputHandle.addLog('Failed to destroy the window. Cause:' + JSON.stringify(err));
          return;
        }
      });
    } catch (exception) {
      this.inputHandle.addLog('Failed to find the Window. Cause: ' + JSON.stringify(exception));
    }
  }

  private resizeWindow() {
    this.inputHandle.addLog('resizeWindow');

    display.getDefaultDisplay().then(dis => {
      this.inputHandle.addLog("resizeWindow-oncall display");

      var dWidth = dis.width;
      var dHeight = dis.height;
      var navigationbar_height = dHeight * 0.07; //todo:有些产品导航栏高度为0，默认为0.07
      var keyHeightRate = 0.47;
      AppStorage.SetOrCreate<number>('windowWidth', dis.width)
      AppStorage.SetOrCreate<number>('windowHeight', dis.height)
      if (dis.width > dis.height) {
        AppStorage.Set('isLandscape', true)
      } else {
        AppStorage.Set('isLandscape', false)
      }
      if (dWidth == 1080 && dHeight == 2376) {
        navigationbar_height = 105
        keyHeightRate = 35 / 99
      } else if(dWidth == 720 && dHeight == 1280) {
        navigationbar_height = 72
      } else if (dWidth == 2376 && dHeight == 1080) {
        navigationbar_height = 90
        keyHeightRate = 0.63
      } else if (dWidth == 2560 && dHeight == 1600) {
        navigationbar_height = 88
        keyHeightRate = 0.5
      } else if (dWidth == 1600 && dHeight == 2560) {
        navigationbar_height = 88
        keyHeightRate = 0.34
      }
      var keyHeight = dHeight * keyHeightRate;
      this.inputHandle.addLog("resizeWindow-dWidth = " + dWidth + ";dHeight = " + dHeight + ";keyboard height = " + keyHeight + ";navibar height = " + navigationbar_height);

      windowManager.find(this.windowName).then((win) => {
        win.resetSize(dWidth, keyHeight).then(() => {
          win.moveTo(0, dHeight - keyHeight - navigationbar_height).then(() => {
            this.inputHandle.addLog('resizeWindow-moveTo success');
          })

        })
      })
    });
  }

  private registerListener(): void {
    this.inputHandle.addLog('registerListener')

    display.on('change', (screenEvent) => {
      this.inputHandle.addLog('screenChangeEvent');
      this.resizeWindow()
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
      this.showWindow()
    });

    InputMethodEngine.on('keyboardHide', () => {
      this.inputHandle.addLog('keyboard hide');
      this.hideWindow();
    });

    this.mKeyboardDelegate = inputMethodEngine.getKeyboardDelegate();

    this.mKeyboardDelegate.on('keyDown', (keyEvent) => {
      if (this.isKeyboardShow) {
        this.inputHandle.hideKeyboardSelf();
      }
      this.inputHandle.addLog('keyDown: code = ' + keyEvent.keyCode);
      let result = this.onKeyDown(keyEvent);
      this.inputHandle.addLog('keyDown: result = ' + result);
      return result
    });

    this.mKeyboardDelegate.on('keyUp', (keyEvent) => {
      this.inputHandle.addLog('keyUp: code = ' + keyEvent.keyCode);
      let result = this.onKeyUp(keyEvent);
      this.inputHandle.addLog('keyUp: result = ' + result);
      return result
    });

    if (isDebug) {
      this.mKeyboardDelegate.on('cursorContextChange', (x, y, height) => {
        this.inputHandle.setCursorInfo('cursorInfo：(' + x + ',' + y + '), h = ' + height);
      });

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
      return false
    }
    let preDownKey = this.keyCodes[0]
    return preDownKey === KeyCode.KEYCODE_SHIFT_LEFT || preDownKey === KeyCode.KEYCODE_SHIFT_RIGHT
  }

  public onKeyDown(keyEvent): boolean {
    this.inputHandle.addLog('onKeyDown: code = ' + keyEvent.keyCode);
    var keyCode = keyEvent.keyCode
    let idx = this.keyCodes.indexOf(keyCode)
    if (idx == -1) {
      this.keyCodes.push(keyCode)
    } else {
      this.inputHandle.addLog("keyCode down is intercepted: " + keyCode);
    }
    this.inputHandle.addLog('onKeyDown: this.keyCodes = ' + JSON.stringify(this.keyCodes));
    if (this.isShiftKeyHold() && this.keyCodes.length == 2 && !this.isKeyCodeAZ(keyCode)) {
      this.isSpecialKeyPress = true;
      return false
    }
    if (this.isSpecialKeyPress || keyCode === KeyCode.KEYCODE_ALT_LEFT || keyCode === KeyCode.KEYCODE_ALT_RIGHT) {
      return false
    }
    var keyValue = GetHardKeyValue(keyCode, this.isShiftKeyHold());
    if (!keyValue) {
      this.inputHandle.addLog('onKeyDown: unknown keyCode' );
      this.isSpecialKeyPress = true;
      return false;
    }
    try {
      return this.inputHardKeyCode(keyValue, keyCode)
    } catch (ex) {
      //方向键api需要优化
      this.inputHandle.addLog("inputHardKeyCode error: " + ex);
      return false
    }
  }

  public onKeyUp(keyEvent): boolean {
    this.inputHandle.addLog('OnKeyUp: code = ' + keyEvent.keyCode);
    var keyCode = keyEvent.keyCode;
    let idx = this.keyCodes.indexOf(keyCode)
    if (idx != -1) {
      this.keyCodes.splice(idx, 1)
    } else {
      this.inputHandle.addLog("keyCode KeyUp is intercepted: " + keyCode);
    }
    this.inputHandle.addLog('OnKeyUp: this.keyCodes = ' + JSON.stringify(this.keyCodes));

    // For KEYCODE_DEL/KEYCODE_FORWARD_DEL, processed in OnKeyDown, so just intercept it
    if (keyCode == 2055 || keyCode == 2071 || (keyCode >= 2012 && keyCode <= 2016)) {
      this.inputHandle.addLog('special code: ' + keyCode);
      return true
    }

    if (this.isSpecialKeyPress) {
      var keyValue = GetHardKeyValue(keyCode, this.isShiftKeyHold())
      if (!keyValue) {
        this.isSpecialKeyPress = true;
      }
      if (this.keyCodes.length == 0) {
        this.isSpecialKeyPress = false;
      }
      this.inputHandle.addLog('OnKeyUp: this.isSpecialKeyPress: ' + this.isSpecialKeyPress);
      return false
    }
    return true;
  }

  public isKeyCodeAZ(keyCode: number) {
    return keyCode >= KeyCode.KEYCODE_A && keyCode <= KeyCode.KEYCODE_Z
  }

  public isKeyCodeNumber(keyCode: number) {
    return (keyCode >= KeyCode.KEYCODE_0 && keyCode <= KeyCode.KEYCODE_9) || (keyCode >= KeyCode.KEYCODE_NUMPAD_0 && keyCode <= KeyCode.KEYCODE_NUMPAD_9)
  }

  public inputHardKeyCode(keyValue: string, keyCode: number): boolean {
    this.inputHandle.addLog("keyValue is: " + keyValue);
    if (this.processFunctionKeys(keyValue)) {
      return true
    }
    if (this.shiftKeys(keyValue)) {
      return false
    }
    this.inputHandle.insertText(keyValue);
    return true
  }

  public shiftKeys(keyValue: string): boolean {
    this.inputHandle.addLog("processFunctionKeys keyValue is: " + keyValue);
    switch (keyValue) {
      case 'KEYCODE_SHIFT_LEFT':
      case 'KEYCODE_SHIFT_RIGHT':
        return true
      default:
        return false
    }
  }

  public processFunctionKeys(keyValue: string): boolean {
    this.inputHandle.addLog("processFunctionKeys keyValue is: " + keyValue);
    switch (keyValue) {
      case "KEYCODE_DEL":
        this.inputHandle.deleteBackward(1);
        return true
      case "KEYCODE_FORWARD_DEL":
        this.inputHandle.deleteForward(1);
        return true
      case "KEYCODE_DPAD_UP":
        inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_UP);
        return true
      case "KEYCODE_DPAD_DOWN":
        inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_DOWN);
        return true
      case "KEYCODE_DPAD_LEFT":
        inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_LEFT);
        return true
      case "KEYCODE_DPAD_RIGHT":
        inputMethodEngine.MoveCursor(inputMethodEngine.CURSOR_RIGHT);
        return true
      default:
        return false
    }
  }

  private unRegisterListener(): void{
    this.inputHandle.addLog('unRegisterListener')

    InputMethodEngine.off('inputStop', ()=> {
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

  private showWindow() {
    try {
      this.getValue('settings.display.navigationbar_status')
    } catch (err) {
      Log.showError(TAG, "get value failed" + err)
    }
    Log.showInfo(TAG, 'current navigation state is' + this.getValueRes)
    this.inputHandle.addLog('showWindow');
    windowManager.find(this.windowName).then((win) => {
      win.show().then(() => {
        this.inputHandle.addLog('showWindow finish');
        this.isKeyboardShow = true;
      })
    })
  }

  private hideWindow() {
    this.inputHandle.addLog('hideWindow');
    windowManager.find(this.windowName).then((win) => {
      win.hide().then(() => {
        this.isKeyboardShow = false;
        this.inputHandle.addLog('hideWindow finish');
      })
    })
  }
}

export class InputHandler {
  private static instance: InputHandler;
  private mKbController;
  private mTextInputClient;
  private mEditorAttribute;
  private cursorInfo;
  private selectInfo;
  private textInfo;
  private inputInfo;
  private constructor() {

  }

  public static getInstance() {
    if (globalThis.instance == null) {
      globalThis.instance = new InputHandler();
    }
    return globalThis.instance;
  }

  public onInputStart(kbController, textInputClient) {
    globalThis.mKbController = kbController;
    globalThis.mTextInputClient = textInputClient;
    globalThis.mEditorAttribute = globalThis.mTextInputClient.getEditorAttribute();
    this.addLog("onInputStart mEditorAttribute = " + globalThis.mEditorAttribute);
    globalThis.mEditorAttribute.then(res => {
      globalThis.enterKeyType = res.enterKeyType;
      globalThis.inputPattern = res.inputPattern;
      this.setInputInfo("EditorInfo：enterKeyType = " + globalThis.enterKeyType + ";inputPattern = " + globalThis.inputPattern);
    })
  }

  public hideKeyboardSelf() {
    this.addLog('hideKeyboardSelf')
    if (globalThis.mKbController != undefined) {
      globalThis.mKbController.hideKeyboard();
    } else {
      this.addLog('hideKeyboardSelf globalThis.mKbController is undefined')
    }
  }

  public sendKeyFunction() {
    this.addLog('sendKeyFunction')
    if (globalThis.mTextInputClient != undefined) {
      globalThis.mTextInputClient.sendKeyFunction(globalThis.enterKeyType);
    } else {
      this.addLog('sendKeyFunction globalThis.mTextInputClient is undefined')
    }
  }

  public deleteBackward(length: number) {
    this.addLog('deleteBackward')
    if (globalThis.mTextInputClient != undefined) {
      globalThis.mTextInputClient.deleteBackward(length);
    } else {
      this.addLog('deleteBackward globalThis.mTextInputClient is undefined')
    }
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public deleteForward(length: number) {
    this.addLog('deleteForward')
    if (globalThis.mTextInputClient != undefined) {
      globalThis.mTextInputClient.deleteForward(length);
    } else {
      this.addLog('deleteForward globalThis.mTextInputClient is undefined')
    }
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public insertText(text: string) {
    this.addLog('insertText')
    if (globalThis.mTextInputClient != undefined) {
      globalThis.mTextInputClient.insertText(text);
    } else {
      this.addLog('insertText globalThis.mTextInputClient is undefined')
    }
    if (isDebug) {
      this.refreshInfo();
    }
  }

  public addLog(message): void {
    Log.showInfo(TAG, "kikaInput-js: " + message)
  }

  public setCursorInfo(info) {
    globalThis.cursorInfo = info;
    this.addLog("setCursorInfo info = " + info);
  }

  public setSelectInfo(info) {
    globalThis.selectInfo = info;
    this.addLog("setSelectInfo info = " + info);
  }

  public setTextInfo(info) {
    globalThis.textInfo = info;
    this.addLog("setTextInfo info = " + info);
  }

  public setInputInfo(info) {
    globalThis.inputInfo = info;
    this.addLog("setInputInfo info = " + info);
  }

  public refreshInfo() {
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
