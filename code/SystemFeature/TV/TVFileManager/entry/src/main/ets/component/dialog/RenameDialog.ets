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
import { inputMethod } from '@kit.IMEKit';
import { MLog } from '../../common/utils/MLog';
import { KeyCode } from '@kit.InputKit';
import { InputKeyEventUtils } from '../../common/utils/InputKeyEventUtils';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { Units } from '../../common/utils/PixelUnitConversion';

const TAG = 'RenameDialog';

@CustomDialog
export struct RenameDialog {
  textInputController: TextInputController = new TextInputController();
  controller: CustomDialogController;
  @State focusIndex: number = -1;
  @State enableKeyboard: boolean = false;
  confirm?: (text: string) => void;
  private text: string = '';
  private TextInputController: TextInputController = new TextInputController();

  aboutToAppear(): void {
    MLog.print(TAG, `RenameFileDialog aboutToAppear`);
    setTimeout(() => {
      focusControl.requestFocus('renameInput');
    }, 200);
    try {
      inputMethod.getSetting().on('imeHide', (info: Array<inputMethod.InputWindowInfo>) => {
        MLog.print(TAG, 'Succeeded in subscribing imeHide event.');
      });
    } catch (err) {
      MLog.printError(TAG, `Failed to unsubscribing imeHide. err: ${JSON.stringify(err)}`, err);
    }
  }

  aboutToDisappear(): void {
    MLog.print(TAG, `RenameFileDialog aboutToDisappear`);
    AppStorage.setOrCreate('isSelect', false);
    AppStorage.setOrCreate('operationFiles', []);
    try {
      inputMethod.getSetting().off('imeHide');
    } catch (err) {
      MLog.printError(TAG, `Failed to unsubscribing imeHide. err: ${JSON.stringify(err)}`, err);
    }
  }

  build() {
    Column() {
      Text($r('app.string.rename_dialog_title'))
        .fontSize(Units.px2fp(64))
        .fontColor($r('app.color.rename_title'))

      TextInput({
        controller: this.textInputController,
        placeholder: $r('app.string.rename_dialog_input_hint'),
        text: this.text
      })
        .id('renameInput')
        .width(Units.px2vp(864))
        .fontSize(Units.px2fp(36))
        .fontColor(this.focusIndex == 0 ? $r('app.color.rename_input_text') : $r('app.color.rename_input_text_hint'))
        .placeholderColor($r('app.color.rename_input_text_hint'))
        .placeholderFont({
          size: Units.px2fp(36)
        })
        .borderRadius(Units.px2vp(18))
        .margin({ top: Units.px2vp(62) })
        .padding({
          top: Units.px2vp(39),
          bottom: Units.px2vp(39),
          left: Units.px2vp(24),
          right: Units.px2vp(24)
        })
        .backgroundColor(
          this.focusIndex == 0 ? $r('app.color.rename_input_text_hint') : $r('app.color.rename_input_bg'))
        .focusable(true)
        .defaultFocus(true)
        .onFocus(() => {
          MLog.print(TAG, `TextInput onFocus`);
          this.focusIndex = 0;
          // 手动获取焦点，拉起输入法

        })
        .enableKeyboardOnFocus(true)
        .onBlur(() => {
          MLog.print(TAG, `TextInput onBlur`);
          this.focusIndex = -1;
        })
        .onChange(text => {
          this.text = text;
        })
        .onKeyEvent((e) => {
          if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Down) {
            focusControl.requestFocus('renameInput');
            this.focusIndex = 0;
            e.stopPropagation();
          }
          if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
            focusControl.requestFocus('renameSave');
            this.focusIndex = 1;
            e.stopPropagation();
          }
        })

      Stack() {
        Button($r('app.string.save'))
          .fontSize(Units.px2fp(36))
          .fontColor(this.focusIndex == 1 ? Color.Black : Color.White)
          .backgroundColor(this.focusIndex == 1 ? Color.White : $r('app.color.file_list_item_bg'))
          .width(Units.px2vp(230))
          .height(Units.px2vp(70))
          .focusBox({
            strokeColor: ColorMetrics.numeric(Color.Transparent),
            strokeWidth: LengthMetrics.px(0)
          })
          .borderRadius(Units.px2vp(72))
        if (this.focusIndex == 1) {
          Image($r('app.media.ic_public_button_selected'))
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Contain)
        }
      }
      .onKeyEvent((e) => {
        if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
          focusControl.requestFocus('renameInput');
          this.focusIndex = 0;
          e.stopPropagation();
        }
      })
      .id('renameSave')
      .width(Units.px2vp(248))
      .height(Units.px2vp(90))
      .alignContent(Alignment.Center)
      .align(Alignment.Center)
      .margin({ top: Units.px2vp(44) })
      .onFocus(() => {
        this.focusIndex = 1;
      })
      .onClick(() => {
        this.controller.close();
        this.confirm && this.confirm(this.text);
      })
      .onTouch((e: TouchEvent) => {
        if (e.type === TouchType.Down) {
          focusControl.requestFocus('renameSave');
          InputKeyEventUtils.inputTab();
        }
      })
    }
    .width('100%')
    .margin({ top: Units.px2vp(44) })
  }
}