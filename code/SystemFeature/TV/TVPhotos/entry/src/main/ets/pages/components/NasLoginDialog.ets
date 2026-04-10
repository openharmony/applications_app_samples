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
import { promptAction } from '@kit.ArkUI'

const TAG = 'NAS_LoginDialog'
const ROW_SIZE = 3
const COLUMN_SIZE = 2

@CustomDialog
export struct NasLoginDialog {
  controller?: CustomDialogController
  onConfirm?: (username: string, password: string) => void
  onCancel?: () => void
  @State userName: string = ''
  @State password: string = ''
  @State focusStr: string = 'id_0_0'
  @State eyeOpen: boolean = false
  private ids: string[][] = []

  aboutToAppear(): void {
    setTimeout(() => {
      this.clickFocusBtn(this.focusStr)
    }, 200)

    for (let i = 0; i < ROW_SIZE; i++) {
      let columnIds: string[] = []
      for (let j = 0; j < COLUMN_SIZE; j++) {
        if (i === 0) {
          columnIds[j] = `id_${i}_${0}`
        } else {
          columnIds[j] = `id_${i}_${j}`
        }
      }
      this.ids[i] = columnIds
    }
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
      Text($r('app.string.nas_login_title'))
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .fontSize('48lpx')
      Row() {
        TextInput({
          placeholder: $r('app.string.nas_login_username'),
          text: $$this.userName
        })
          .id('id_0_0')
          .fontSize('40lpx')
          .focusable(true)
          .defaultFocus(true)
          .width('100%')
          .height('98lpx')
          .backgroundColor(this.focusStr === 'id_0_0' ? Color.White : Color.White)
          .borderRadius('49lpx')
          .onFocus(() => {
            console.info(TAG, 'id_0_0 focus')
          })
          .onKeyEvent((e) => this.keyEvent(e, 'id_0_0'))
      }
      .padding('5lpx')
      .border({
        width: '2lpx',
        color: this.focusStr === 'id_0_0' ? Color.White : Color.Transparent,
        radius: '54lpx',
        style: BorderStyle.Solid
      })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({ top: '24lpx' })

      Row() {
        Row() {
          TextInput({
            placeholder: $r('app.string.nas_login_password'),
            text: $$this.password
          })
            .id('id_1_0')
            .fontSize('40lpx')
            .type(InputType.Password)
            .showPassword(this.eyeOpen)
            .showPasswordIcon(false)
            .focusable(true)
            .width('100%')
            .height('98lpx')
            .backgroundColor(this.focusStr === 'id_1_0' ? Color.White : Color.White)
            .borderRadius('49lpx')
            .onKeyEvent((e) => this.keyEvent(e, 'id_1_0'))
        }
        .padding('5lpx')
        .border({
          width: '2lpx',
          color: this.focusStr === 'id_1_0' ? Color.White : Color.Transparent,
          radius: '54lpx',
          style: BorderStyle.Solid
        })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('453lpx')

        Blank()
        Image(this.getEyeResource(this.focusStr, this.eyeOpen))
          .id('id_1_1')
          .width('98lpx')
          .height('98lpx')
          .onKeyEvent((e) => this.keyEvent(e, 'id_1_1'))
          .onClick(() => {
            this.eyeOpen = !this.eyeOpen
          })
      }
      .width('100%')
      .margin({ top: '18lpx' })

      Row() {
        Stack() {
          Text($r('app.string.cancel'))
            .id('id_2_0')
            .width('100%')
            .height('98lpx')
            .textAlign(TextAlign.Center)
            .fontFamily('HarmonyOS Sans')
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .fontSize('40lpx')
            .focusable(true)
            .backgroundColor('#6A6A6A')
            .borderRadius('49lpx')
            .onKeyEvent((e) => this.keyEvent(e, 'id_2_0'))
            .onClick(()=>{
              this.onCancel && this.onCancel()
            })
        }
        .padding('5lpx')
        .border({
          width: '2lpx',
          color: this.focusStr === 'id_2_0' ? Color.White : Color.Transparent,
          radius: '54lpx',
          style: BorderStyle.Solid
        })
        .width('264lpx')

        Blank()
        Stack() {
          Text($r('app.string.confirm'))
            .id('id_2_1')
            .width('100%')
            .height('98lpx')
            .textAlign(TextAlign.Center)
            .fontFamily('HarmonyOS Sans')
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .fontSize('40lpx')
            .focusable(true)
            .backgroundColor('#6A6A6A')
            .borderRadius('49lpx')
            .onKeyEvent((e) => this.keyEvent(e, 'id_2_1'))
            .onClick(()=>{
              if (this.userName === '' || this.password === '') {
                promptAction.showToast({
                  message: $r('app.string.nas_login_password_need')
                })
              } else {
                this.onConfirm && this.onConfirm(this.userName, this.password)
              }
            })
        }
        .padding('5lpx')
        .border({
          width: '2lpx',
          color: this.focusStr === 'id_2_1' ? Color.White : Color.Transparent,
          radius: '54lpx',
          style: BorderStyle.Solid
        })
        .width('264lpx')
      }
      .margin({ top: '18lpx' })
      .width('100%')
    }
    .padding({
      left: '48lpx',
      right: '48lpx',
      top: '24lpx',
      bottom: '24lpx'
    })
    .width('100%')
    .height('100%')
  }

  getEyeResource(focusStr: string, eyeOpen: boolean): Resource {
    if (focusStr === 'id_1_1') {
      return eyeOpen ? $r('app.media.onfocus_eyeopen') : $r('app.media.onfocus_eyeclose')
    } else {
      return eyeOpen ? $r('app.media.onblur_eyeopen') : $r('app.media.onblur_eyeclose')
    }
  }

  keyEvent(e: KeyEvent, currentId: string) {
    console.info(TAG, 'onKey event ' + currentId)
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
      this.nextComponentFocus(currentId, 'left')
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
      this.nextComponentFocus(currentId, 'right')
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
      this.nextComponentFocus(currentId, 'down')
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
      this.nextComponentFocus(currentId, 'up')
    }
    if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
      e.type == KeyType.Down) {
      //toto show dialog
      if (currentId === 'id_1_1') {
        this.eyeOpen = !this.eyeOpen
      }
      if (currentId === 'id_2_0') {
        this.onCancel && this.onCancel()
      }
      if (currentId === 'id_2_1') {
        if (this.userName === '' || this.password === '') {
          promptAction.showToast({
            message: $r('app.string.nas_login_password_need')
          })
        } else {
          this.onConfirm && this.onConfirm(this.userName, this.password)
        }
      }
    }
  }

  nextComponentFocus(currentId: string, direction: 'left' | 'up' | 'right' | 'down') {
    console.info(TAG, 'currentId = ' + currentId + ' direction = ' + direction)
    let currentRowIndex = 0
    let currentColumnIndex = 0
    let found = false
    this.ids.forEach((row, rowIndex) => {
      row.forEach((column, columIndex) => {
        if (currentId === column && !found) {
          currentRowIndex = rowIndex
          currentColumnIndex = columIndex
          found = true
        }
      })
    })
    if (direction === 'left') {
      currentColumnIndex--
    } else if (direction === 'right') {
      currentColumnIndex++
    } else if (direction === 'up') {
      currentRowIndex--
    } else {
      currentRowIndex++
    }
    if (currentRowIndex >= 0 && currentRowIndex < ROW_SIZE && currentColumnIndex >= 0 &&
      currentColumnIndex < COLUMN_SIZE) {
      this.clickFocusBtn(this.ids[currentRowIndex][currentColumnIndex])
    }
  }
}
