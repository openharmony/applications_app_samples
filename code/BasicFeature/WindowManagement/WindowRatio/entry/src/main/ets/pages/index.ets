/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import window from '@ohos.window';

@Entry
@Component
struct Index {
  @State windowRatio: number = (4 / 3) * 1.0;
  @State showWindowRatio: string = '4:3';
  @StorageLink('windowWidth') windowWidth: string = 'unknown';
  @StorageLink('windowHeight') windowHeight: string = 'unknown';
  @State numbers: number = 0;

  build() {
    Row() {
      Column() {
        Row() {
          Column() {
            Row() {
              Text($r('app.string.windowRatios'))
                .fontSize('21.5px')
                .fontColor('#a6abb1')
              Text(this.showWindowRatio)
                .fontSize('21.5px')
                .fontColor('#a6abb1')
            }
          }
          .margin({ left: '6%' })
          .alignItems(HorizontalAlign.Start)
          .width('64%')

          Column() {
            Select([{ value: '4:3' },
              { value: '1:1' },
              { value: '16:9' }])
              .selected(this.numbers)
              .value(this.showWindowRatio)
              .backgroundColor('#e9ebed')
              .font({ size: '22px' })
              .selectedOptionFont({ size: '22px' })
              .optionFont({ size: '21px' })
              .width('30%')
              .height('56px')
              .id('selectRatio')
              .onSelect((index: number) => {
                console.info("Select:" + index);
                this.numbers = index;
                if (index === 0) {
                  this.windowRatio = (4 / 3) * 1.0;
                  this.showWindowRatio = '4:3';
                } else if (index === 1) {
                  this.windowRatio = 1.0;
                  this.showWindowRatio = '1:1';
                } else {
                  this.windowRatio = (16 / 9) * 1.0;
                  this.showWindowRatio = '16:9';
                }
              })
          }
        }
        .width('98%')
        .height('56px')
        .backgroundColor('#e9ebed')
        .borderRadius(15)

        Row() {
          Text($r('app.string.windowWidth'))
            .fontSize(20)
            .fontColor(Color.Black)
            .width('50%')
            .margin({ left: '10%' })
            .textAlign(TextAlign.End)
          Text(this.windowWidth)
            .fontSize(20)
            .width('30%')
            .fontColor(Color.Black)
            .margin({ right: '10%' })
        }
        .margin({ top: 5 })
        .width('80%')
        .align(Alignment.Center)

        Row() {
          Text($r('app.string.windowHeight'))
            .fontSize(20)
            .fontColor(Color.Black)
            .width('50%')
            .margin({ left: '10%' })
            .textAlign(TextAlign.End)
          Text(this.windowHeight)
            .fontSize(20)
            .width('30%')
            .fontColor(Color.Black)
            .margin({ right: '10%' })
        }
        .margin({ top: 5 })
        .width('80%')
        .align(Alignment.Center)

        Button($r("app.string.set_OK"))
          .id('changeRatio')
          .margin({ top: 5 })
          .onClick(() => {
            console.info('MyApplicationDemo ' + 'get the ratio = ' + this.windowRatio);
            try {
              let windows: window.Window | undefined = AppStorage.get<window.Window>('windows');
              if (windows !== undefined) {
                windows.setAspectRatio(this.windowRatio, (error) => {
                  if (error.code) {
                    console.error('MyApplicationDemo ' + 'Failed to set the aspect ratio of window. Cause:' + JSON.stringify(error));
                    return;
                  }
                  console.info('MyApplicationDemo ' + 'Succeeded in setting the aspect ratio of window.');
                });
              }
            } catch (exception) {
              console.error('MyApplicationDemo ' + 'Failed to set the aspect ratio of window. Cause: ' + JSON.stringify(exception));
            }
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}