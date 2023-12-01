/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { Log, add, MyTitleBar, ResManager, nativeMulti } from 'library';
import { BusinessError } from '@ohos.base';
import Logger from '../logger/Logger';
import router from '@ohos.router';

const TAG = 'Index';

@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Column() {
      List() {
        ListItem() {
          MyTitleBar()
        }
        .margin({ left: '35px', top: '32px' })

        ListItem() {
          Text(this.message)
            .fontFamily('HarmonyHeiTi')
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .width('100%')
            .fontWeight(FontWeight.Bold)
        }
        .width('685px')
        .margin({ top: 30, bottom: 10 })

        ListItem() {
          // ResManager返回的Resource对象，可以传给组件直接使用，也可以从中取出资源来使用
          Image(ResManager.getPic())
            .id('image')
            .borderRadius('48px')
        }
        .width('685px')
        .margin({ top: 10, bottom: 10 })
        .padding({ left: 12, right: 12, top: 4, bottom: 4 })

        ListItem() {
          Text($r('app.string.add'))
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .width('100%')
            .fontWeight(500)
            .height('100%')
        }
        .id('add')
        .borderRadius(24)
        .width('685px')
        .height('84px')
        .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .margin({ top: 10, bottom: 10 })
        .padding({ left: 12, right: 12, top: 4, bottom: 4 })
        .onClick(() => {
          Log.info('add button click!');
          this.message = 'result: ' + add(1, 2);
        })

        ListItem() {
          Text($r('app.string.get_string_value'))
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .width('100%')
            .fontWeight(500)
            .height('100%')
        }
        .id('getStringValue')
        .borderRadius(24)
        .width('685px')
        .height('84px')
        .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .margin({ top: 10, bottom: 10 })
        .padding({ left: 12, right: 12, top: 4, bottom: 4 })
        .onClick(() => {
          // 先通过当前上下文获取hsp模块的上下文，再获取hsp模块的resourceManager，然后再调用resourceManager的接口获取资源
          getContext()
            .createModuleContext('library')
            .resourceManager
            .getStringValue(ResManager.getDesc())
            .then(value => {
              Logger.info(TAG, `getStringValue is ${value}`);
              this.message = 'getStringValue is ' + value;
            })
            .catch((err: BusinessError) => {
              Logger.info(TAG, `getStringValue promise error is ${err}`);
            });
        })

        ListItem() {
          Text($r('app.string.native_multi'))
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .width('100%')
            .fontWeight(500)
            .height('100%')
        }
        .id('nativeMulti')
        .borderRadius(24)
        .width('685px')
        .height('84px')
        .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .margin({ top: 10, bottom: 10 })
        .padding({ left: 12, right: 12, top: 4, bottom: 4 })
        .onClick(() => {
          Log.info('nativeMulti button click!');
          this.message = 'result: ' + nativeMulti(3, 4);
        })

        ListItem() {
          Text($r('app.string.click_to_index'))
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .width('100%')
            .fontWeight(500)
            .height('100%')
        }
        .id('clickToIndex')
        .borderRadius(24)
        .width('685px')
        .height('84px')
        .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .margin({ top: 10, bottom: 10 })
        .padding({ left: 12, right: 12, top: 4, bottom: 4 })
        .onClick(() => {
          router.pushUrl({
            url: '@bundle:com.samples.hspsample/library/ets/pages/Index'
          }).then(() => {
            console.log('push page success');
          }).catch((err: BusinessError) => {
            console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
          })
        })

        ListItem() {
          Text($r('app.string.click_to_menu'))
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .width('100%')
            .fontWeight(500)
            .height('100%')
        }
        .id('clickToMenu')
        .borderRadius(24)
        .width('685px')
        .height('84px')
        .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .margin({ top: 10, bottom: 10 })
        .padding({ left: 12, right: 12, top: 4, bottom: 4 })
        .onClick(() => {
          router.pushUrl({
            url: '@bundle:com.samples.hspsample/library/ets/pages/Menu'
          }).then(() => {
            console.log('push page success');
            Logger.info(TAG, 'push page success');
          }).catch((err: BusinessError) => {
            Logger.error(TAG, `pushUrl failed, code is ${err.code}, message is ${err.message}`);
          })
        })

        ListItem() {
          Text($r('app.string.back'))
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .width('100%')
            .fontWeight(500)
            .height('100%')
        }
        .id('clickToBack')
        .borderRadius(24)
        .width('685px')
        .height('84px')
        .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .margin({ top: 10, bottom: 10 })
        .padding({ left: 12, right: 12, top: 4, bottom: 4 })
        // 绑定点击事件
        .onClick(() => {
          router.pushUrl({
            url: '@bundle:com.samples.hspsample/library/ets/pages/Back'
          }).then(() => {
            console.log('push page success');
            Logger.info(TAG, 'push page success');
          }).catch((err: BusinessError) => {
            Logger.error(TAG, `pushUrl failed, code is ${err.code}, message is ${err.message}`);
          })
        })
      }
      .alignListItem(ListItemAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }
}