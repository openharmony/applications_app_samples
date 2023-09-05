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

import router from '@ohos.router';
import { BasicDataSource, FriendMoment } from '@ohos/chatList';
import { getFriendMomentObjFromJSON } from '@ohos/chatList/src/main/ets/utils/DataFactory';
import Constants from '@ohos/chatList/src/main/ets/utils/Constants';
import Logger from '@ohos/chatList/src/main/ets/utils/Logger';

const TAG: string = 'entry_FriendsMomentsPage';


@Entry
@Component
struct FriendsMomentsPage {
  @State itemLength: number = 0
  private momentData = new FriendMomentsData()

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.icon_back'))
            .height(30)
            .width(30)
            .onClick(() => {
              router.back()
            }).syncLoad(true)

          Text($r('app.string.circle'))
            .fontSize(20)
            .fontColor(Color.White)
          Image($r('app.media.icon_talk'))
            .height(30)
            .width(30)
        }
        .backgroundColor(Color.Black)
        .justifyContent(FlexAlign.SpaceBetween)
        .height(50)
        .width('100%')
        .padding({ left: 10, right: 10 })

        Column() {
          List() {
            ListItem() {
              Column() {
                Row() {
                  Image($r('app.media.user_ba'))
                }
                .height('100%')
                .width('100%')

                Row() {
                  Text($r('app.string.myself'))
                    .fontSize(20)
                    .fontColor(Color.White)
                    .margin({ top: -15,right: 15 })
                  Image($r('app.media.personality3'))
                    .height($r('app.integer.layout_50'))
                    .width($r('app.integer.layout_50'))
                }
                .margin({ top: $r('app.integer.layout_minus_25') })
              }
              .margin({ bottom: 20 })

              .alignItems(HorizontalAlign.End)
              .height('40%')
            }

            LazyForEach(this.momentData, (msg: FriendMoment) => {
              ListItem() {
                OneMoment({ moment: msg })
              }
            }, (msg: FriendMoment) => msg.id)
          }
          .width('100%')
          .height('100%')
          .listDirection(Axis.Vertical)
        }
        .height('100%')
      }
      .height('100%')
      .padding({ bottom: 50 })
    }
    .height('100%')
    .width('100%')
  }

  async aboutToAppear(): Promise<void> {
    Logger.info(TAG, 'aboutToAppear');
    await this.makeDataLocal();
  }

  async makeDataLocal(): Promise<void>{
    Logger.info(TAG, 'makeDataLocal');
    let FriendMoment = await getFriendMomentObjFromJSON();
    for (let i = 0; i < Constants.FRIEND_MOMENT_MOCK_DATA_COUNT; i++) {
      this.momentData.pushData(FriendMoment[i]);
    }
  }
}

@Component
struct OneMoment {
  private moment: FriendMoment

  build() {
    Row() {
      Row() {
        Image(this.moment.user.userImage)
          .autoResize(false)
      }
      .width(50)
      .height(50)

      Column() {
        Text(this.moment.user.userName)
          .fontSize(15)
          .fontColor(Color.Black)
        Text(this.moment.text)
          .fontSize(13)
          .fontColor(Color.Black)
        Grid() {
          ForEach(this.moment.imageList, (image: string, index: number) => {
            GridItem() {
              MomentsImage({ imageStr: image, imageStrId: index })
            }
          }, image => image)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr')
        .columnsGap($r('app.integer.layout_1'))
        .rowsGap($r('app.integer.layout_1'))
        .height($r('app.integer.layout_250'))
        .width($r('app.integer.layout_250'))
        Row() {
          Text(this.moment.time).fontColor("#e3e3e3").fontSize(12)
          Image($r('app.media.afr')).height(15).width(20)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .margin({ top: 5 })
        .padding({ right: 5 })
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .margin({ left: 10 })
    }
    .justifyContent(FlexAlign.Start)
    .margin({ left: 10 })
    .padding({ right: 70 })
    .alignItems(VerticalAlign.Top)
  }
}

@Component
struct MomentsImage {
  private imageStr: string | Resource = $r('app.media.photo0')
  private imageStrId: number = 0
  @State active: boolean = false

  build() {
    Stack() {
      Image(this.imageStr)
        .id(`${this.imageStrId}`)
        .width(70)
        .height(70)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/FullImagePage',
            params: { imageStrId: this.imageStrId }
          })
        })
    }
    .width(70)
    .height(70)
  }
}

class FriendMomentsData extends BasicDataSource {
  momentList: Array<FriendMoment> = []

  public totalCount(): number {
    return this.momentList.length
  }

  public getData(index: number): any {
    return this.momentList[index]
  }

  public addData(index: number, data: FriendMoment): void {
    this.momentList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: FriendMoment): void {
    this.momentList.push(data)
    this.notifyDataAdd(this.momentList.length - 1)
  }
}