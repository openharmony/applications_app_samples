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

import { TitleBar } from '../../../../common/TitleBar';

@Extend(Radio) function fancyRadio(){
  .height(25)
  .width(25)
}

@Entry
@Component
struct ImageFitFullSample {
  @State message: string = 'Hello World';
  @State imageFit: ImageFit = ImageFit.None;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.image_fit_Full_effect') });
      Image($r('app.media.flower'))
        .width('100%')
        .height('30%')
        .objectFit(this.imageFit)
        .margin({ top: '30%' })
        .borderWidth(1)
        .alignSelf(ItemAlign.Center);

      Grid() {
        GridItem() {
          Column() {
            Text('Contain')
            Radio({ value: 'RadioContain', group: 'radioGroup' })
              .fancyRadio()
              .checked(false)
              .onChange((isChecked: boolean) => {
                this.imageFit = ImageFit.Contain;
              });
          };
        };
        GridItem() {
          Column() {
            Text('Cover')
            Radio({ value: 'RadioCover', group: 'radioGroup' })
              .fancyRadio()
              .checked(false)
              .onChange((isChecked: boolean) => {
                this.imageFit = ImageFit.Cover;
              });
          };
        };
        GridItem() {
          Column() {
            Text('Auto')
            Radio({ value: 'RadioAuto', group: 'radioGroup' })
              .fancyRadio()
              .checked(false)
              .onChange((isChecked: boolean) => {
                this.imageFit = ImageFit.Auto;
              });
          };
        };
        GridItem() {
          Column() {
            Text('Fill')
            Radio({ value: 'RadioFill', group: 'radioGroup' })
              .fancyRadio()
              .checked(false)
              .onChange((isChecked: boolean) => {
                this.imageFit = ImageFit.Fill;
              });
          };
        };
        GridItem() {
          Column() {
            Text('ScaleDown')
            Radio({ value: 'RadioScaleDown', group: 'radioGroup' })
              .fancyRadio()
              .checked(false)
              .onChange((isChecked: boolean) => {
                this.imageFit = ImageFit.ScaleDown;
              });
          };
        };
        GridItem() {
          Column() {
            Text('None')
            Radio({ value: 'RadioNone', group: 'radioGroup' })
              .fancyRadio()
              .checked(true)
              .onChange((isChecked: boolean) => {
                this.imageFit = ImageFit.None;
              });
          };
        };
      }
      .columnsTemplate('1fr 1fr 1fr')
      .width('70%');
    }
    .padding({top:24, bottom: 12});

  }
}