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
import { logger, readImage } from '@ohos/photomodify';
import router from '@ohos.router';
import GetPictures from '../pages/GetPictures';
import common from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';

const TAG: string = '[Sample_Index]';

@Entry
@Component
struct Index {
  @State isShowComment: boolean = true;
  @State isShowCamera: boolean = false;
  @State isLand: boolean = false;
  @State pixelMaps: Array<PixelMap|undefined> = [];
  @State commodityPixelMap: PixelMap | null = null;
  @State imageArr: Array<PixelMap | null> = [];
  @StorageLink('imageList') imageList: Array<string> = [];
  @StorageLink('fileFd') fileSrc: string = '';
  @StorageLink('isUpdate') isUpdate: boolean = false;
  private GetPictures: GetPictures = new GetPictures();
  scroller: Scroller = new Scroller();

  terminateSelf(context: common.UIAbilityContext): void {
    context.terminateSelf();
  }

  aboutToAppear(): void {
    logger.info(TAG, 'enter aboutToAppear');
    if (AppStorage.Get<string[]>('pixelMaps')) {
      this.pixelMaps.push(undefined);
    }
    let rawFile = getContext().resourceManager.getRawFdSync("commodity.png");
    let imageSourceApi = image.createImageSource(rawFile);
    imageSourceApi.createPixelMap().then((pixelMap) => {
      this.commodityPixelMap = pixelMap;
    })
  }

  async onPageShow(): Promise<void> {
    this.imageArr = await Promise.all(this.imageList.map(imgUrl =>{
      return readImage(imgUrl)
    }))

    logger.info(`arr-${this.imageArr.length}`)
  }
  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width($r('app.float.size_46'))
          .height($r('app.float.size_26'))
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            let context: Context = getContext(this);
            this.terminateSelf(context as common.UIAbilityContext);
          })

        Text($r('app.string.publish_comments'))
          .fontSize($r('app.float.size_22'))
          .margin({ left: $r('app.float.size_130') })
          .textAlign(TextAlign.Center)

        Blank()

        Button($r('app.string.submit'))
          .fontSize($r('app.float.size_20'))
          .height($r('app.float.size_32'))
          .width($r('app.float.size_80'))
          .backgroundColor($r('app.color.index_commit'))
          .borderRadius($r('app.float.size_20'))
          .margin({ right: $r('app.float.size_10') })
      }
      .width('100%')
      .height($r('app.float.size_32'))
      .padding({ left: $r('app.float.size_14') })
      .margin({ top: $r('app.float.size_20') })

      Scroll() {
        Column() {
          Stack({ alignContent: Alignment.Top }) {
            Column() {
              Stack() {
                TextArea({ placeholder: $r('app.string.tip') })
                  .height($r('app.float.size_150'))
                  .backgroundColor(Color.White)
                  .onChange((value) => {
                    if (value.length === 0) {
                      this.isShowComment = true;
                    } else {
                      this.isShowComment = false;
                    }
                  })

                if (this.isShowComment) {
                  Image($r('app.media.comment'))
                    .height($r('app.float.size_20'))
                    .width($r('app.float.size_20'))
                    .margin({ top: $r('app.float.size_8'), left: $r('app.float.size_16') })
                }
              }
              .alignContent(Alignment.TopStart)
              .margin({ top: $r('app.float.size_40') })

              if (this.imageList.length > 0) {
                Grid() {
                  ForEach(this.imageList, (imgUrl: string, index: number) => {
                    GridItem() {
                      if (index < this.imageList.length) {
                        Image(this.imageArr ? this.imageArr[index] : imgUrl)
                          .onClick(() => {
                            AppStorage.SetOrCreate<number>('selectIndex', index);
                            this.isLand = true;
                            router.pushUrl({
                              url: 'pages/UpdatePages',
                              params: { mediaUri: imgUrl }
                            })
                          })
                          .id('Photo')
                          .width('100%')
                          .height($r('app.float.size_100'))
                          .borderRadius($r('app.float.size_10'))
                          .backgroundColor(Color.Blue)
                      }
                    }
                  })
                }
                .columnsTemplate('1fr 1fr 1fr 1fr')
                .columnsGap($r('app.float.size_8'))
                .rowsGap($r('app.float.size_8'))
                .margin({ top: $r('app.float.size_8') })
                .width('94%')
                .height(105 * (this.pixelMaps.length > 4 ? 2 : 1))
              } else {
                Column() {
                  Image($r('app.media.camera'))
                    .width($r('app.float.size_40'))
                    .height($r('app.float.size_40'))

                  Text($r('app.string.add_picture'))
                    .fontSize($r('app.float.size_16'))
                }
                .id('add')
                .onClick(() => {
                  this.GetPictures.getImage()
                })
                .width('94%')
                .height($r('app.float.size_130'))
                .margin({ top: $r('app.float.size_10') })
                .borderRadius($r('app.float.size_10'))
                .justifyContent(FlexAlign.Center)
                .backgroundColor('#F1F3F5')
              }
              Text($r('app.string.anonymous_display'))
                .fontSize($r('app.float.size_15'))
                .fontColor('#99182431')
                .alignSelf(ItemAlign.Start)
                .margin({ left: $r('app.float.size_16'), top: $r('app.float.size_16') })
            }
            .width('100%')
            .height('100%')
            .margin({ top: $r('app.float.size_22') })
            .borderRadius($r('app.float.size_20'))
            .backgroundColor('#fffffff')

            Image(this.commodityPixelMap)
              .width($r('app.float.size_44'))
              .height($r('app.float.size_44'))
          }
          .backgroundColor($r('app.color.index_stack'))
          .height('100%')
          .width('94%')
          .margin({ top: $r('app.float.size_10') })
        }
        .width('100%')
        .height($r('app.float.size_380'))
      }
      .margin({ top: $r('app.float.size_20') })
      .constraintSize({ maxHeight: '94%', minHeight: '94%' })
      .backgroundColor($r('app.color.index_stack'))
    }
    .width('100%')
    .height('100%')
  }
}