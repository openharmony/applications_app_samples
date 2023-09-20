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
import { ChatContact, BasicDataSource, FriendMoment } from '@ohos/chatlist';
import Logger from '@ohos/chatlist/src/main/ets/utils/Logger';
import hiTraceMeter from '@ohos.hiTraceMeter';
import http from '@ohos.net.http';
import taskpool from '@ohos.taskpool';
import FriendMomentJsonUrl from '@ohos/chatlist/src/main/ets/utils/FriendMomentJsonUrl';

const TAG: string = 'entry_FriendsMomentsPage';
const ABOUT_TO_APPEAR_TRACE: string = 'FriendsPage_AboutToAppear_HiTrace';
const ABOUT_TO_APPEAR_TRACE_ID: number = 1; // aboutToAppear 中使用的 taskId
const MAKE_LOCAL_DATA_TRACE: string = 'FriendsPage_MakeLocalData_HiTrace';
const MAKE_LOCAL_DATA_TRACE_ID: number = 2; // makeDataLocal 中使用的 taskId

@Entry
@Component
struct FriendsMomentsPage {
  @State itemLength: number = 0;
  @State cachedCountNumber: number = 3; // 懒加载缓存数
  @StorageLink('momentData') momentData: FriendMomentsData = new FriendMomentsData();

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.icon_friend_moment_back'))
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
        .width($r('app.string.layout_100'))
        .padding({
          left: $r('app.integer.friendMomentsPage_title_padding_left'),
          right: $r('app.integer.friendMomentsPage_title_padding_right')
        })

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
                  Text($r('app.string.myself'))
                    .fontSize($r('app.integer.friendMomentsPage_name_fontSize'))
                    .fontColor(Color.White)
                    .margin({
                      top: $r('app.integer.friendMomentsPage_name_margin_left'),
                      right: $r('app.integer.friendMomentsPage_name_margin_right')
                    })
                  Image($r('app.media.head_image'))
                    .height($r('app.integer.layout_50'))
                    .width($r('app.integer.layout_50'))
                }
                .margin({ top: $r('app.integer.layout_minus_25') })
              }
              .margin({ bottom: $r('app.integer.friendMomentsPage_owner_margin_bottom') })
              .alignItems(HorizontalAlign.End)
              .height($r('app.string.friendMomentsPage_owner_margin_height'))
            }

            LazyForEach(this.momentData, (moment: FriendMoment) => {
              ListItem() {
                OneMoment({ moment: moment })
              }
            }, (moment: FriendMoment) => moment.id)
          }
          .cachedCount(this.cachedCountNumber)
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

  async aboutToAppear(): Promise<void> {
    hiTraceMeter.startTrace(ABOUT_TO_APPEAR_TRACE, ABOUT_TO_APPEAR_TRACE_ID);
    Logger.info(TAG, 'aboutToAppear');
    await this.makeLocalData();
    hiTraceMeter.finishTrace(ABOUT_TO_APPEAR_TRACE, ABOUT_TO_APPEAR_TRACE_ID);
  }

  // 本地mock数据生成朋友圈数据，推到momentData里
  async makeLocalData(): Promise<void> {
    Logger.info(TAG, 'makeLocalData');
    hiTraceMeter.startTrace(MAKE_LOCAL_DATA_TRACE, MAKE_LOCAL_DATA_TRACE_ID);
    let friendMomentJsonStr: http.HttpResponse = await getWebData(FriendMomentJsonUrl.FRIEND_MOMENT_JSON_URL[0]);
    if (typeof (friendMomentJsonStr.result) === 'string') {
      let friendMomentObj: Array<FriendMoment> = await getFriendMomentObj(friendMomentJsonStr.result);
      for (let i = 0; i < friendMomentObj.length; i++) {
        this.momentData.pushData(friendMomentObj[i]);
      }
    } else {
      Logger.info(TAG, "makeLocalData get JSON error");
    }
    hiTraceMeter.finishTrace(MAKE_LOCAL_DATA_TRACE, MAKE_LOCAL_DATA_TRACE_ID);
  }
}

@Component
struct OneMoment {
  private moment: FriendMoment = new FriendMoment('', new ChatContact('', ''), '', '', [], '', '');
  @State imageListMinLength: number = 2;

  build() {
    Row() {
      Row() {
        Image(this.moment.user.userImage)
          .autoResize(false)
          .borderRadius($r('app.integer.friendMomentsPage_useImage_radius'))
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
        if (this.moment.imageList.length) {
          Grid() {
            if (this.moment.imageList.length >= this.imageListMinLength) {
              ForEach(this.moment.imageList, (image: string, index?: number) => {
                GridItem() {
                  Image(image)
                    .id(`${index}`)
                    .width($r('app.integer.friendMomentsPage_image_width'))
                    .height($r('app.integer.friendMomentsPage_image_height'))
                    .borderRadius($r('app.integer.friendMomentsPage_image_radius'))
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/FullImagePage',
                        params: {
                          resourceStr: image,
                          isMedia: false
                        }
                      })
                    })
                }
              }, (image: string) => image)
            }
            else {
              GridItem() {
                Image(this.moment.imageList[0])
                  .width($r('app.integer.friendMomentsPage_single_image_width'))
                  .height($r('app.integer.friendMomentsPage_single_image_height'))
                  .borderRadius($r('app.integer.friendMomentsPage_single_image_radius'))
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/FullImagePage',
                      params: {
                        resourceStr: this.moment.imageList[0],
                        isMedia: false
                      }
                    })
                  })
              }
            }
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr 1fr')
          .columnsGap($r('app.integer.layout_1'))
          .rowsGap($r('app.integer.layout_1'))
          .height($r('app.integer.layout_250'))
          .width($r('app.integer.layout_250'))
        }
        else {
          Grid() {
            GridItem() {
              Stack({ alignContent: Alignment.Center }) {
                Image(this.moment.mediaPreview)
                  .width($r('app.integer.friendMomentsPage_single_video_width'))
                  .height($r('app.integer.friendMomentsPage_single_video_height'))
                  .borderRadius($r('app.integer.friendMomentsPage_single_video_radius'))

                Image($r('app.media.ic_public_play_norm'))
                  .width($r('app.integer.friendMomentsPage_image_width'))
                  .height($r('app.integer.friendMomentsPage_image_height'))
              }
              .width($r('app.integer.friendMomentsPage_single_video_width'))
              .height($r('app.integer.friendMomentsPage_single_video_height'))
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/FullImagePage',
                  params: {
                    resourceUrl: this.moment.media,
                    isMedia: true
                  }
                })
              })
            }
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr 1fr')
          .columnsGap($r('app.integer.layout_1'))
          .rowsGap($r('app.integer.layout_1'))
          .height($r('app.integer.layout_250'))
          .width($r('app.integer.layout_250'))
        }
        Row() {
          Text(this.moment.time).fontColor("#e3e3e3").fontSize($r('app.integer.friendMomentsPage_time_fontSize'))
          Image($r('app.media.afr'))
            .height($r('app.integer.friendMomentsPage_time_height'))
            .width($r('app.integer.friendMomentsPage_time_width'))
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

class FriendMomentsData extends BasicDataSource<FriendMoment> {
  momentList: Array<FriendMoment> = []
  getJsonIndex: number = 1

  // 获取数据列表长度
  public totalCount(): number {
    return this.momentList.length;
  }

  // 根据index获取具体项
  public getData(index: number): FriendMoment {
    // 判断组件是否已经缓存到最后一项数据了
    if (index == this.momentList.length - 1) {
      // 目前json文件只有3个，所以对3取余后加一实现循环获取3个json
      getFriendMomentByTaskPool(FriendMomentJsonUrl.FRIEND_MOMENT_JSON_URL[this.getJsonIndex % 3]);
      this.getJsonIndex++;
    }
    return this.momentList[index];
  }

  // 向规定位置添加数据
  public addData(index: number, data: FriendMoment): void {
    this.momentList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  // 向列表追加数据
  public pushData(data: FriendMoment): void {
    this.momentList.push(data);
    this.notifyDataAdd(this.momentList.length - 1);
  }
}

// task任务池
async function getFriendMomentByTaskPool(jsonUrl) {
  let task: taskpool.Task = new taskpool.Task(getWebData, jsonUrl);
  let webData: string = await taskpool.execute(task, taskpool.Priority.MEDIUM) as string;
  let friendMomentJsonStr: Array<FriendMoment> = await getFriendMomentObj(webData['result']);
  let momentData: FriendMomentsData = AppStorage.get<FriendMomentsData>('momentData');
  for (let i = 0; i < friendMomentJsonStr.length; i++) {
    momentData.pushData(friendMomentJsonStr[i]);
  }
  AppStorage.setOrCreate('momentData', momentData);
}

// 获取网络数据
@Concurrent
async function getWebData(url: string): Promise<http.HttpResponse> {
  Logger.info('getWebData onMessage start');
  try {
    return await http.createHttp().request(
      url,
      { header: {
        'Content-Type': 'application/json'
      },
        connectTimeout: FriendMomentJsonUrl.CONNECT_TIME, readTimeout: FriendMomentJsonUrl.READ_TIME
      })
  } catch (err) {
    Logger.error(`get result failed, code is ${err.code}, message is ${err.message}`);
  }
}

async function getFriendMomentObj(friendMomentStr: string): Promise<Array<FriendMoment>> {
  let jsonObj: Array<FriendMoment> = await JSON.parse(friendMomentStr).FriendMoment;
  let friendMomentBuckets: Array<FriendMoment> = new Array<FriendMoment>();
  // 映射json数据为FriendMoment对象
  for (let i = 0; i < jsonObj.length; i++) {
    let contactTemp = new ChatContact(jsonObj[i].user.userId, jsonObj[i].user.userName,
      jsonObj[i].user.userImage);
    let chatModelTemp = new FriendMoment(jsonObj[i].id, contactTemp, jsonObj[i].text, '',
      jsonObj[i].imageList, jsonObj[i].media, jsonObj[i].mediaPreview);
    friendMomentBuckets.push(chatModelTemp);
  }
  Logger.info('getFriendMomentObj onMessage end');
  return friendMomentBuckets;
}