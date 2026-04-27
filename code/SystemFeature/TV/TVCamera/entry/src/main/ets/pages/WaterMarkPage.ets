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

import { ColorMetrics, LengthMetrics, router } from '@kit.ArkUI';
import Logger from '../utils/Logger';
import { KeyCode } from '@kit.InputKit';
import cameraDemo from 'libentry.so';

const TAG = 'NewWaterMarkPage';

interface waterMarkData {
  img: ResourceStr;
  value: string;
}

@Entry
@Component
struct NewWaterMarkPage {
  @State isSwitchON: boolean = true;
  @State type: string = 'photo';
  @State photoImgList: waterMarkData[] = [
    { img: $r('app.media.camera_watermark'), value: 'fd://photopic1' },
    { img: $r('app.media.camera_watermark'), value: 'fd://photopic2' }
  ]
  @State videoImgList: waterMarkData[] = [
    { img: $r('app.media.video_waterMark'), value: 'fd://photopic3' },
    { img: $r('app.media.video_waterMark'), value: 'fd://photopic4' }
  ]
  @State selectedWaterMark: string = '';
  private swiperController: SwiperController = new SwiperController();
  @State waterMarkStr :string = '';

  aboutToAppear(): void {
    let date: Date = new Date();
    let  monthStr = date.getMonth() > 9 ? date.getMonth() :'0'+ date.getMonth();
    let dayStr =  date.getDay() > 9 ? date.getDay() :'0'+ date.getDay();
    this.waterMarkStr = date.getFullYear() + '/' + monthStr +'/'+ dayStr;
    const params = router.getParams() as Record<string, string>;
    this.type = params['type'];
    if (this.type == 'photo') {
      this.isSwitchON = AppStorage.get('cameraWaterMarkSwitch') as boolean;
      this.selectedWaterMark = AppStorage.get('selectedPhotoWaterMark') as string;
    } else {
      this.isSwitchON = AppStorage.get('videoWaterMarkSwitch') as boolean;
      this.selectedWaterMark = AppStorage.get('selectedVideoWaterMark') as string;
    }
  }

  onPageShow(): void {
    setTimeout(() => {
      this.tabClick();
    }, 500)
  }

  //点击tab键触发聚焦
  tabClick() {
  }

  @Builder
  swiperItem(data: waterMarkData, isON: boolean) {
    Column() {
      Column() {
        Row() {
          Stack({ alignContent: Alignment.BottomStart }) {
            Image(data.img)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Fill)
            Row() {
              Text(this.waterMarkStr)
                .fontColor('#80A2B2')
                .fontSize('36lpx')
            }
            .padding({ left: '27lpx', bottom: '40lpx' })
            .width('100%')
          }
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height('95%')

        Radio({
          value: 'Radio', group: 'radioGroup',
          indicatorType: RadioIndicatorType.DOT
        })
          .checked(data.value == this.selectedWaterMark)
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
              if (this.isSwitchON) {
                if (this.type == 'photo') {
                  AppStorage.setOrCreate('selectedPhotoWaterMark', data.value);
                  cameraDemo.watermarkPhotoPic(data.value);
                } else {
                  AppStorage.setOrCreate('selectedVideoWaterMark', data.value);
                  cameraDemo.watermarkVedioPic(data.value);
                }
              } else {
                if (this.type == 'photo') {
                  AppStorage.setOrCreate('selectedPhotoWaterMark', data.value);
                } else {
                  AppStorage.setOrCreate('selectedVideoWaterMark', data.value);
                }
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
        Text($r('app.string.autoAddWater'))
          .size({ height: '88lpx' })
          .fontSize('63lpx')
          .fontColor('#FFFFFF')
        Row() {
          Text($r('app.string.waterMark'))
            .size({ width: '96lpx', height: '68lpx' })
            .fontSize('48lpx')
            .fontColor('#999999')
            .margin({ right: '10lpx' })
          Toggle({ type: ToggleType.Switch, isOn: this.isSwitchON })
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
              Logger.info(TAG, 'isOn ' + isOn);
              if (isOn) {
                if (this.type == 'photo') {
                  cameraDemo.watermarkPhotoPic('fd://photopic');
                  AppStorage.set('cameraWaterMarkSwitch', true);
                } else {
                  cameraDemo.watermarkPhotoPic('fd://photopic');
                  AppStorage.set('videoWaterMarkSwitch', true);
                }
                this.isSwitchON = true;
              } else {
                //关闭水印
                if (this.type == 'photo') {
                  AppStorage.set('cameraWaterMarkSwitch', false);
                } else {
                  AppStorage.set('videoWaterMarkSwitch', false);
                }
                this.isSwitchON = false;
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
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: '96lpx', top: '42lpx', right: '91lpx' })
      .width('100%')

      Swiper(this.swiperController) {
        ForEach(this.type == 'photo' ? this.photoImgList : this.videoImgList, (item: waterMarkData) => {
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
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.Black)
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        router.back();
      }
    });
  }
}
