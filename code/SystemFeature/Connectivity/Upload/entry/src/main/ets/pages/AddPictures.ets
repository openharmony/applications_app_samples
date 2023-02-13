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

import SelectDialog from '../pages/SelectDialog'
import GetPictures from '../feature/GetPictures'

@Component
export struct AddPictures {
  @StorageLink('imageList') imageList: Array<string> = [] // 用于接收选中的照片
  @StorageLink('photoUri') photoUri: string = '' // 用于接收拍照里的照片
  private GetPictures: GetPictures = new GetPictures()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: SelectDialog({
      getImage: this.GetPictures.getImage
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  build() {
    Column() {
      Scroll() {
        Column() {
          // 点击图标选择了图片时
          Grid() {
            ForEach(this.imageList, (imgUrl: string, index: number) => {
              GridItem() {
                Image(imgUrl)
                  .width('100%')
                  .aspectRatio(1)
              }
            })
            GridItem() {
              Column() {
                Image($r('app.media.ic_public_add'))
                  .width(48)
                  .height(48)
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .height(100)
              .backgroundColor($r('app.color.light_gray'))
              .onClick(() => {
                this.dialogController.open()
              })
            }.visibility(this.imageList.length < 9 ? Visibility.Visible : Visibility.None)
          }
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .columnsGap(8)
          .rowsGap(8)
          .margin({ top: 8 })
          .width('90%')
          .height(105 * (this.imageList.length > 4 ? 2 : 1))
        }
        .width('100%')
        .height(Visibility.Visible ? 380 : 300 + (this.imageList.length / 4 > 1 ? 160 : 60))
      }
      .margin({ top: 20 })
      .constraintSize({ maxHeight: '94%', minHeight: '94%' })
    }
    .width('100%')
    .height('35%')
  }
}