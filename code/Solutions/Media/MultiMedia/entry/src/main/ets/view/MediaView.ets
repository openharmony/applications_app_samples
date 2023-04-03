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
import router from '@ohos.router'
import Album from '../pages/Index'

@Component
export struct MediaView {
  @ObjectLink album: Album

  build() {
    Row() {
      Text(this.album.albumName)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
      Blank()
      Text(`${this.album.count}`)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .padding(16)
    .constraintSize({ minHeight: 70 })
    .onClick(() => {
      if (this.album.count > 0) {
        router.push({
          url: 'pages/AlbumPage',
          params: { albumName: this.album.albumName, mediaType: this.album.mediaType }
        })
      } else {
        AlertDialog.show(
          {
            message: $r('app.string.album_empty'),
            primaryButton: {
              value: $r('app.string.yes'),
              fontColor: Color.Red,
              action: () => {
              }
            }
          }
        )
      }
    })
  }
}