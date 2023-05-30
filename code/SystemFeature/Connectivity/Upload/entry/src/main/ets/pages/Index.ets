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
import router from '@ohos.router';
import connection from '@ohos.net.connection';
import Logger from '../util/Logger'
import ServiceConfigDialog from '../componets/ServiceConfigDialog'

const TAG: string = "Index"

@Entry
@Component
struct Index {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ServiceConfigDialog(),
  })

  aboutToAppear() {
    connection.getDefaultNet().then(netHandle => {
      if (netHandle.netId >= 100) {
        Logger.info(TAG, 'home:网络可用')
      } else {
        AlertDialog.show({
          message: $r('app.string.network_unusable_tip'),
          primaryButton: {
            value: $r('app.string.confirm'),
            action: () => {
              Logger.info(TAG, 'home:网络不可用')
            }
          }
        })
      }
    })
  }

  build() {
    Column({ space: 50 }) {
      Row() {
        Text($r('app.string.index_title'))
          .fontSize($r('app.float.ohos_id_text_size_headline'))
          .fontFamily("HwChinese-medium")
        Image($r('app.media.ic_setting'))
          .onClick(() => {
            this.dialogController.open()
          })
          .width($r('app.float.home_setting_width'))
          .height($r('app.float.home_setting_width'))
      }
      .padding({
        left: $r('app.float.index_title_left_margin'),
        top: $r('app.float.index_title_top_margin'),
        right: $r('app.float.index_title_left_margin')
      })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Column() {
        Row() {
          Text($r('app.string.upload_title'))
            .fontSize($r('app.float.ohos_id_text_size_button'))
          Blank()
          Image($r('app.media.ic_public_arrow_right'))
            .width($r('app.float.index_ic_width'))
            .aspectRatio(1)
        }
        .width('100%')
        .padding({
          left: $r("app.float.menu_lr_padding"),
          right: $r("app.float.menu_lr_padding"),
          top: $r("app.float.menu_tb_padding"),
          bottom: $r("app.float.menu_tb_padding")
        })
        .id("upload")
        .onClick(() => {
          router.pushUrl({ url: 'upload/pages/Upload' })
        })
        .backgroundColor($r('app.color.background_fff'))
        .border({ radius: $r('app.float.ohos_id_corner_radius_menu') })

        Row() {
          Text($r('app.string.download_title'))
            .fontSize($r('app.float.ohos_id_text_size_button'))
          Blank()
          Image($r('app.media.ic_public_arrow_right'))
            .width($r('app.float.index_ic_width'))
            .aspectRatio(1)
        }
        .width('100%')
        .padding({
          left: $r("app.float.menu_lr_padding"),
          right: $r("app.float.menu_lr_padding"),
          top: $r("app.float.menu_tb_padding"),
          bottom: $r("app.float.menu_tb_padding")
        })
        .id("download")
        .onClick(() => {
          router.pushUrl({ url: 'download/pages/Download' })
        })
        .backgroundColor($r('app.color.background_fff'))
        .border({ radius: $r('app.float.ohos_id_corner_radius_menu') })
        .margin({ top: $r('app.float.ohos_id_corner_radius_menu') })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({ left: $r('app.float.ohos_id_max_padding_start'), right: $r('app.float.ohos_id_max_padding_start') })
    }
    .backgroundColor($r('app.color.background_F1F3F5'))
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}