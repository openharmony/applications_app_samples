/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { INDEX_DATA } from '../../mock/ProductsData';
import { SwiperModel } from '../../model/GoodsModel';

const isNewSlide: boolean = true;

@Component
export struct SwiperComponent {
  @StorageProp('curBp') curBp: string = 'md';
  @State currentIndex: number = 2;
  @State breakPoints: string | undefined = AppStorage.get('breakPoint');

  /**
   * Get the image offset coefficients.
   *
   * @param index
   * @returns offset coefficients
   */
  getImgCoefficients(index: number): number {
    let coefficient: number = this.currentIndex - index;
    let tempCoefficient: number = Math.abs(coefficient);
    if (tempCoefficient <= 2) {
      return coefficient;
    }
    let dataLength: number = INDEX_DATA.length;
    let tempOffset: number = dataLength - tempCoefficient;
    if (tempOffset <= 2) {
      if (coefficient > 0) {
        return -tempOffset;
      }
      return tempOffset;
    }
    return 0;
  }

  /**
   * Get the image offset.
   *
   * @param index
   * @returns offset
   */
  getOffSetX(index: number): number {
    let offsetIndex: number = this.getImgCoefficients(index);
    let tempOffset: number = Math.abs(offsetIndex);
    let offsetX: number = 0;
    if (tempOffset === 1) {
      offsetX = -40 * offsetIndex;
    }
    return offsetX;
  }

  startAnimation(isLeft: boolean): void {
    animateTo({
      duration: 300,
    }, () => {
      let dataLength: number = INDEX_DATA.length;
      let tempIndex: number = isLeft ? this.currentIndex + 1 : this.currentIndex - 1 + dataLength;
      this.currentIndex = tempIndex % dataLength;
    })
  }

  build() {
    if (!isNewSlide) {
      Swiper() {
        ForEach(INDEX_DATA, (item: SwiperModel) => {
          Image(item.img)
            .objectFit(ImageFit.Cover)
            .width('100%')
            .height('100%')
            .borderRadius(16)
        })
      }
      .padding({
        left: 12,
        right: 12
      })
      .height(170)
      .autoPlay(true)
      .itemSpace(20)
      .displayCount(this.curBp === 'sm' ? 1 : this.curBp === 'md' ? 2 : 3)
      .indicator(
        Indicator
          .dot()
          .selectedColor($r('app.color.red'))
          .color($r('app.color.white'))
      )
    } else {
      Column() {
        Stack() {
          ForEach(INDEX_DATA, (item: SwiperModel, index: number) => {
            Row() {
              Image(item.img)
                .objectFit(ImageFit.Fill)
                .borderRadius(8)
                .width(this.breakPoints === 'sm' ? 340 : 260)
                .height(index !== this.currentIndex ?
                  "65%" : `${95 - 13 * Math.abs(this.getImgCoefficients(index))}%`)
                .opacity(1 - 0.2 * Math.min(2, Math.abs(this.getImgCoefficients(index))))
            }
            .borderRadius(8)
            .offset({
              x: this.getOffSetX(index),
              y: 0
            })
            .blur(10 * Math.abs(this.getImgCoefficients(index)))
            .zIndex(index !== this.currentIndex && this.getImgCoefficients(index) === 0 ?
              0 : 2 - Math.abs(this.getImgCoefficients(index)))
          }, (item: SwiperModel) => JSON.stringify(item))
        }
        .alignContent(Alignment.Center)
        .gesture(
          PanGesture({ direction: PanDirection.Horizontal })
            .onActionStart((event: GestureEvent) => {
              this.startAnimation(event.offsetX < 0);
            })
        )
      }
      .width('100%')
      .height('25%')
    }
  }
}
