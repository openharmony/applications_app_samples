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
import { CommonConstants } from '@ohos/common';
import { HeadTitleNavBar } from '../HeadTitleNavBar';

@Component
export struct ConnectingDevice {
  close: () => void = () => {
  };
  succ: () => void = () => {
  };
  @State name: string = '';
  @State title: Resource = $r(`app.string.device_attachment`);
  @State isClose: boolean = true;
  @State isLeftIcon: string | Resource = '';
  @State scheduleNum: string = '10';
  @State account: string = '';
  @State isScheduleLoading: boolean = false;

  build() {
    Column() {
      HeadTitleNavBar({
        title: $title,
        isLeftIcon: $isLeftIcon,
        isClose: this.isClose,
        closeCallback: () => this.close()
      });

      Column() {
        if (this.isScheduleLoading) {
          Column() {
            Row({ space: 28 }) {
              Image($r('app.media.distributionNetwork'))
                .width(90)
                .height(90);

              Row({ space: 6 }) {
                Row().width(6).height(6).borderRadius(6).backgroundColor('#1059f7');
                Row().width(6).height(6).borderRadius(6).backgroundColor('#1059f7');
                Row().width(6).height(6).borderRadius(6).backgroundColor('#1059f7');
              };

              Image($r('app.media.distributionNetwork'))
                .width(90)
                .height(90);
            };

            Column() {
              Text(this.scheduleNum + '%')
                .fontWeight(500)
                .fontColor($r('app.color.text_color_3'))
                .fontSize($r('app.string.font_44'))
                .padding({ top: 93 });

              Text($r('app.string.Connecting_device'))
                .fontColor($r('app.color.text_color_1'))
                .fontSize($r('app.string.font_14'))
                .padding({ top: 12 });

              Text($r('app.string.Connecting_device_process'))
                .fontColor($r('app.color.text_color_1'))
                .fontSize($r('app.string.font_14'))
                .padding({ top: 44 });

              Column({ space: 12 }) {
                Row({ space: 4 }) {
                  Row().width(4).height(4).borderRadius(4).backgroundColor($r('app.color.text_color_1'));
                  Text($r('app.string.equipment_powered_on')).fontColor($r('app.color.text_color_2'))
                    .fontSize($r('app.string.font_14'));
                };

                Row({ space: 4 }) {
                  Row().width(4).height(4).borderRadius(4).backgroundColor($r('app.color.text_color_1'));
                  Text($r('app.string.networkIsSmooth')).fontColor($r('app.color.text_color_2'))
                    .fontSize($r('app.string.font_14'));
                };

                Row({ space: 4 }) {
                  Row().width(4).height(4).borderRadius(4).backgroundColor($r('app.color.text_color_1'));
                  Text($r('app.string.close_to_the_phone')).fontColor($r('app.color.text_color_2'))
                    .fontSize($r('app.string.font_14'));
                };
              }
              .padding({ top: 24 });
            };

          }.height('100%').width('100%').margin({ left: 32, right: 32 }).padding({ top: 131 });
        } else {
          Column({ space: 36 }) {
            Column({ space: 16 }) {
              Image($r('app.media.succeed'))
                .width(44)
                .height(44);

              Text($r('app.string.Connection_successful')).fontWeight(500).fontColor($r('app.color.text_color_2'))
                .fontSize($r('app.string.font_16'));
            };

            Column() {
              Row() {
                Text($r('app.string.devic_name'))
                  .fontColor($r('app.color.text_color_3'))
                  .fontSize($r('app.string.font_16'));

                Row() {
                  TextInput({ placeholder: $r('app.string.please_enter'), text: this.account })
                    .maxLength(12)
                    .width('50%')
                    .textAlign(TextAlign.End)
                    .placeholderFont({ size: $r('app.string.font_14'), weight: 400 })
                    .fontSize($r('app.string.font_14'))
                    .fontColor($r('app.color.scene_tab_color'))
                    .backgroundColor(Color.Transparent)
                    .onChange((value: string) => {
                      this.account = value;
                    });
                  Image($r('app.media.ic_public_edit'))
                    .width($r('app.string.icon_width'))
                    .height($r('app.string.icon_height'));
                };
              }
              .width(CommonConstants.FULL_WIDTH_PERCENT)
              .height(48)
              .justifyContent(FlexAlign.SpaceBetween)
              .border({
                width: { bottom: 1 },
                color: { bottom: '#ececec' },
              });
            }.padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') });
          };
        }

      }
      .padding({ left: $r('app.string.p_24'), right: $r('app.string.p_24'), bottom: $r('app.string.p_12') })
      .layoutWeight(1);

      if (!this.isScheduleLoading) {
        Column() {
          Button($r('app.string.accomplish'))
            .width($r('app.string.btn_width'))
            .height($r('app.string.btn_height'))
            .backgroundColor($r('app.color.text_color_5'))
            .fontColor($r('app.color.equipment_img_bg'))
            .onClick(() => this.succ());
        }.margin({ bottom: $r('app.string.p_12') });
      }

    }.width(CommonConstants.FULL_WIDTH_PERCENT)
    .layoutWeight(1);
  }
}