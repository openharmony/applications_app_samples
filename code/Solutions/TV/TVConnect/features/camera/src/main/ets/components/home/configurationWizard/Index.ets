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
export struct ConfigurationWizard {
  close: () => void = () => {
  };
  succ: () => void = () => {
  };
  @State name: string = '';
  @State title: Resource = $r(`app.string.configuration_wizard`);
  @State isClose: boolean = true;
  @State isLeftIcon: string | Resource = '';

  build() {
    Column() {
      HeadTitleNavBar({
        title: $title,
        isLeftIcon: $isLeftIcon,
        isClose: this.isClose,
        closeCallback: () => this.close()
      });

      Column() {
        Column() {
          Flex() {
            Column({ space: 12 }) {
              Text('第一步').fontSize($r('app.string.font_16'))
                .fontColor($r('app.color.text_color_2'))
                .fontWeight(500)
                .width('100%');

              Text('接通设备电源，看到指示灯亮起').fontSize($r('app.string.font_14'))
                .fontColor($r('app.color.text_color_1'))
                .width('100%');
            }.height('100%').width('calc(100% - 188vp)');

            Column() {
            }.width(188).height('100%').backgroundColor('#e8e8e8').borderRadius(16);

          };
        }.height(188).width('100%').margin({ top: 38, bottom: 88 });

        Column() {
          Flex() {
            Column({ space: 12 }) {
              Text('第二步').fontSize($r('app.string.font_16'))
                .fontColor($r('app.color.text_color_2'))
                .fontWeight(500)
                .width('100%');

              Text('使用顶针按压复位键约3秒，听到“重置成功”的提示音后，设备将会重启进入配网状态。')
                .fontSize($r('app.string.font_14'))
                .fontColor($r('app.color.text_color_1'))
                .width('100%');
            }.height('100%').width('calc(100% - 188vp)');

            Column() {
            }.width(188).height('100%').backgroundColor('#e8e8e8').borderRadius(16);

          };
        }.height(188).width('100%');
      }
      .padding({ left: $r('app.string.p_24'), right: $r('app.string.p_24'), bottom: $r('app.string.p_12') })
      .layoutWeight(1);

      Column({ space: 16 }) {
        Row({ space: 8 }) {
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .select(true)
            .selectedColor($r('app.color.btn_text_color'))
            .shape(CheckBoxShape.CIRCLE)
            .width(20)
            .height(20);

          Text('已完成上述操作').fontSize($r('app.string.font_14'))
            .fontColor($r('app.color.text_color_3'));
        }.width('100%').justifyContent(FlexAlign.Center);

        Button($r('app.string.next_step'))
          .width($r('app.string.btn_width'))
          .height($r('app.string.btn_height'))
          .backgroundColor($r('app.color.btn_text_bg'))
          .fontColor($r('app.color.btn_text_color'))
          .onClick(() => this.succ());

      }.margin({ bottom: $r('app.string.p_12') });
    }.width(CommonConstants.FULL_WIDTH_PERCENT)
    .layoutWeight(1);
  }
}