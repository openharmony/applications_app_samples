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

import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

@Observed
export class OperateParam {
    moveFunc: Function
    copyFunc: Function
}

@CustomDialog
export struct CopyOrMoveDialog {
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
    controller: CustomDialogController;
    dataTime: string;
    @Consume operateParam: OperateParam;

    aboutToAppear(): void {

    }

    build() {
        Column() {
            Row() {
                Text($r('app.string.copy_or_move'))
                    .fontSize($r('sys.float.ohos_id_text_size_headline7'))
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('sys.color.ohos_id_color_text_primary'))
            }.alignItems(VerticalAlign.Center)
            .height($r('app.float.dialog_title_height'))


            Row() {
                Column() {
                    Text($r('app.string.copy'))
                        .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_primary'))
                }
            }.alignItems(VerticalAlign.Center)
            .height($r('app.float.dialog_list_card_height'))
            .width('100%')
            .onClick((): void => {
                this.controller.close()
                this.operateParam.copyFunc();
            })


            Row() {
                Divider()
                    .vertical(false)
                    .width('100%')
                    .color($r('sys.color.ohos_id_color_list_separator'))
            }

            Row() {
                Column() {
                    Text($r('app.string.move'))
                        .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
                        .fontFamily($r('app.string.id_text_font_family_regular'))
                        .fontColor($r('sys.color.ohos_id_color_text_primary'))
                }

            }
            .alignItems(VerticalAlign.Center)
            .height($r('app.float.dialog_list_card_height'))
            .width('100%')
            .margin({
                bottom: $r('app.float.select_model_dialog_margin') })
            .onClick((): void => {
                this.controller.close()
                this.operateParam.moveFunc();
            })

            Stack({ alignContent: Alignment.Top }) {
                Button() {
                    Text($r('app.string.cancel_button'))
                        .fontSize($r('sys.float.ohos_id_text_size_button1'))
                        .fontColor($r('app.color.color_control_highlight'))
                        .width('100%')
                        .textAlign(TextAlign.Center)
                        .fontWeight(FontWeight.Medium)
                }
                .backgroundColor($r('app.color.transparent'))
                .height($r('app.float.details_dialog_button_height'))
                .onClick((): void => {
                    this.controller.close()
                })
            }.width('100%')
            .height($r('app.float.details_dialog_button_area_height'))
        }
        .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
        .alignItems(HorizontalAlign.Start)
        .borderRadius($r('app.float.dialog_border_radius'))
        .width(screenManager.getColumnsWidth(4))
        .backgroundColor($r('app.color.white'))
        .margin({
            right: $r('app.float.dialog_window_margin'),
            left: $r('app.float.dialog_window_margin'),
            bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
        })
    }
}
