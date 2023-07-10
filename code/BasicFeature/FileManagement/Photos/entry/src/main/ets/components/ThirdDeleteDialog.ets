/*
 * Copyright (c) 2022 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { DialogCallback } from '../utils/DialogUtil';
import { Log } from '../utils/Log';
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

@CustomDialog
export struct ThirdDeleteDialog {
  private TAG: string = 'DeleteDialog'
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @Consume dialogCallback: DialogCallback;
  @Consume dialogMessage: Resource;
  @Consume dialogDeleteMessage: Resource;
  controller: CustomDialogController;

  private uris: string[];
  private thirdAppName: string;

  aboutToAppear(): void {
    this.uris = AppStorage.Get<string[]>("uris");
    this.thirdAppName = AppStorage.Get<string>("appName");
  }

  build() {
    Column() {
      Column() {
        Stack({ alignContent: Alignment.Bottom}) {

          if(this.uris.length > 1) {
            Image(this.uris[1])
              .objectFit(ImageFit.Cover)
              .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m')})
              .height($r('app.float.third_delete_dialog_ico_height'))
              .width('100%')
              .opacity(0.4)
              .padding({ left: $r('app.float.third_delete_dialog_second_ico_margin'),
                right: $r('app.float.third_delete_dialog_second_ico_margin')})
          }

          Image(this.uris[0])
            .objectFit(ImageFit.Cover)
            .border({ radius: $r('sys.float.ohos_id_corner_radius_default_m')})
            .height(this.uris.length > 1 ? $r('app.float.third_delete_dialog_ico_height_multi'):
            $r('app.float.third_delete_dialog_ico_height'))
            .width('100%')
            .margin({ bottom: this.uris.length > 1 ? $r('app.float.third_delete_dialog_ico_margin_bottom_multi') :
            $r('app.float.third_delete_dialog_ico_margin_bottom_single')})
        }

        Text($r('app.string.third_delete_dialog_message', this.thirdAppName, this.uris.length))
          .textAlign(TextAlign.Center)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .margin({ top: $r('app.float.first_delete_dialog_ico_margin_bottom')})
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .margin({
        top: $r('app.float.dialog_content_margin'),
        bottom: $r('app.float.dialog_button_and_text_margin'),
      })

      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Column() {
            Button() {
              Text($r('app.string.dialog_cancel'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('app.color.color_control_highlight'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .margin({
              right: $r('app.float.dialog_double_buttons_margin')
            })
            .backgroundColor($r('app.color.transparent'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick((): void => {
              Log.debug(this.TAG, "cancelCallback");
              this.controller.close();
              if(this.dialogCallback != null) this.dialogCallback.cancelCallback();
            })
          }.width('50%')


          Divider()
            .vertical(true)
            .height(Constants.DEFAULT_DIVIDER_HEIGHT)
            .color(Constants.DEFAULT_DIVIDER_COLOR)

          Column() {
            Button() {
              Text(this.dialogDeleteMessage)
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('sys.color.ohos_id_color_warning'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .margin({
              left: $r('app.float.dialog_double_buttons_margin'),
            })
            .backgroundColor($r('app.color.transparent'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick((): void => {
              Log.debug(this.TAG, "confirmCallback");
              this.controller.close();
              if(this.dialogCallback != null) this.dialogCallback.confirmCallback();
            })
          }.width('50%')

        }
      }
      .width('100%')
      .height($r('app.float.details_dialog_button_area_height'))
    }
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
    .width(screenManager.getColumnsWidth(4))
    .backgroundColor($r('app.color.white'))
    .margin({
      right: $r('app.float.dialog_window_margin'),
      left: $r('app.float.dialog_window_margin'),
      bottom: this.isHorizontal ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
    })
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
    .alignItems(HorizontalAlign.Center)
    .shadow({
      radius: $r('app.float.dialog_default_shadow_m_radius'),
      color: $r('app.color.dialog_default_shadow_m_color'),
      offsetX: $r('app.float.dialog_default_shadow_m_offsetX'),
      offsetY: $r('app.float.dialog_default_shadow_m_offsetY'),
    })
  }
}
