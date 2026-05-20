import { Attachment } from '../IssueReporter/models/IssueDetailInfo'
import LogManager from '../../common/Log/LogManager'
import fileUri from '@ohos.file.fileuri'
import NetworkManager from '../../common/Network/NetworkManager';
import fs from '@ohos.file.fs';
import router from '@ohos.router'

interface Params {
  url: string;
}

@Entry
export default struct attachmentVideoView {
  @State videoUrl: string = ''
  @State isLoadVideo: boolean = false
  videoController: VideoController = new VideoController()

  aboutToAppear() {
    let param: Params = router.getParams() as Params;
    const url: string = param.url
    LogManager.hilogI(`url ${JSON.stringify(url)}`)
    this.videoUrl = url
  }

  updateAttachment() {
  }

  getVideoViewUrl(url: string) {
    const fileName = url.split('id=')[1]
    if (!fileName) {
      return
    }
    const fileUrl = `${getContext(this).cacheDir}/${fileName}.mp4`
    let existJudgment = fs.accessSync(fileUrl);
    this.isLoadVideo = true

    if (!existJudgment) {
      NetworkManager.shareInstance().down(getContext(this), url, fileName, (videoUrl: string) => {
        LogManager.hilogI(`videoUrl ${JSON.stringify(videoUrl)}`)
        this.isLoadVideo = false
        if (videoUrl) {
          this.videoUrl = fileUri.getUriFromPath(videoUrl)
        }
      })
    } else {
      this.isLoadVideo = false
      const sourceDir = fileUri.getUriFromPath(fileUrl)
      this.videoUrl = sourceDir
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          if (!this.isLoadVideo && this.videoUrl) {
            Video({ src: this.videoUrl, controller: this.videoController })
              .autoPlay(true)
              .objectFit(ImageFit.Contain)
              .onPrepared(() => {
                LogManager.hilogI(`videoUrl ${this.videoUrl}`)
              })
              .onError(() => {
                LogManager.hilogI(`videoUrl ${this.videoUrl}`)
              })
          }
        }
        .width('100%')
        .height('100%')

        if (this.isLoadVideo) {
          LoadingProgress()
            .color(Color.Blue)
            .width('160lpx')
            .height('160lpx')
        }

      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)

      Column() {
        Image($r('app.media.icon_back_white'))
          .height('96lpx')
          .onClick(() => {
            this.videoController?.stop()
            router.back()
          })
      }
      .width('100%')
      .padding({ top: '24lpx', left: '24lpx' })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
  }
}