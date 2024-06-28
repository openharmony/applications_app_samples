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

import { FillRequestCallback, FillResponse } from 'application/AutoFillRequest';
import ViewData from 'application/ViewData';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { autoFillManager } from '@kit.AbilityKit';

const storage = LocalStorage.getShared();
const TAG: string = 'autoFill';
const DOMAIN_NUMBER: number = 0xFF00;
let fillCallback: FillRequestCallback | undefined = storage.get<FillRequestCallback>('fillCallback');
let viewData: ViewData | undefined = storage.get<ViewData>('viewData');
let customData: autoFillManager.CustomData | undefined = storage.get<autoFillManager.CustomData>('customData');

function successFunc(data: ViewData, userName: string, passWord: string) {
  if (data.pageNodeInfos.length !== 2) {
    hilog.info(DOMAIN_NUMBER, TAG, 'get unEnough pageNodeInfos, skipping!');
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

function onFailure() {
  if (fillCallback) {
    fillCallback.onFailure();
  }
}

@Entry
@Component
struct BiometricAuthentication {
  @State message: Resource = $r('app.string.biological_Certification');

  build() {
    Column() {
      Column() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Image($r('app.media.arrow'))
            .height(40)
            .width(40)
            .onClick(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'autofill cancel');
              cancelFunc();
            })
          Text(this.message)
            .fontWeight(500)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontSize(22)
            .fontColor($r('app.color.userPassWord_title'))
            .margin({ left: '2.4%' })
        }.margin({ top: '13.8%', left: '4.9%' }).height('7.2%')

        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Image($r('app.media.svg'))
            .height(58)
            .width(58)
        }.margin({ top: '42.8%' })
      }
      .height('70%')

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
        Column() {
          Row() {
            Button($r('app.string.success'))
              .type(ButtonType.Normal)
              .fontSize(16)
              .fontWeight(500)
              .id('success')
              .backgroundColor($r('app.color.cancelBtnColor'))
              .borderRadius(20)
              .height(40)
              .width('86.7%')
              .onClick(() => {
                if (customData != undefined) {
                  if (viewData != undefined) {
                    hilog.info(DOMAIN_NUMBER, TAG, 'Reload in modal custom data is ', JSON.stringify(customData.data));
                    let flag = customData.data.text as string;
                    if (fillCallback != undefined) {
                      if (flag == 'User1') {
                        successFunc(viewData, 'user1', '123456');
                      } else if (flag == 'User2') {
                        successFunc(viewData, 'user2', 'abcdef');
                      } else if (flag == 'User3') {
                        successFunc(viewData, 'user3', 'ABCDEF');
                      } else {
                        return;
                      }
                    }
                  }
                }
              })
          }
          .margin({ bottom: '12vp' })

          Row() {
            Button($r('app.string.fail'))
              .type(ButtonType.Normal)
              .fontSize(16)
              .fontWeight(500)
              .backgroundColor($r('app.color.cancelBtnColor'))
              .borderRadius(20)
              .id('fail')
              .height(40)
              .width('86.7%')
              .onClick(() => {
                onFailure();
              })
          }
          .margin({ bottom: '12vp' })

          Row() {
            Button($r('app.string.onCancel'))
              .type(ButtonType.Normal)
              .fontSize(16)
              .fontWeight(500)
              .backgroundColor($r('app.color.cancelColor'))
              .fontColor($r('app.color.cancelBtnColor'))
              .id('cancel')
              .borderRadius(20)
              .height(40)
              .width('86.7%')
              .onClick(() => {
                cancelFunc();
              })
          }
        }
        .margin({ bottom: '44vp' })
      }
      .height('30%')
    }
    .backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}
