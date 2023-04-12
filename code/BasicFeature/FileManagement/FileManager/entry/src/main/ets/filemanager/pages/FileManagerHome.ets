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

import prompt from '@ohos.promptAction'
import router from '@ohos.router'
import { FileManager } from '@ohos/feature-file-manager'

class MainListItemModel {
  image: Resource
  title: Resource
  routerUrl: string
  isReady?: boolean = true
}

const ONE_SECOND: number = 1000
const MAIN_LIST_ITEMS: MainListItemModel[] = [
  {
    image: $r('app.media.image'),
    title: $r('app.string.image'),
    routerUrl: 'filemanager/pages/image/ImageFileList'
  },
  {
    image: $r("app.media.video"),
    title: $r('app.string.video'),
    routerUrl: 'filemanager/pages/video/VideoFileList' },
  {
    image: $r('app.media.document'),
    title: $r('app.string.document'),
    routerUrl: 'filemanager/pages/document/DocumentFileList'
  },
  {
    image: $r('app.media.music'),
    title: $r('app.string.audio'),
    routerUrl: 'filemanager/pages/audio/AudioFileList'
  },
  {
    image: $r('app.media.compressed_package'),
    title: $r('app.string.compressed_package'),
    routerUrl: '',
    isReady: false
  },
  {
    image: $r('app.media.my_phone'),
    title: $r('app.string.my_phone'),
    routerUrl: 'filemanager/pages/MyPhone/MyPhone'
  }
]

@Component
export default struct FileManagerHome {
  aboutToAppear() {
    FileManager.requestPermission(getContext(this))
  }

  build() {
    Column() {
      Text($r('app.string.file_manager'))
        .fontSize(24)
        .margin({ left: 20, top: 10, bottom: 20 })
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.black'))
        .alignSelf(ItemAlign.Start)
      List() {
        ForEach(MAIN_LIST_ITEMS, (listItem: MainListItemModel) => {
          ListItem() {
            MainListItemComponent({ mainListItem: listItem })
          }
        })
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .backgroundColor($r('app.color.background'))
    .padding(20)
  }
}

@Component
struct MainListItemComponent {
  private mainListItem: MainListItemModel

  @Styles itemPressedStyles() {
    .backgroundColor($r('app.color.item_pressed'))
  }

  build() {
    Row() {
      Image(this.mainListItem.image)
        .width(24)
        .height(24)
        .margin({ left: 20 })
        .objectFit(ImageFit.Fill)

      Text(this.mainListItem.title)
        .fontSize(16)
        .margin({ left: 16 })
        .fontColor($r('app.color.black'))

      Blank()

      Image($r("app.media.right_arrow"))
        .width(12)
        .height(24)
        .margin({ right: 6 })
    }
    .height(56)
    .width('100%')
    .borderRadius(24)
    .backgroundColor($r('app.color.white'))
    .margin({ top: 10 })
    .stateStyles({
      pressed: this.itemPressedStyles
    })
    .onClick(() => {
      if (this.mainListItem.isReady == false) {
        prompt.showToast({
          duration: ONE_SECOND,
          message: $r('app.string.not_supported_tip')
        })
        return
      }
      router.push({ url: this.mainListItem.routerUrl })
    })
  }
}