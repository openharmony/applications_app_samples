import { Attachment } from '../../IssueReporter/models/IssueDetailInfo'
import LogManager from '../../../common/Log/LogManager'
import router from '@ohos.router'

class MyDataSource implements IDataSource {
  private list: Attachment[] = []

  constructor(list: Attachment[]) {
    this.list = list
  }

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): Attachment {
    return this.list[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener() {
  }
}

@Component
export default struct ImagePreViewDialog {
  private swiperController: SwiperController = new SwiperController()
  @Link previewImage: boolean
  @Prop attachment: Attachment[]
  @State attachmentData: MyDataSource = new MyDataSource([])
  @Prop previewImageIndex: number
  @State isLoading: boolean = true

  aboutToAppear() {
    const videoList = this.attachment.filter((item: Attachment) => item.type == 'image' || item.type == 'jpg')
    if (videoList && videoList.length === 0) {
      this.isLoading = false
    }
    this.attachmentData = new MyDataSource(this.attachment)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Swiper(this.swiperController) {
          LazyForEach(this.attachmentData, (item: Attachment) => {
            Column() {
              if (item.type == 'video' || item.type == 'mp4') {
                Stack({ alignContent: Alignment.Center }) {
                  Image(item.thumbnail)
                    .objectFit(ImageFit.Contain)
                    .onClick((): void => {
                      this.previewImage = false;
                    })
                  Image($r('app.media.ic_video_play_btn_png'))
                    .key('VideoPlayButton')
                    .objectFit(ImageFit.Contain)
                    .width('160lpx')
                    .height('160lpx')
                    .onClick(() => {
                      LogManager.hilogI(`attachmentData ${JSON.stringify(item)}`)

                      router.pushUrl({
                        url: 'pages/IssueReporter/attachmentVideoView',
                        params: {
                          url: item.url
                        }
                      })

                    })
                }
                .width('100%')
                .height('100%')
              } else {
                Image(item.url)
                  .objectFit(ImageFit.Contain)
                  .onComplete(() => {
                    this.isLoading = false
                  })
                  .onError(() => {
                    this.isLoading = false
                  })
                  .onClick((): void => {
                    this.previewImage = false;
                  })
              }
            }
            .width('100%')
            .height('100%')
          }, (item: string) => item)
        }
        .cachedCount(2)
        .index(this.previewImageIndex)
        .itemSpace(0)
        .indicator( // 设置圆点导航点样式
          new DotIndicator()
            .itemWidth(10)
            .itemHeight(10)
            .selectedItemWidth(10)
            .selectedItemHeight(10)
            .color(Color.Gray)
            .selectedColor(Color.Blue))
        .displayArrow(false, false)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      if (this.isLoading) {
        LoadingProgress()
          .color(Color.Blue)
          .width('160lpx')
          .height('160lpx')
          .onClick((): void => {
            this.previewImage = false;
          })
      }

    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}