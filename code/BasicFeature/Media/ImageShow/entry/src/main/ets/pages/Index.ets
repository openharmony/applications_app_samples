/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import Logger from '../../../../../imagelibrary/src/main/ets/components/data/Logger';

const TAG: string = 'Index';

interface RouteParams {
  isShowCamera?: boolean,
  mediaUris?: string[]
};

@Entry
@Component
struct Index {
  @State mediaUris: Array<string> = []
  @State stars: Array<boolean> = new Array(5).fill(false)
  @State countStar: number = 0
  @State isShowCamera: boolean = false
  @State isShowComment: boolean = true

  async onPageShow() {
    Logger.info(TAG, 'enter onPageShow');
    if ((router.getParams() as RouteParams).isShowCamera !== undefined &&
      (router.getParams() as RouteParams).isShowCamera !== null) {
      this.isShowCamera = (router.getParams() as RouteParams).isShowCamera as boolean;
      Logger.info(TAG, `this.isShowCamera = ${this.isShowCamera}`);
    }

    if ((router.getParams() as RouteParams).mediaUris !== undefined &&
      (router.getParams() as RouteParams).mediaUris !== null) {
      this.mediaUris = (router.getParams() as RouteParams).mediaUris as string[];
      this.mediaUris.push('');
    }
    Logger.info(TAG, 'end onPageShow');
  }

  terminateSelf() {
    let context = AppStorage.get<common.UIAbilityContext>('UIContext');
    context!.terminateSelf();
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(46)
          .height(26)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.terminateSelf();
          })

        Text($r('app.string.publish_comments'))
          .fontSize(22)
          .margin({ left: 130 })
          .textAlign(TextAlign.Center)

        Blank()

        Button($r('app.string.submit'))
          .fontSize(20)
          .height(32)
          .width(80)
          .backgroundColor('#E92F4F')
          .borderRadius(20)
          .margin({ right: 10 })
      }
      .width('100%')
      .height(32)
      .padding({ left: 14 })
      .margin({ top: 20 })


      Scroll() {
        Column() {
          Stack({ alignContent: Alignment.Top }) {
            Column() {
              Stack() {
                TextArea({ placeholder: $r('app.string.tip') })
                  .id('comment')
                  .height(150)
                  .backgroundColor('#fffffff')
                  .onChange((value) => {
                    if (value.length === 0) {
                      this.isShowComment = true
                    } else {
                      this.isShowComment = false
                    }
                  })

                if (this.isShowComment) {
                  Image($r('app.media.comment'))
                    .height(20)
                    .width(20)
                    .margin({ top: 8, left: 16 })
                }
              }
              .alignContent(Alignment.TopStart)
              .margin({ top: 40 })

              if (this.isShowCamera) {
                Grid() {
                  ForEach(this.mediaUris, (item: string, index) => {
                    GridItem() {
                      if (index < this.mediaUris.length - 1) {
                        Image(item)
                          .id('image')
                          .width('100%')
                          .height(100)
                          .borderRadius(10)

                      } else {
                        Column() {
                          Image($r('app.media.photo'))
                            .height(40)
                            .width(40)
                            .onClick(() => {
                              router.pushUrl({
                                url: 'pages/ChoicePhoto',
                                params: { 'mediaUris': this.mediaUris }
                              });
                            })
                          Text($r('app.string.add_picture'))
                            .fontSize(13)
                        }
                        .alignItems(HorizontalAlign.Center)
                        .justifyContent(FlexAlign.Center)
                        .width('100%')
                        .height(100)
                        .borderRadius(10)
                        .backgroundColor('#F1F3F5')
                      }
                    }
                  })
                }
                .columnsTemplate('1fr 1fr 1fr 1fr')
                .columnsGap(8)
                .rowsGap(8)
                .margin({ top: 8 })
                .width('94%')
                .height(105 * (this.mediaUris.length > 4 ? 2 : 1))
              } else {
                Column() {
                  Image($r('app.media.camera'))
                    .width(40)
                    .height(40)

                  Text($r('app.string.add_picture'))
                    .fontSize(16)
                }
                .onClick(() => {
                  router.push({
                    url: 'pages/ChoicePhoto'
                  })
                })
                .width('94%')
                .height(130)
                .margin({ top: 10 })
                .borderRadius(10)
                .justifyContent(FlexAlign.Center)
                .backgroundColor('#F1F3F5')
              }
              Text($r('app.string.anonymous_display'))
                .fontSize(15)
                .fontColor('#99182431')
                .alignSelf(ItemAlign.Start)
                .margin({ left: 16, top: 16 })
            }
            .width('100%')
            .height('100%')
            .margin({ top: 22 })
            .borderRadius(20)
            .backgroundColor('#fffffff')

            Image($r('app.media.commodity'))
              .width(44)
              .height(44)
          }
          .backgroundColor('#f1f3f5')
          .height('100%')
          .width('94%')
          .margin({ top: 10 })
        }
        .width('100%')
        .height(this.isShowCamera === false ? 380 : 300 + (this.mediaUris.length / 4 > 1 ? 160 : 60))
      }
      .margin({ top: 20 })
      .constraintSize({ maxHeight: '94%', minHeight: '94%' })
      .backgroundColor('#f1f3f5')
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }
}
