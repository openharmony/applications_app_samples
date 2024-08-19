/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { dataUriUtils } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'DataUriUtils';
const DOMAIN: number = 0xFF00;
const ID = 1122;

@Entry
@Component
struct DataUriUtils {
  private promptDuration: number = 2000;
  @State loopObserverRegistered: boolean = false;
  @State unhandledRejectionRegistered: boolean = false;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.DataUriUtils'))
            .fontSize(30)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({
              top: 8,
              bottom: 8,
              left: 12
            })
        }
      }
      .width('100%')
      .height('14.36%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.getId'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))
          }
          .id('getId')
          .onClick(() => {
            ((): void => {
              try {
                let id = dataUriUtils.getId('com.example.dataUriUtils/1221');
                hilog.info(DOMAIN, TAG, `dataUriUtils.getId() called. id: ${id}`);
                promptAction.showToast({
                  message: `dataUriUtils.getId() called. id: ${id}`,
                  duration: this.promptDuration
                });
              } catch (err) {
                hilog.info(DOMAIN, TAG, `dataUriUtils.getId() error: ${err}`);
                promptAction.showToast({
                  message: `dataUriUtils.getId() error: ${err}`,
                  duration: this.promptDuration
                });
              }
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.attachId'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))
          }
          .id('attachId')
          .onClick(() => {
            ((): void => {
              let id = 1122;
              let uri = dataUriUtils.attachId(
                'com.example.dataUriUtils',
                id,
              );
              promptAction.showToast({
                message: `dataUriUtils.attachId() called. uri: ${JSON.stringify(uri)}`,
                duration: this.promptDuration
              });
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.deleteId'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))
          }
          .id('deleteId')
          .onClick(() => {
            ((): void => {
              let uri = dataUriUtils.deleteId('com.example.dataUriUtils/1221');
              promptAction.showToast({
                message: `dataUriUtils.deleteId() called. uri: ${JSON.stringify(uri)}`,
                duration: this.promptDuration
              });
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.updateId'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))
          }
          .id('updateId')
          .onClick(() => {
            ((): void => {
              let uri = dataUriUtils.updateId(
                'com.example.dataUriUtils/1221',
                ID
              );
              promptAction.showToast({
                message: `dataUriUtils.updateId() called. uri: ${JSON.stringify(uri)}`,
                duration: this.promptDuration
              });
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })
      }
      .height('86%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .height('100%')
    .width('100%')
  }
}