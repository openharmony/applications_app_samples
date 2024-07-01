/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { BusinessError } from '@ohos.base';
import { autoFillManager, common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const storage = LocalStorage.getShared();
let viewData: autoFillManager.ViewData | undefined = storage.get<autoFillManager.ViewData>('viewData');
let context: common.AutoFillExtensionContext | undefined = storage.get<common.AutoFillExtensionContext>('autoFillExtensionContext');
const TAG: string = 'autoFill';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct AutoFillControl {
  build() {
    Row() {
      Column() {
        List({ space: 10, initialIndex: 0 }) {
          ListItem() {
            Text($r('app.string.user1'))
              .width('100%')
              .height(40)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .borderRadius(5)
          }
          .onClick(() => {
            if (context != undefined) {
              let want: Record<string, Object> = {};
              context.reloadInModal({ data: { text: 'User1', want } }).then(() => {
                hilog.info(DOMAIN_NUMBER, TAG, 'reloadInModal successfully User1.');
              }).catch((err: BusinessError) => {
                hilog.info(DOMAIN_NUMBER, TAG, 'reloadInModal failed User1.');
              })
            }
          })

          ListItem() {
            Text($r('app.string.user2'))
              .width('100%')
              .height(40)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .borderRadius(5)
          }
          .onClick(() => {
            if (viewData != undefined) {
              if (context != undefined) {
                let want: Record<string, Object> = {};
                context.reloadInModal({ data: { text: 'User2', want } }).then(() => {
                  hilog.info(DOMAIN_NUMBER, TAG, 'reloadInModal successfully User2.');
                }).catch((err: BusinessError) => {
                  hilog.info(DOMAIN_NUMBER, TAG, 'reloadInModal failed User2.');
                })
              }
            }
          })

          ListItem() {
            Text($r('app.string.user3'))
              .width('100%')
              .height(40)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .borderRadius(5)
          }
          .onClick(() => {
            if (viewData != undefined) {
              if (context != undefined) {
                let want: Record<string, Object> = {};
                context.reloadInModal({ data: { text: 'User3', want } }).then(() => {
                  hilog.info(DOMAIN_NUMBER, TAG, 'reloadInModal successfully User3.');
                }).catch((err: BusinessError) => {
                  hilog.info(DOMAIN_NUMBER, TAG, 'reloadInModal failed User3.');
                })
              }
            }
          })
        }
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({ strokeWidth: 1, color: $r('app.color.placeholderColor'), startMargin: 20, endMargin: 20 })
        .edgeEffect(EdgeEffect.Spring)
        .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
          console.info('first' + firstIndex);
          console.info('last' + lastIndex);
          console.info('center' + centerIndex);
        })
        .onScroll((scrollOffset: number, scrollState: ScrollState) => {
          console.info(`onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset);
        })
      }
      .width('100%')
      .shadow(ShadowStyle.OUTER_FLOATING_SM)
    }
    .height('100%')
    .shadow(ShadowStyle.OUTER_FLOATING_SM)
  }
}