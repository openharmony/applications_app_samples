/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import taskpool from '@ohos.taskpool';
import { IconItem } from './IconView';
import { IconItemSource } from './IconItemSource';
import Logger from '../util/Logger';

const LOAD_SUCCESS: string = getContext().resourceManager.getStringSync($r('app.string.process_success'));

@Concurrent
function loadPicture(count: number): IconItemSource[] {
  let iconItemSourceList: IconItemSource[] = [];
  // 遍历添加count*6个IconItem的数据
  for (let index = 0; index < count; index++) {
    const numStart: number = index * 6;
    // 此处循环使用6张图片资源
    iconItemSourceList.push(new IconItemSource($r('app.media.nearby'), `item${numStart + 1}`));
    iconItemSourceList.push(new IconItemSource($r('app.media.scan'), `item${numStart + 2}`));
    iconItemSourceList.push(new IconItemSource($r('app.media.shop'), `item${numStart + 3}`));
    iconItemSourceList.push(new IconItemSource($r('app.media.cards'), `item${numStart + 4}`));
    iconItemSourceList.push(new IconItemSource($r('app.media.album'), `item${numStart + 5}`));
    iconItemSourceList.push(new IconItemSource($r('app.media.applet'), `item${numStart + 6}`));
  }
  taskpool.Task.sendData(iconItemSourceList.length);
  return iconItemSourceList;
}

function notice(data: number): void {
  Logger.info(LOAD_SUCCESS + data);
}

@Component
export struct TaskSendDataUsage {
  @State iconItemSourceList: IconItemSource[] = [];

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r("app.media.back"))
          .height(24)
          .width(24)
          .onClick(() => {
            router.back();
          })

        Text($r('app.string.scenario_3'))
          .fontSize(24)
          .lineHeight(30)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({
            left: 16
          })
      }
      .width($r('app.string.percent_100'))
      .height(50)
      .justifyContent(FlexAlign.Start)
      .padding({
        left: 24
      })

      Button($r('app.string.load_image'), { type: ButtonType.Normal, stateEffect: true })
        .fontSize(14)
        .borderRadius(8)
        .backgroundColor(Color.Blue)
        .width(250)
        .height(60)
        .margin({
          top: 30
        })
        .onClick(() => {
          let lodePictureTask: taskpool.Task = new taskpool.Task(loadPicture, 30);
          lodePictureTask.onReceiveData(notice);
          taskpool.execute(lodePictureTask).then((res: Object) => {
            this.iconItemSourceList = res as IconItemSource[];
          })
        })
      if (this.iconItemSourceList.length > 0) {
        List({ space: 20 }) {
          ForEach(this.iconItemSourceList, (item: IconItemSource) => {
            ListItem() {
              IconItem({ image: item.image, text: item.text });
            }
          }, (item: IconItemSource, index) => index.toString())
        }
        .divider({ strokeWidth: 2, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
        .width($r('app.string.percent_100'))
        .height($r('app.string.percent_100'))
        .layoutWeight(1)
      }
    }
    .width($r('app.string.percent_100'))
    .height($r('app.string.percent_100'))
    .alignItems(HorizontalAlign.Center)
  }
}