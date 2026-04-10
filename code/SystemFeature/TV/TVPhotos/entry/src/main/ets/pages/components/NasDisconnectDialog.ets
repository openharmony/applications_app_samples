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
 
import { KeyCode } from '@kit.InputKit'

const TAG = 'NAS_loginProgress'

@CustomDialog
export struct NasDisconnectDialog {
  controller?: CustomDialogController
  onConfirm?: () => void
  onCancel?: () => void
  @State focusStr: string = 'btn_confirm'

  aboutToAppear(): void {
    setTimeout(() => {
      this.clickFocusBtn(this.focusStr)
    }, 200)
  }

  clickFocusBtn(str: string): boolean {
    console.info(TAG, `clickFocusBtn ${str}`)
    let isSuccess = focusControl.requestFocus(str);
    if (isSuccess) {
      this.focusStr = str;
    } else {
      console.error(TAG, `requestFocus is failed , focusStr = ${str}`);
    }
    return isSuccess;
  }

  build() {
    Column() {
      Text($r('app.string.nas_disconnect'))
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .fontSize('40lpx')
      Blank()
      Row() {
        Stack() {
          Text($r('app.string.cancel'))
            .id('btn_cancel')
            .width('100%')
            .height('72lpx')
            .textAlign(TextAlign.Center)
            .fontFamily('HarmonyOS Sans')
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .fontSize('40lpx')
            .focusable(true)
            .backgroundColor('#6A6A6A')
            .borderRadius('49lpx')
            .onKeyEvent((e) => this.keyEvent(e, 'btn_cancel'))
            .onClick(()=>{
              this.onCancel && this.onCancel()
            })
        }
        .padding('5lpx')
        .border({
          width: '2lpx',
          color: this.focusStr === 'btn_cancel' ? Color.White : Color.Transparent,
          radius: '54lpx',
          style: BorderStyle.Solid
        })
        .width('240lpx')

        Blank()
        Stack() {
          Text($r('app.string.confirm'))
            .id('btn_confirm')
            .width('100%')
            .height('72lpx')
            .textAlign(TextAlign.Center)
            .fontFamily('HarmonyOS Sans')
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .fontSize('40lpx')
            .focusable(true)
            .backgroundColor('#6A6A6A')
            .borderRadius('49lpx')
            .onKeyEvent((e) => this.keyEvent(e, 'btn_confirm'))
            .onClick(()=>{
              this.onConfirm && this.onConfirm()
            })
        }
        .padding('5lpx')
        .border({
          width: '2lpx',
          color: this.focusStr === 'btn_confirm' ? Color.White : Color.Transparent,
          radius: '54lpx',
          style: BorderStyle.Solid
        })
        .width('240lpx')
      }
      .margin({ top: '18lpx' })
      .width('100%')
    }
    .padding({
      left: '48lpx',
      right: '48lpx',
      top: '36lpx',
      bottom: '24lpx'
    })
    .width('100%')
    .height('100%')
  }

  keyEvent(e: KeyEvent, currentId: string) {
    console.info(TAG, 'onKey event ' + currentId)
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down && currentId === 'btn_confirm') {
      this.clickFocusBtn('btn_cancel')
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down && currentId === 'btn_cancel') {
      this.clickFocusBtn('btn_confirm')
    }
    if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
      e.type == KeyType.Down) {
      //toto show dialog
      if (currentId === 'btn_cancel') {
        this.onCancel && this.onCancel()
      }
      if (currentId === 'btn_confirm') {
        this.onConfirm && this.onConfirm()
      }
    }
  }
}
