/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import mediaQuery from '@ohos.mediaquery';
import router from '@ohos.router';
import { ExampleDataModel, SearchDataModel } from '../../model/searchModel';
import { exampleData, searchData } from '../../data/searchData'

let portraitSearch = null

class newsNum implements IDataSource {
  totalCount(): number {
    return this.num
  }

  getData(index: number): any {
    return index
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  num: number = 6
  listeners: DataChangeListener[] = []
}

class newsItem implements IDataSource {
  totalCount(): number {
    return this.num
  }

  getData(index: number): any {
    return index
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  num: number = 10
  listeners: DataChangeListener[] = []
}

@Entry
@Component
struct SearchPage {
  @State placeholder: string = router.getParams()['message']
  @State widthNum: number = router.getParams()['num']
  @State ratio: number = router.getParams()['ratio']
  @State swiperWidth: number = router.getParams()['swiperWidth']
  newsNum: newsNum = new newsNum()
  newsItem: newsItem = new newsItem()
  @State value: string = ''
  @State flag: boolean = true
  @State isShow: boolean = true
  @State showText: string = "开启全网热搜榜"
  @State exampleText: Array<ExampleDataModel> = exampleData
  @State active: boolean = false
  @State searchData: Array<SearchDataModel> = searchData
  @State searched: string[] = []
  @State isFlag: boolean = false
  listener = mediaQuery.matchMediaSync('(orientation:landscape)');

  aboutToAppear() {
    portraitSearch = this.onPortrait.bind(this);
    this.listener.on('change', portraitSearch)
  }

  async onPortrait(mediaQueryResult) {
    let result = mediaQueryResult.matches
    if (result) {
      this.widthNum = 45
      this.swiperWidth = 30
    } else {
      this.widthNum = 100
      this.swiperWidth = 60
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          Navigator() {
            Image('/resources/icon/back.png')
              .key('leftSearchPageBtn')
              .width(25 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .active(this.active)
          .onClick(() => {
            this.active = true
          })

          Row() {
            Column() {
              TextInput({ placeholder: this.placeholder, text: this.value })
                .placeholderFont({ size: 10 * this.ratio })
                .enterKeyType(EnterKeyType.Search)
                .height(30 * this.ratio)
                .backgroundColor(Color.White)
                .width(170 * this.ratio)
                .enabled(false)
            }

            Image('/resources/icon/camera.png')
              .width(20 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('65%')
          .padding({ left: 10, right: 10 })
          .border({ width: 1, color: Color.Orange, radius: 20 * this.ratio })
          .backgroundColor(Color.White)

          Column() {
            Text($r('app.string.search1'))
              .fontSize(13 * this.ratio)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
          }
          .width('20%')
          .backgroundColor('#ec4b04')
          .border({ radius: 50 * this.ratio })
          .padding({ left: 5, right: 5, top: 10, bottom: 10 })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 10, right: 10 })
        .margin({ top: 10, bottom: 10 })
        .height(35 * this.ratio)
        .width('100%')

        Stack({ alignContent: Alignment.Top }) {
          if (!this.isFlag) {
            Column() {
              Row() {
                Text($r('app.string.search2'))
                  .fontSize(15 * this.ratio)
                  .fontWeight(FontWeight.Bold)
                Image(this.flag ? '/resources/icon/show.png' : 'resources/icon/hide.png')
                  .key('isShowBtn')
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.flag = !this.flag
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .padding(10)

              if (this.flag) {
                Row() {
                  Button() {
                    Text(this.exampleText[0].exampleText)
                      .fontSize(12 * this.ratio)
                      .fontColor(Color.Black)
                      .margin({ left: 10, right: 10 })
                  }
                  .margin(3)
                  .height(30 * this.ratio)
                  .backgroundColor('#f8f8f8')

                  Button() {
                    Text(this.exampleText[1].exampleText)
                      .fontSize(12 * this.ratio)
                      .fontColor(Color.Black)
                      .margin({ left: 10, right: 10 })
                  }
                  .margin(3)
                  .height(30 * this.ratio)
                  .backgroundColor('#f8f8f8')

                  Button() {
                    Text(this.exampleText[2].exampleText)
                      .fontSize(12 * this.ratio)
                      .fontColor(Color.Black)
                      .margin({ left: 10, right: 10 })
                  }
                  .margin(3)
                  .height(30 * this.ratio)
                  .backgroundColor('#f8f8f8')

                  Button() {
                    Text(this.exampleText[3].exampleText)
                      .fontSize(12 * this.ratio)
                      .fontColor(Color.Black)
                      .margin({ left: 10, right: 10 })
                  }
                  .margin(3)
                  .height(30 * this.ratio)
                  .backgroundColor('#f8f8f8')

                  Button() {
                    Text(this.exampleText[4].exampleText)
                      .fontSize(12 * this.ratio)
                      .fontColor(Color.Black)
                      .margin({ left: 10, right: 10 })
                  }
                  .margin(3)
                  .height(30 * this.ratio)
                  .backgroundColor('#f8f8f8')
                }
                .margin({ left: 10, right: 10 })
                .justifyContent(FlexAlign.Start)
                .alignItems(VerticalAlign.Center)

                Row() {
                  Button() {
                    Text(this.exampleText[5].exampleText)
                      .fontSize(12 * this.ratio)
                      .fontColor(Color.Black)
                      .margin({ left: 10, right: 10 })
                  }
                  .margin(3)
                  .height(30 * this.ratio)
                  .backgroundColor('#f8f8f8')

                  Button() {
                    Text(this.exampleText[6].exampleText)
                      .fontSize(12 * this.ratio)
                      .fontColor(Color.Black)
                      .margin({ left: 10, right: 10 })
                  }
                  .margin(3)
                  .height(30 * this.ratio)
                  .backgroundColor('#f8f8f8')

                  Button() {
                    Text(this.exampleText[7].exampleText)
                      .fontSize(12 * this.ratio)
                      .fontColor(Color.Black)
                      .margin({ left: 10, right: 10 })
                  }
                  .margin(3)
                  .height(30 * this.ratio)
                  .backgroundColor('#f8f8f8')
                }
                .margin({ left: 10, right: 10 })
                .justifyContent(FlexAlign.Start)
                .alignItems(VerticalAlign.Center)
              } else {
                Column() {
                  Text('当前搜索发现隐藏')
                    .fontSize(15 * this.ratio)
                    .fontColor(Color.Gray)
                }
                .width('100%')
                .margin({ top: 20, bottom: 15, left: 10, right: 10 })
              }
              Column() {
                Column() {
                  Row() {
                    Image(this.isShow ? '/resources/icon/show.png' : '/resources/icon/hide.png')
                      .key('isOpenHotSearch')
                      .width(25 * this.ratio)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                      .margin({ right: 5 })
                    Text(this.showText)
                      .fontSize(10 * this.ratio)
                  }
                  .padding({ left: 10, right: 10 })
                  .margin({ left: 10 })
                  .border({ width: 1, radius: 15, color: Color.Gray })
                  .onClick(() => {
                    this.isShow = !this.isShow
                    if (this.isShow == true) {
                      this.showText = '隐藏全网热搜'
                    } else {
                      this.showText = '开启全网热搜'
                    }
                  })
                }
                .width('100%')
                .margin({ bottom: 10 })
                .alignItems(HorizontalAlign.Start)

                Column() {
                  if (this.isShow) {
                    List() {
                      LazyForEach(this.newsNum, item => {
                        ListItem() {
                          Column() {
                            Row() {
                              Row() {
                                Image('/resources/common/activity.png')
                                  .width(30 * this.ratio)
                                  .aspectRatio(1)
                                  .objectFit(ImageFit.Contain)
                                Text('XX热搜')
                                  .fontSize(15 * this.ratio)
                                  .fontColor('#995528')
                                  .fontWeight(FontWeight.Bold)
                                  .margin({ left: 10, right: 10 })
                                Text('今日最新消息全知道')
                                  .fontSize(10 * this.ratio)
                                  .fontColor('#8b5b2f')
                              }
                              .width('100%')
                              .justifyContent(FlexAlign.Start)
                              .alignItems(VerticalAlign.Center)
                            }
                            .padding({ left: 5, right: 5 })
                            .justifyContent(FlexAlign.SpaceBetween)
                            .alignItems(VerticalAlign.Center)

                            LazyForEach(this.newsItem, item => {
                              Row() {
                                Row() {
                                  Row() {
                                    Text(`${item}`)
                                      .fontSize(10 * this.ratio)
                                      .fontColor(Color.White)
                                      .fontWeight(FontWeight.Bold)
                                  }
                                  .width(15 * this.ratio)
                                  .aspectRatio(1)
                                  .border({ radius: 3 * this.ratio })
                                  .margin({ right: 5 })
                                  .backgroundColor('#ceb198')
                                  .justifyContent(FlexAlign.Center)
                                  .alignItems(VerticalAlign.Center)

                                  Text('XX公司5G手机发布会议于xx日开始')
                                    .fontSize(12 * this.ratio)
                                    .maxLines(1)
                                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                                }
                                .alignItems(VerticalAlign.Center)

                                Image(`${Math.round(Math.random()) ? '/resources/icon/up.png' : '/resources/icon/down.png'}`)
                                  .width(10 * this.ratio)
                                  .height(15 * this.ratio)
                                  .objectFit(ImageFit.Contain)
                              }
                              .padding({ left: 5, right: 5 })
                              .width('100%')
                              .height(40 * this.ratio)
                              .justifyContent(FlexAlign.SpaceBetween)
                              .alignItems(VerticalAlign.Center)
                            }, item => item.toString())
                          }
                          .width('100%')
                        }
                        .border({ radius: 15 * this.ratio })
                        .margin({ left: 5, right: 5 })
                        .padding({ top: 5 })
                        .backgroundColor(Color.White)
                        .width(`${this.swiperWidth}%`)
                      }, item => item.toString())
                    }
                    .width('100%')
                    .height('100%')
                    .listDirection(Axis.Horizontal)
                    .padding({ left: 5, right: 5 })
                  }
                }
                .height('70%')
                .width('100%')
              }
              .padding({ top: 10, bottom: 0 })
              .alignItems(HorizontalAlign.Center)
              .width('100%')
            }
            .alignItems(HorizontalAlign.Start)
            .width('100%')
          }
        }
      }
      .width(`${this.widthNum}%`)
      .border({ width: this.widthNum === 45 ? 1 : 0, color: '#10000000' })
    }
    .width('100%')
    .backgroundColor('#F9F9F9')
    .backgroundImage('/resources/common/bgImg.png', ImageRepeat.NoRepeat)
    .backgroundImageSize({ width: '100%', height: '100%' })
  }

  PageTransition() {
    PageTransitionEnter({ duration: 0 })
      .opacity(1)
    PageTransitionExit({ duration: 0 })
      .opacity(1)
  }
}