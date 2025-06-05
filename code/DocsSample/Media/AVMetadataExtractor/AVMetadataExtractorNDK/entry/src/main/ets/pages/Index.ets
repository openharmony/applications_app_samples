/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { image } from '@kit.ImageKit';
import { media } from '@kit.MediaKit';
import avmetadataextractor from 'libentry.so';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

const TAG: string = 'AvImageGenerator Demo:'

@Entry
@Component
struct Index {
  private videoName: string = 'test.mp3';
  @State coverPixelMap: image.PixelMap | undefined = undefined;
  @State metadata: media.AVMetadata | undefined = undefined;
  @State show: boolean = true;

  build() {
    Column() {
      Text(this.videoName).fontSize(20).fontWeight(FontWeight.Bold)
      Row () {
        Column() {
          Button($r('app.string.FetchCover'), { type: ButtonType.Capsule })
            .margin({ top: 30 })
            .onClick(async() => {
              await this.getSelectedVideoCover();
              this.show = true;
              promptAction.showToast({
                message:$r('app.string.FetchCoverStart'),
                duration:2000,
                showMode: promptAction.ToastShowMode.DEFAULT,
                bottom:80
              })
            })
            .id('FetchCover')
        }
        Column() {
          Button($r('app.string.FetchMetaData'), { type: ButtonType.Capsule })
            .margin({ top: 30 })
            .onClick(async() => {
              this.coverPixelMap = undefined;
              await this.getMetadata();
              this.show = false;
              promptAction.showToast({
                message:$r('app.string.FetchMetaDataStart'),
                duration:2000,
                showMode: promptAction.ToastShowMode.DEFAULT,
                bottom:80
              })
            })
            .id('FetchMetaData')
        }
      }

      Row () {
        if (this.show) {
          Image(this.coverPixelMap)
            .width('70%')
            .height(300)
            .margin({
              top: 50
            })
            .borderWidth(2)
            .borderColor('#0D9FFB')
        } else {
          Column() {
            Text($r('app.string.album')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.albumArtist')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.artist')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.author')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.dateTime')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.dateTimeFormat')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.composer')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.duration')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.genre')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.hasAudio')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.hasVideo')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.mimeType')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.trackCount')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.sampleRate')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.title')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.videoHeight')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.videoWidth')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.videoOrientation')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.hdrType')).fontSize(15).fontWeight(FontWeight.Bold)
            Text($r('app.string.location')).fontSize(15).fontWeight(FontWeight.Bold)
          }
          .width('50%')
          .margin({
            top: 50
          })

          Column() {
            Text(this.metadata ? this.metadata.album + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.albumArtist + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.artist + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.author + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.dateTime + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.dateTimeFormat + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.composer + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.duration + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.genre + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.hasAudio + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.hasVideo + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.mimeType + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.trackCount + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.sampleRate + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.title + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.videoHeight + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.videoWidth + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.videoOrientation + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? this.metadata.hdrType + ' ' : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)

            Text(this.metadata ? `${JSON.stringify(this.metadata.location)} ` : $r('app.string.noValue'))
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
          }
          .width('50%')
          .margin({
            top: 50
          })
        }

      }
    }.width('100%').height('100%')
  }

  async getSelectedVideoCover() {
    this.coverPixelMap = undefined;
    console.info(TAG + 'getSelectedVideoCover: start')
    try {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let avFileDescriptor = await context.resourceManager.getRawFd(this.videoName);
      let fdsrc : number = avFileDescriptor.fd;
      let size : number = avFileDescriptor.length;
      let offset : number = avFileDescriptor.offset;
      this.coverPixelMap = avmetadataextractor.OhAVMetadataExtractorFetchAlbumCover(fdsrc, size, offset);
    } catch (e) {
      console.error(TAG + `getSelectedVideoCover, code is ${e.code}, message is ${e.message}`);
    }
    console.info(TAG + 'getSelectedVideoCover: start')
  }

  async getMetadata() {
    console.debug(TAG + 'getMeter START')
    try {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let avFileDescriptor = await context.resourceManager.getRawFd(this.videoName);
      let fdsrc : number = avFileDescriptor.fd;
      let size : number = avFileDescriptor.length;
      let offset : number = avFileDescriptor.offset;
      this.metadata = avmetadataextractor.OhAVMetadataExtractorFetchMetadata(fdsrc, size, offset)
    } catch (e) {
      console.error(TAG + 'getMetadata' + JSON.stringify(e));
    }
    console.debug(TAG + 'getMeter END')
  }
}
