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

import { FillRequestCallback, FillResponse } from "application/AutoFillRequest";
import ViewData from 'application/ViewData';
import Logger from '../log/Logger';

const storage = LocalStorage.getShared();
const fillCallback = storage.get<FillRequestCallback>('fillCallback');
const viewData: ViewData | undefined = storage.get<ViewData>('viewData');

function successFunc(data: ViewData, userName: string, passWord: string) {
  if (data.pageNodeInfos.length !== 2) {
    Logger.info('get unEnough pageNodeInfos, skipping!');
    return;
  } else {
    data.pageNodeInfos[0].value = userName;
    data.pageNodeInfos[1].value = passWord;
  }
  if (fillCallback) {
    let response: FillResponse = { viewData: data };
    fillCallback.onSuccess(response);
  }
}

function cancelFunc() {
  if (fillCallback) {
    fillCallback.onCancel();
  }
}

@Entry
@Component
struct AutoFillControl {
  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image($r('app.media.ic_public_back'))
          .height(24)
          .width(24)
          .id('back')
          .onClick(() => {
            Logger.info('autofill cancel');
            cancelFunc();
          })
        Text($r('app.string.userPassWord_title'))
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(20)
          .fontColor($r('app.color.userPassWord_title'))
          .margin({ left: '4.4%' })
      }.margin({ top: '8.8%', left: '4.9%' }).height('7.2%')

      Row() {
        Text($r('app.string.user1'))
          .fontSize(16)
          .fontColor($r('app.color.user'))
          .lineHeight(22)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-Medium')
          .margin({ left: '3.3%' })
      }
      .borderRadius(24)
      .backgroundColor($r('app.color.controlBackColor'))
      .width('95%')
      .height('7.2%')
      .onClick(() => {
        if (viewData != undefined) {
          successFunc(viewData, "user1", "123456");
        }
      })

      Row() {
        Text($r('app.string.user2'))
          .fontSize(16)
          .fontColor($r('app.color.user'))
          .lineHeight(22)
          .fontWeight(500)
          .margin({ left: '3.3%' })
          .fontFamily('HarmonyHeiTi-Medium')
      }
      .id("second")
      .borderRadius(24)
      .backgroundColor($r('app.color.controlBackColor'))
      .width('95%')
      .height('7.2%')
      .margin({ top: '24px' })
      .onClick(() => {
        if (viewData != undefined) {
          successFunc(viewData, "user2", "abcdef");
        }
      })

      Row() {
        Text($r('app.string.user3'))
          .fontSize(16)
          .fontColor($r('app.color.user'))
          .lineHeight(22)
          .fontWeight(500)
          .margin({ left: '3.3%' })
          .fontFamily('HarmonyHeiTi-Medium')
      }
      .id("third")
      .borderRadius(24)
      .backgroundColor($r('app.color.controlBackColor'))
      .width('95%')
      .height('7.2%')
      .margin({ top: '24px' })
      .onClick(() => {
        if (viewData != undefined) {
          successFunc(viewData, "user3", "ABCDEF");
        }
      })
    }.backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}