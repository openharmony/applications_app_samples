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

import { BasicDataSource } from '@ohos/chatList';
import { ChatContact, FriendMoment } from '@ohos/chatList';
import router from '@ohos.router';
import Logger from '../utils/Logger';

const TAG: string = '[Sample_FriendsMomentsPage]';

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
            .height($r('app.integer.friendMomentsPage_background_width'))
            .width($r('app.integer.friendMomentsPage_background_height'))
            .onClick(() => {
              router.back()
            }).syncLoad(true)

          Text($r('app.string.circle'))
            .fontSize($r('app.integer.friendMomentsPage_title_fontSize'))
            .fontColor(Color.White)
          Image($r('app.media.icon_talk'))
            .height($r('app.integer.friendMomentsPage_background_height'))
            .width($r('app.integer.friendMomentsPage_background_width'))
        }
        .backgroundColor(Color.Black)
        .justifyContent(FlexAlign.SpaceBetween)
        .height($r('app.integer.friendMomentsPage_title_height'))
        .width('100%')
        .padding({ left: $r('app.integer.friendMomentsPage_title_padding_left'), right: $r('app.integer.friendMomentsPage_title_padding_right') })

        Column() {
          List() {
            ListItem() {
              Column() {
                Row() {
                  Image($r("app.media.user_bg"))
                }
                .height($r('app.string.layout_100'))
                .width($r('app.string.layout_100'))

                Row() {
                  Text("name")
                    .fontSize($r('app.integer.friendMomentsPage_name_fontSize'))
                    .fontColor(Color.White)
                    .margin({ top: $r('app.integer.friendMomentsPage_name_margin_left'),right: $r('app.integer.friendMomentsPage_name_margin_right') })
                  Image($r("app.media.profile_photo_3"))
                    .height($r('app.integer.friendMomentsPage_image_height'))
                    .width($r('app.integer.friendMomentsPage_image_width'))
                    .borderRadius($r('app.integer.friendMomentsPage_image_borderRadius'))
                    .margin({ right: $r('app.integer.friendMomentsPage_image_margin_right') })
                }.margin({ top: $r('app.integer.friendMomentsPage_image_margin_top') })
              }
              .margin({ bottom: $r('app.integer.friendMomentsPage_owner_margin_bottom') })
              .alignItems(HorizontalAlign.End)
              .height($r('app.string.friendMomentsPage_owner_margin_height'))
            }

            LazyForEach(this.momentData, (msg: FriendMoment) => {
              ListItem() {
                OneMoment({ moment: msg })
              }
            }, (msg: FriendMoment) => msg.id)
          }
          .width($r('app.string.layout_100'))
          .height($r('app.string.layout_100'))
          .listDirection(Axis.Vertical)
        }
        .height($r('app.string.layout_100'))
      }
      .height($r('app.string.layout_100'))
      .padding({ bottom: $r('app.integer.friendMomentsPage_layout_padding_bottom') })
    }
    .height($r('app.string.layout_100'))
    .width($r('app.string.layout_100'))
  }

  aboutToAppear(): void {
    Logger.info(TAG, 'enter aboutToAppear');
    this.makeLocalData();
  }

  // 本地mock数据生成朋友圈数据，推到momentData里
  makeLocalData() {
    for (let i = 0;i < 100; i++) {
      let picNum = $r(`app.string.landscape${(i % 50).toString()}`);
      let imageStr = `/resources/images/${picNum}.jpg`;
      let mo = new FriendMoment( // 生成单个朋友圈数据
        i.toString(),
        new ChatContact(
          i.toString(),
          `${getContext().resourceManager.getStringSync($r('app.string.friend_word'))}${i.toString()}`,
          imageStr
        ),
        `${getContext().resourceManager.getStringSync($r('app.string.chatCommunity'))}${i.toString()}`
      );
      this.momentData.pushData(mo)
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
      .width($r('app.integer.friendMomentsPage_oneMoment_width'))
      .height($r('app.integer.friendMomentsPage_oneMoment_height'))

      Column() {
        Text(this.moment.user.userName)
          .fontSize($r('app.integer.friendMomentsPage_useName_fontSize'))
          .fontColor(Color.Black)
        Text(this.moment.text)
          .fontSize($r('app.integer.friendMomentsPage_userText_fontSize'))
          .fontColor(Color.Black)
        Row({ space: 5 }) {
          MomentsImage({ imageStr: $r("app.media.landscape1"), imageStrId: 1 })
          MomentsImage({ imageStr: $r("app.media.landscape2"), imageStrId: 2 })
          MomentsImage({ imageStr: $r("app.media.landscape3"), imageStrId: 3 })
        }
        .margin({ top: $r('app.integer.friendMomentsPage_row_margin_top'), right: $r('app.integer.friendMomentsPage_row_margin_right') })

        Row({ space: 5 }) {
          MomentsImage({ imageStr: $r("app.media.landscape4"), imageStrId: 4 })
          MomentsImage({ imageStr: $r("app.media.landscape5"), imageStrId: 5 })
          MomentsImage({ imageStr: $r("app.media.landscape6"), imageStrId: 6 })
        }
        .margin({ top: $r('app.integer.friendMomentsPage_row_margin_top'), right: $r('app.integer.friendMomentsPage_row_margin_right') })

        Row({ space: 5 }) {
          MomentsImage()
          MomentsImage({ imageStr: $r("app.media.landscape7"), imageStrId: 7 })
          MomentsImage({ imageStr: $r("app.media.landscape8"), imageStrId: 8 })
        }
        .margin({ top: $r('app.integer.friendMomentsPage_row_margin_top'), right: $r('app.integer.friendMomentsPage_row_margin_right') })

        Row() {
          Text(this.moment.time).fontColor("#e3e3e3").fontSize($r('app.integer.friendMomentsPage_time_fontSize'))
          Image($r('app.media.afr')).height($r('app.integer.friendMomentsPage_time_height')).width($r('app.integer.friendMomentsPage_time_width'))
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width($r('app.string.layout_100'))
        .margin({ top: $r('app.integer.friendMomentsPage_row_margin_top') })
        .padding({ right: $r('app.integer.friendMomentsPage_row_padding_right') })
      }
      .alignItems(HorizontalAlign.Start)
      .width($r('app.string.layout_100'))
      .margin({ left: $r('app.integer.friendMomentsPage_col_margin_left') })
    }
    .justifyContent(FlexAlign.Start)
    .margin({ left: $r('app.integer.friendMomentsPage_col_margin_left') })
    .padding({ right: $r('app.integer.friendMomentsPage_col_padding_right') })
    .alignItems(VerticalAlign.Top)
  }
}

@Component
struct MomentsImage {
  private imageStr: string | Resource = $r("app.media.landscape0")
  private imageStrId: number = 0
  @State active: boolean = false

  build() {
    Stack() {
      Image(this.imageStr)
        .id(`${this.imageStrId}`)
        .width($r('app.integer.friendMomentsPage_image_width'))
        .height($r('app.integer.friendMomentsPage_image_height'))
        .onClick(() => {
          router.pushUrl({
            url: 'pages/FullImagePage',
            params: { imageStrId: this.imageStrId }
          })
        })
    }
    .width($r('app.integer.friendMomentsPage_image_width'))
    .height($r('app.integer.friendMomentsPage_image_height'))
  }
}

class FriendMomentsData extends BasicDataSource {
  momentList: Array<FriendMoment> = []

  // 获取数据列表长度
  public totalCount(): number {
    return this.momentList.length
  }

  // 根据index获取具体项
  public getData(index: number): any {
    return this.momentList[index]
  }

  // 向规定位置添加数据
  public addData(index: number, data: FriendMoment): void {
    this.momentList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  // 向列表追加数据
  public pushData(data: FriendMoment): void {
    this.momentList.push(data)
    this.notifyDataAdd(this.momentList.length - 1)
  }
}