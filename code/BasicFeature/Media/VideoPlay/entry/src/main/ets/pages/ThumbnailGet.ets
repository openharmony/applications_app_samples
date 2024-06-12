/*
 * Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import media from '@ohos.multimedia.media'
import image from '@ohos.multimedia.image';
import fs from '@ohos.file.fs';

@Entry
@Component
struct Index {
  @State pixelMap: PixelMap|undefined[] = [undefined, undefined, undefined, undefined, undefined]
  @State diffTime: number[] = [0, 0, 0, 0, 0, 0]

  build() {
    Row() {
      Column() {
        Button() {
          Text($r('app.string.get_thumbnail'))
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .id('Thumbnail_2')
        .type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .width('60%')
        .height('5%')
        .onClick(() => {
          this.fetchFrameAndMeta()
        })

        Row() {
          Image(this.pixelMap[0]).width(130).height(200).objectFit(ImageFit.Fill).margin({ top: 20 })
          Image(this.pixelMap[1]).width(130).height(200).objectFit(ImageFit.Fill).margin({ top: 20 })
          Image(this.pixelMap[2]).width(130).height(200).objectFit(ImageFit.Fill).margin({ top: 20 })
        }

        Row() {
          Text(this.diffTime[0].toString()).width(130).height(30)
          Text(this.diffTime[1].toString()).width(130).height(30)
          Text(this.diffTime[2].toString()).width(130).height(30)
        }

        Row() {
          Image(this.pixelMap[3]).width(130).height(200).objectFit(ImageFit.Fill).margin({ top: 20 })
          Image(this.pixelMap[4]).width(130).height(200).objectFit(ImageFit.Fill).margin({ top: 20 })
          Image(this.pixelMap[5]).width(130).height(200).objectFit(ImageFit.Fill).margin({ top: 20 })
        }

        Row() {
          Text(this.diffTime[3].toString()).width(130).height(30)
          Text(this.diffTime[4].toString()).width(130).height(30)
          Text(this.diffTime[5].toString()).width(130).height(30)
        }
      }
      .width('100%')
    }
    .height('100%')
  }

  async fetchFrameAndMeta() {
    let avFileDescriptor = await globalThis.getContext().resourceManager.getRawFd('test.mp4')
    if (canIUse('SystemCapability.Multimedia.Media.AVMetadataExtractor')) {
      let avMetadataExtractor = await media.createAVMetadataExtractor()
      avMetadataExtractor.fdSrc = avFileDescriptor
      let metadata = await avMetadataExtractor.fetchMetadata()
      console.info(`winddraw rotation ${metadata.videoOrientation}`)
      let duration = Number(metadata.duration)
      this.diffTime[0] = 0
      for (let i = 0; i < 4; i++) {
        this.diffTime[i + 1] = this.diffTime[i] + duration / 5 * 1000
      }
      this.diffTime[5] = duration * 1000
      avMetadataExtractor.release()
    }

    if (canIUse('SystemCapability.Multimedia.Media.AVImageGenerator')) {
      let queryOption = media.AVImageQueryOptions.AV_IMAGE_QUERY_CLOSEST_SYNC
      for (let i = 0; i < 6; i++) {
        let avImageGenerator: media.AVImageGenerator = await media.createAVImageGenerator()
        avImageGenerator.fdSrc = avFileDescriptor
        this.pixelMap[i] = await avImageGenerator.fetchFrameByTime(this.diffTime[i], queryOption, {})
        avImageGenerator.release()
      }
    }
  }

  savePixelMapData(pixelMap: PixelMap) {
    pixelMap.getImageInfo().then((imageInfo: image.ImageInfo) => {
      if (imageInfo == undefined) {
        console.error('Failed to obtain the image pixel map information');
      }
      const readBuffer: ArrayBuffer = new ArrayBuffer(imageInfo.size.height * imageInfo.size.width * 4)
      pixelMap.readPixelsToBuffer(readBuffer).then(() => {
        let filePath = globalThis.getContext().filesDir + '/winddraw.dat';
        let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.writeSync(file.fd, readBuffer)
        fs.closeSync(file)
      }).catch(() => {
        console.error('Failed to read image pixel data.');
      })
    })
  }
}