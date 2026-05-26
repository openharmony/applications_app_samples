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
import { ScanningDeviceList, SelectCategoryList } from '../../../model/utils/CommitUtil';

@Component
export struct SelectionSort {
  close: () => void = () => {
  };
  succ: () => void = () => {
  };
  @State name: string = '';
  @State title: Resource = $r(`app.string.selection_sort`);
  @State isClose: boolean = true;
  @State isLeftIcon: string | Resource = '';
  @State scanningDeviceList: SelectCategoryList[] = [
    new SelectCategoryList('路由', 'route'),
    new SelectCategoryList('照明', 'illumination'),
    new SelectCategoryList('节能', 'energyConservation'),
    new SelectCategoryList('健康', 'health'),
    new SelectCategoryList('环境', 'environment'),
  ];
  @State scanningDeviceId: string = 'route';
  @State scanningDeviceName: string = '路由';

  build() {
    Column() {
      HeadTitleNavBar({
        title: $title,
        isLeftIcon: $isLeftIcon,
        isClose: this.isClose,
        closeCallback: () => this.close()
      });

      Column() {
        TextInput({ text: this.name, placeholder: '搜索' })
          .fontSize('16fp')
          .fontColor('#ffffff')
          .backgroundColor('#ffffff')
          .border({
            width: '1lpx',
            color: 'rgba(255, 255, 255, 0.4)'
          })
          .width('100%')
          .height(40)
          .onChange((text: string) => {
            this.name = text;
          });
      }
      .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12'), bottom: $r('app.string.p_12') });


      Column() {
        Flex() {
          List() {
            ForEach(this.scanningDeviceList, (item: ScanningDeviceList) => {
              ListItem() {
                Row() {
                  Text(item.label || '')
                    .fontColor(this.scanningDeviceId == item.value ? $r('app.color.btn_text_color') :
                    $r('app.color.text_color_2'))
                    .fontSize($r('app.string.font_14'));
                }
                .width(CommonConstants.FULL_WIDTH_PERCENT)
                .padding({ top: $r('app.string.p_16'), bottom: $r('app.string.p_16') });
              }.padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12'), bottom: $r('app.string.p_12') })
              .onClick(() => {
                this.scanningDeviceId = item.value || '';
                this.scanningDeviceName = item.label || '';
              });
            });
          }.height('100%').width(77).border({
            width: { right: 1 },
            color: { right: '#e3e3e3' },
          });

          Column() {
            Row() {
              Text(this.scanningDeviceName || '').fontColor($r('app.color.text_color_2'))
                .fontSize($r('app.string.font_14'));
            }.margin({ bottom: $r('app.string.p_24') });

            Column({ space: 12 }) {
              Image($r('app.media.beScanning'))
                .width($r('app.string.p_52'))
                .height($r('app.string.p_52'));

              Text('设备').fontColor($r('app.color.text_color_2'))
                .fontSize($r('app.string.font_14'));
            }.onClick(() => this.succ());
          }.padding({ left: $r('app.string.p_24'), right: $r('app.string.p_24'), top: $r('app.string.p_16') });
        };
      }.layoutWeight(1);

    }.width(CommonConstants.FULL_WIDTH_PERCENT)
    .layoutWeight(1);
  }
}