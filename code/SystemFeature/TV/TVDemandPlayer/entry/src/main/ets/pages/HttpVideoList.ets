/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
/* eslint-disable */
/* http 视频列表 */
import { router } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { httpGet, initInfo } from '@ohos/utilslibrary';
import { BusinessError } from '@kit.BasicServicesKit';
import { UrlType, DataType, ImgType } from '../const/Type';
import { media } from '@kit.MediaKit';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import app from '@system.app'
import { DrmModel } from '../Model/DrmModel';
import { promptAction } from '@kit.ArkUI';
import { EventUtil } from '../utils/EventUtil';
import { image } from '@kit.ImageKit';
import { Constants } from '../const/Constants';

const COLOR_BEGIN = '#000000';
const COLOR_END = '#00000000';
const IMAGE_CACHE_SIZE: number = 100 * 1024 * 1024; // 100MB
const IMAGE_CACHE_COUNT: number = 30;
let log = initInfo('httpVideoList.ets');

let videoList: UrlType[] = [
  {
    name: '山上一片云',
    url: $r('app.string.video_url_1'),
    img: $r('app.string.img_url_1')
  },
  {
    name: '俯瞰一个岛',
    url: $r('app.string.video_url_2'),
    img: $r('app.string.img_url_2')
  },
  {
    name: '海植物',
    url: $r('app.string.video_url_3'),
    img: $r('app.string.img_url_3')
  },
  {
    name: '无边泳池',
    url: $r('app.string.video_url_4'),
    img: $r('app.string.img_url_4')
  },
  {
    name: '几何球',
    url: $r('app.string.video_url_5'),
    img: $r('app.string.img_url_5')
  },
  {
    name: '一栋阁楼',
    url: $r('app.string.video_url_6'),
    img: $r('app.string.img_url_6')
  },
  {
    name: '山上日落',
    url: $r('app.string.video_url_8'),
    img: $r('app.string.img_url_8')
  },
  {
    name: '星空',
    url: $r('app.string.video_url_9'),
    img: $r('app.string.img_url_9')
  },
  {
    name: '俯瞰立交桥',
    url: $r('app.string.video_url_10'),
    img: $r('app.string.img_url_10')
  },
  {
    name: '山顶风景',
    url: $r('app.string.video_url_11'),
    img: $r('app.string.img_url_11')
  },
  {
    name: '水从两边流到一边',
    url: $r('app.string.video_url_12'),
    img: $r('app.string.img_url_12')
  },
  {
    name: '云飘过去飘过来',
    url: $r('app.string.video_url_13'),
    img: $r('app.string.img_url_13')
  },
  {
    name: '一片湖',
    url: $r('app.string.video_url_14'),
    img: $r('app.string.img_url_14')
  },
  {
    name: '水流过来又流过去',
    url: $r('app.string.video_url_15'),
    img: $r('app.string.img_url_15')
  },
  {
    name: '黑地球在转',
    url: $r('app.string.video_url_16'),
    img: $r('app.string.img_url_16')
  },
];


let httpVideoListPath = '';


interface EventType {
  width: number;
  height: number;
}

// 屏幕尺寸
@Entry
@Component
struct httpVideoList {
  @State focusId: number = 0;
  @StorageLink('screen_lpx_w') screenW: number = AppStorage.get<number>('screen_lpx_w') || 1280;
  @StorageLink('screen_lpx_h') screenH: number = AppStorage.get<number>('screen_lpx_h') || 720;
  @StorageLink('screen_dpi') dpi: number = AppStorage.get<number>('screen_dpi') || 2;
  @StorageLink('screen_lpi') lpi: number = AppStorage.get<number>('screen_lpi') || 1.5;
  @State imgSrc: ImgType[] = [{ src: '' }];
  @State imgLoad: boolean = false;
  @State imgHeight: number = 400;
  @State description: string = '';
  @State videoList: Array<UrlType> = [...videoList];
  @State isLoading: boolean = false;
  @State imgOnComplete: boolean = false;
  @State linearGradientBeginColor: string = COLOR_END;
  @State linearGradientEndColor: string = COLOR_BEGIN;
  @State isTrimApp: string = 'false';
  avPlayer: media.AVPlayer | null = null;
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    try {
      this.isTrimApp = systemParameterEnhance.getSync('const.product.trimapp');
      log(`getTrimApp success, ${this.isTrimApp}`);
    } catch (e) {
      log(`getTrimApp err, ${e}`);
    }
    this.setVideoList();
    this.getHttpVideos();
  }

  onPageShow() {
    if (this.isTrimApp == 'false') {
      app.setImageCacheCount(IMAGE_CACHE_COUNT);
      app.setImageRawDataCacheSize(IMAGE_CACHE_SIZE);
    }
    this.setVideoList();
    this.initFocus();
  }

  initFocus() {
    this.imgOnComplete = false;
    this.imgLoad = false;
    this.imgSrc = [{ src: '' }];
    let len = this.videoList.length;
    if (len > 0) {
      if (this.focusId < -1 || this.focusId > (len - 1)) {
        this.focusId = 0;
      }
    }
  }

  getHttpVideos() {
    if (!httpVideoListPath) {
      return
    }
    this.isLoading = true;
    httpGet({ url: httpVideoListPath }).then((data) => {
      this.isLoading = false;
      if (data.responseCode == 200) {
        let dataResult = data.result as Record<string, Array<UrlType>>
        this.videoList = this.videoList.concat(dataResult.videoList);
        this.setVideoList();
        this.initFocus();
      }
    }).catch((e: BusinessError) => {
      this.isLoading = false;
    })
  }

  onPageHide() {

  }

  private resolveMediaUrl(val?: string | Resource): string {
    if (val === undefined || val === null) {
      return '';
    }
    if (typeof val === 'string') {
      return val;
    }
    try {
      return getContext(this).resourceManager.getStringSync((val as Resource).id);
    } catch (_e) {
      return '';
    }
  }

  setVideoList() {
    let urlList: UrlType[] = [];
    this.videoList.forEach((t: UrlType) => {
      urlList.push({
        uri: t.uri || '',
        url: this.resolveMediaUrl(t.url),
        type: 'http',
        displayName: t.name as string,
        resolution: '1080P',
        resolutions: [],
        licenseUri: t.licenseUri || ''
      })
    })
    AppStorage.setOrCreate<Array<UrlType>>('video_list', urlList)
  }

  // 播放视频
  playVideo(data: UrlType, ind: number) {
    if (data?.licenseUri && !DrmModel.isMediaKeySystemSupport()) {
      log(`playVideo return, not support drm`);
      promptAction.showToast({ message: $r('app.string.drm_play_failed') })
      return;
    }
    globalThis.videoIndex = ind;
    router.pushUrl({
      url: 'pages/VideoPlayer'
    })
  }

  videoOnFocus(data: UrlType, ind: number) {
    if (!this.scroller) {
      return
    }
    ;
    this.imgLoad = false;
    this.imgOnComplete = false;
    this.imgSrc = [{ src: '' }];

    if (data.img) {
      this.imgSrc[0] = { src: this.resolveMediaUrl(data.img) };
      this.imgLoad = true;
    }

    this.description = data.description as string;
  }

  async preloadImage(url: string): Promise<void> {
    try {
      await image.createImageSource(url);
      console.log('Image preloaded successfully');
    } catch (error) {
      console.error('Image preload failed:', error);
    }
  }

  build() {
    Stack() {
      Column() {
        Text('网络点播')
          .fontSize('40lpx')
          .width('100%')
          .height('100lpx')
          .fontColor('#e8e8e9')
          .padding({ left: '30lpx', bottom: px2lpx(48) })
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
        Row() {
          if (this.videoList.length > 0) {
            List({ space: px2lpx(24), scroller: this.scroller }) {
              ForEach(this.videoList, (item: UrlType, ind) => {
                ListItem() {
                  Stack({ alignContent: Alignment.Center }) {
                    Row() {
                      Text(`${ind + 1}`)
                        .fontSize(ind == this.focusId ? '24lpx' : '22lpx')
                        .textAlign(TextAlign.Center)
                        .width('60lpx')
                        .height('40lpx')
                        .fontColor(ind == this.focusId ? '#1e1e1f' : '#e5e5e5')

                      Text(item.name)
                        .fontSize(ind == this.focusId ? '26lpx' : '24lpx')
                        .textAlign(TextAlign.Start)
                        .width('410lpx')
                        .height('40lpx')
                        .maxLines(1)
                        .fontColor(ind == this.focusId ? '#1e1e1f' : '#e5e5e5')

                    }
                    .width(ind == this.focusId ? '490lpx' : '480lpx')
                    .height(ind == this.focusId ? '60lpx' : '50lpx')
                    .borderWidth('1lpx')
                    .borderRadius(globalThis.lpiPx(12))
                    .borderStyle(BorderStyle.Solid)
                    .borderColor('#464648')
                    .backgroundColor(ind == this.focusId ? '#dededf' : '#464648')
                    .alignItems(VerticalAlign.Center)
                    .justifyContent(FlexAlign.Start)
                    .zIndex(1)

                    Text('')
                      .zIndex(2)
                      .textAlign(TextAlign.Center)
                      .width('500lpx')
                      .height('70lpx')
                      .focusable(true)
                      .focusOnTouch(true)
                      .defaultFocus(ind == this.focusId)
                      .key(`${ind}`)
                      .id(`${ind}`)
                      .onFocus(() => {
                        log(`onFocus focusId:${ind}`);
                        this.focusId = ind;
                        this.videoOnFocus(item, ind);
                      })
                      .onHover(() => {
                        this.focusId = ind;
                        this.videoOnFocus(item, ind);
                        globalThis.videoIndex = ind;
                      })
                      .onKeyEvent((e) => {
                        if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Down) {
                          this.playVideo(item, ind)
                          e.stopPropagation();
                        }
                      })
                      .onClick(() => {
                        this.playVideo(item, ind);
                      })
                  }
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .width(ind == this.focusId ? '500lpx' : '490lpx')
                  .height(ind == this.focusId ? '70lpx' : '60lpx')
                  .borderWidth('2lpx')
                  .borderRadius(globalThis.lpiPx(16))
                  .backgroundColor(ind == this.focusId ? '#18181A' : '#464648')
                  .borderColor(ind == this.focusId ? '#dededf' : '#464648')
                }.width('100%')
              })
            }
            .scrollBar(BarState.Off)
            .align(Alignment.Top)
            .height(`${this.screenH - 140}lpx`)
            .width('510lpx')
            .align(Alignment.Top)

            Column() {
              Stack() {
                Column() {
                  if (this.imgLoad) {
                    Image(this.imgSrc[0].src)
                      .width('100%')// .height(`${this.imgHeight}lpx`)
                      .height('100%')
                      .backgroundColor('#34000000')
                      .margin({ bottom: '20lpx' })
                      .syncLoad(false)
                      .objectFit(ImageFit.Cover)
                      .onComplete((event: EventType) => {
                        this.imgOnComplete = true;
                        let w = event.width as number;
                        let h = event.height as number;
                        ;
                        this.imgHeight = Math.ceil(700 * h / w);
                        log(`imgOnComplete`)
                      })
                  }
                }
                .height(`${this.screenH - 140}lpx`)
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Start)
                .width('700lpx')
                .zIndex(1)

                if (!this.imgOnComplete) {
                  Column() {
                    LoadingProgress().color('#ffffff').width('120lpx').height('100lpx')
                    Text(`图片加载中...`)
                      .fontSize('16lpx')
                      .fontColor('#ffffff')
                  }
                  .padding('10lpx')
                  .backgroundColor('#131D26')
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .zIndex(10)
                }
              }
              .height(`${this.screenH - 140}lpx`)
              .width('700lpx')
            }
            .flexGrow(1)
            .padding({ left: '20lpx' })
            .height(`${this.screenH - 140}lpx`)
            .onAppear(() => {
              // 预加载图片
              this.preloadImage(this.imgSrc[0].src);
            })

          } else {
            if (!this.isLoading) {
              Text('暂无网络视频')
                .fontSize('20lpx')
                .width('100%')
                .height('100%')
                .textAlign(TextAlign.Center)
                .fontColor('#ffffffff')
            }
          }
        }
        .height(`${this.screenH - 120}lpx`)
        .width('100%')
        .padding({ left: '20lpx', right: '20lpx', bottom: '20lpx' })
        .alignItems(VerticalAlign.Top)
      }
      .padding('10lpx')
      .backgroundColor('#18181A')
      .width('100%')
      .height('100%')
      .focusable(true)
      .onFocus(() => {

      })
      .onKeyEvent(e => {
        if (e.keyCode == KeyCode.KEYCODE_F24) {
          return;
        }
        if (e.keyCode == KeyCode.KEYCODE_B && e.type == KeyType.Up) {
          router.back();
        }
        log(`keyCode:${e.keyCode}, keyType:${e.type}`);
      })

      if (this.isLoading) {
        Column() {
          LoadingProgress().color('#ffffff').width('120lpx').height('100lpx')
          Text(`网络视频列表加载中...`)
            .fontSize('16lpx')
            .fontColor('#ffffff')
        }
        .padding('10lpx')
        .backgroundColor('#4d000000')
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .zIndex(1)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  fadingOverlay() {
    Column()
      .width('100%')
      .height(`${this.screenH - 140}lpx`)
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [
          [this.linearGradientBeginColor, 0],
          [Color.Transparent, 0.1],
          [Color.Transparent, 0.9],
          [this.linearGradientEndColor, 1],
        ]
      })
  }
}
