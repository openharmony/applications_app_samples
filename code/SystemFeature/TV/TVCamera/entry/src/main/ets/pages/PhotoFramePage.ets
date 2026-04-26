/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { router } from '@kit.ArkUI';
import cameraDemo from 'libentry.so';
import { KeyCode } from '@kit.InputKit';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

interface PhotoFrameType {
  img: ResourceStr;
  value: string;
}

@Entry
@Component
struct PhotoFramePage {
  @State photoFrameTypes: PhotoFrameType[] = [
    { img: $r('app.media.photoframe'), value: 'fd://photopic1' },
    { img: $r('app.media.photoframe'), value: 'fd://photopic2' }
  ];
  @State selectedFrame: string = '';
  //相框开关
  @StorageLink('cameraWaterFrameSwitch') cameraWaterFrameSwitch: boolean = false;
  private swiperController: SwiperController = new SwiperController();

  tabClick() {
    try {
    } catch (err) {
      console.error('settingList inputEventClient' + err);
    }
  }

  aboutToAppear(): void {
    this.selectedFrame = AppStorage.get('selectedFrame') as string;
  }

  onPageShow(): void {
    setTimeout(() => {
      this.tabClick();
    }, 500)
  }

  @Builder
  swiperItem(value: PhotoFrameType, isON: boolean) {
    Column() {
      Column() {
        Row() {
          Image(value.img)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Fill)
        }
        .width('100%')
        .height('95%')

        Radio({
          value: 'Radio', group: 'radioGroup',
          indicatorType: RadioIndicatorType.DOT
        })
          .checked(value.value == this.selectedFrame)
          .height('60lpx')
          .width('60lpx')
          .focusBox({
            margin: LengthMetrics.px(5),
            strokeColor: ColorMetrics.resourceColor(Color.White),
            strokeWidth: LengthMetrics.px(2)
          })
          .onChange((isChecked: boolean) => {
            console.log('Radio status is ' + isChecked);
            if (isChecked) {
              if (this.cameraWaterFrameSwitch) {
                AppStorage.setOrCreate('selectedFrame', value.value);
                cameraDemo.watermarkPhotoPic(value.value);
              } else {
                AppStorage.setOrCreate('selectedFrame', value.value);
              }
            }
          })
          .position({ x: '100%', y: '90%' })
      }
      .padding({
        left: '93lpx',
        right: '102lpx',
        top: '81lpx',
        bottom: '80lpx'
      })
      .borderRadius('63lpx')
      .backgroundColor('#333333')
      .width('100%')
      .height('75%')
      .alignItems(HorizontalAlign.Center)

      Row()
        .width('90%')
        .height('100lpx')
        .backgroundColor('#00000000')
    }
    .width('100%')
    .padding({ left: '96lpx', right: '91lpx' })
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.photoFrame'))
          .size({ height: '88lpx' })
          .fontSize('63lpx')
          .fontColor('#FFFFFF')

        Row() {
          Text($r('app.string.photoFrame'))
            .size({ width: '96lpx', height: '68lpx' })
            .fontSize('48lpx')
            .fontColor('#999999')
            .margin({ right: '10lpx' })
          Toggle({ type: ToggleType.Switch, isOn: this.cameraWaterFrameSwitch })
            .width('115lpx')
            .height('63lpx')
            .selectedColor('#007DFF')
            .switchPointColor('#FFFFFF')
            .focusBox({
              margin: LengthMetrics.px(5),
              strokeColor: ColorMetrics.resourceColor(Color.White),
              strokeWidth: LengthMetrics.px(2)
            })
            .onChange((isOn: boolean) => {
              if (isOn) {
                //打开相框开关
                cameraDemo.watermarkPhotoPic('fd://photopic');
                this.cameraWaterFrameSwitch = true;
                AppStorage.setOrCreate('cameraWaterFrameSwitch', this.cameraWaterFrameSwitch);
              } else {
                //关闭相框相框开关
                this.cameraWaterFrameSwitch = false;
                AppStorage.setOrCreate('cameraWaterFrameSwitch', this.cameraWaterFrameSwitch);
              }
            });
        }
        .width('298lpx')
        .padding({
          left: '41lpx',
          right: '21lpx',
          top: '9lpx',
          bottom: '14lpx'
        })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor('#333333')
        .borderRadius('60lpx')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: '96lpx', top: '42lpx', right: '91lpx' })

      Swiper(this.swiperController) {
        ForEach(this.photoFrameTypes, (item: PhotoFrameType) => {
          this.swiperItem(item, false);
        });
      }
      .width('100%')
      .margin({ top: '53lpx' })
      .displayCount(1)
      .indicator( // 设置圆点导航点样式
        new DotIndicator()
          .itemWidth('33lpx')
          .itemHeight('33lpx')
          .selectedItemWidth('89lpx')
          .selectedItemHeight('33lpx')
          .color(Color.Gray)
          .selectedColor(Color.White)
          .maxDisplayCount(9))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        router.back();
      }
    });
  }
}
