/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import SelectDialog from './SelectDialog'
import GetPictures from '../feature/GetPictures'
import UploadController from './UploadController'
import Logger from '../util/Logger'
import promptAction from '@ohos.promptAction'
import display from '@ohos.display'

const TAG: string = '[AddPictures]'
const MAX_IMAGE_COUNT = 9;

@Component
export struct AddPictures {
  @StorageProp('currentBreakpoint') curBp: string = 'sm'
  @StorageLink('imageList') imageList: Array<string> = [] // 用于接收选中的照片
  @StorageLink('photoUri') @Watch('addToImageList') photoUri: string = '' // 用于接收拍照里的照片
  @State @Watch('onCompletedChange') isCompletedArr: Array<boolean> = []
  private GetPictures: GetPictures = new GetPictures()
  scroller: Scroller = new Scroller()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: SelectDialog({
      getImage: this.GetPictures.getImage,
      maxSelectCount: (MAX_IMAGE_COUNT - this.imageList.length)
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  toastBottomMargin = 0;

  aboutToAppear() {
    var dis = display.getDefaultDisplaySync()
    var screenHeight = dis.height;

    this.toastBottomMargin = px2vp(screenHeight / 2 - 20);
    Logger.debug("屏幕高度为:" + screenHeight + ",toastBottomMargin=" + this.toastBottomMargin);
  }

  onCompletedChange() {
    let arr = this.isCompletedArr;
    if (arr != null && arr.length == this.imageList.length) {
      Logger.debug(TAG, "所有上传任务都已完成:" + arr.length)
      promptAction.showToast({
        message: $r('app.string.publish_success'),
        duration: 2000,
        bottom: this.toastBottomMargin,
      })
    } else {
      Logger.debug(TAG, "上传任务发生变化:" + arr.length)
    }
  }

  // 当拍照结束后，将图片添加到imageList的头部
  addToImageList(): void {
    this.imageList.unshift(this.photoUri)
  }

  getTemplate() {
    switch (this.curBp) {
      case 'lg':
        return '1fr 1fr 1fr 1fr 1fr'
      case 'md':
      case 'xs':
      case 'sm':
      default:
        return '1fr 1fr 1fr'
    }
  }

  /**
   * 根据屏幕密度，展示适合视觉的行数
   * @returns
   */
  getPicHeight(): number {
    //竖向最多展示几行，默认3
    var num = 3;
    var f = 0.3
    switch (this.curBp) {
      case 'lg':
        num = 2;
        f = 0.4;
        break;
      case 'md':
      case 'xs':
      case 'sm':
      default:
      //使用默认值
        break;
    }
    var dis = display.getDefaultDisplaySync()
    var screenHeight = dis.height;
    var picHeight = screenHeight * f / num;
    Logger.debug("计算得到图片宽度为:" + picHeight)
    return picHeight;
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Row() {
          // 点击图标选择了图片时
          Grid() {
            ForEach(this.imageList, (imgUrl: string, index: number) => {
              GridItem() {
                UploadController({ imageUrl: imgUrl, isCompletedArr: $isCompletedArr })
                  .height(this.getPicHeight())
                  .aspectRatio(1)
                  .id('imageShow')
              }
            })
            if (this.imageList.length < MAX_IMAGE_COUNT) {
              GridItem() {
                Column() {
                  Image($r('app.media.ic_public_add'))
                    .width($r('app.float.add_picture_ic_width'))
                    .aspectRatio(1)
                }
                .aspectRatio(1)
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .height(this.getPicHeight())
                .margin($r('app.float.add_picture_margin_background'))
                .aspectRatio(1)
                .backgroundColor($r('app.color.light_gray'))
                .id('add')
                .onClick(() => {
                  this.dialogController.open()
                })
              }
            }
          }
          .columnsGap($r('app.float.add_picture_ic_gap'))
          .rowsGap($r('app.float.add_picture_ic_gap'))
          .margin({ top: $r('app.float.add_picture_ic_gap') })
          .columnsTemplate(this.getTemplate())
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height('100%')
      }
      .margin({ top: $r('app.float.add_picture_margin_top') })
      .height('100%')
    }
    .width('90%')
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}
