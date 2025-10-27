/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { DevParamsComponent } from '../component/DevParamsComponent';
import { SendCommandComponent } from '../component/SendCommandComponent';
import { ComCommandComponent } from '../component/ComCommandComponent';
import { common } from '@kit.AbilityKit'
import { prompt } from '@kit.ArkUI'
import RpcTool from '../tool/RpcTool';
import { hilog } from '@kit.PerformanceAnalysisKit';
import DevParams from '../utils/DevParams';

const IMAGE_WIDTH_HEIGHT: number = 60; // 图片宽高
const IMAGE_INTERVAL: number = 20; // 图片与图片间距
const IMAGE_TEXT_INTERVAL: number = 10; // 图片和文本间距
const MARGIN_LEFT_RIGHT: number = 2; // 顶部菜单栏与屏幕边缘间隔
const MARGIN_TOP_BOTTOM: number = 20; // 菜单栏上下间距

@Preview
@Entry
@Component
struct Index {
  @State description: string = '';
  @State currentIndex: number = 0;
  @State connectStatus: boolean = false;
  saveMessage : string = `save config success`;

  @State devType: number = -1;
  @State vendorId: string = '';
  @State productId: string = '';
  @State revision: string = '';
  @State volumeNumType: number = 0;
  @State volumeStrType: string = '';
  @State blockNum: number = 0;
  @State blockVolume: number = 0;
  @State devParams: DevParams = new DevParams();
  @State dataOfSendCommandPage: string = '';
  @State execResult: string = '';
  @State execResultOfComCommandPage: string = '';
  @State dataOfComCommandPage: string = '';


  private topMenu = [
    ['设备参数', $rawfile('ic_keyboard_set_normal.svg'), $rawfile('ic_keyboard_set_select.svg')],
    ['常用命令', $rawfile('ic_about_normal.svg'), $rawfile('ic_about_select.svg')],
    ['通用命令', $rawfile('ic_save_normal.svg'), $rawfile('ic_save_normal.svg')]
  ];
  private bottomMenu = [['退出', $rawfile('ic_quit_normal.svg'), $rawfile('ic_quit_normal.svg')]];
  private controller: TabsController = new TabsController();
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    RpcTool.getInstance().init(this);
    RpcTool.getInstance().bindDevice();
  }

  async aboutToDisappear() {
    hilog.info(0, 'testTag ui', `aboutToDisappear`);
    await RpcTool.getInstance().unbindDevice();
  }

  bindCallback(vendorId: string, productId: string, description: string) {
    hilog.info(0, 'testTag ui', `bindCallback vendorId: ${vendorId} productId:${productId}`);
    this.vendorId = vendorId;
    this.productId = productId;
    this.description = description;
    if (vendorId.length == 0 || productId.length == 0) {
      this.connectStatus = false;
    } else {
      this.connectStatus = true;
    }
  }

  updataDevParamsComponent(devParams: DevParams) {
    this.devParams.setValue(devParams);
    hilog.info(0, 'testTag ui', `updataDevParamsComponent vendorId: ${devParams.vendorId} productId:${devParams.productId}`);
  }

  updateSendCommandComponent(result: number, respData: string) {
    this.execResult = result.toString();
    this.dataOfSendCommandPage = respData;
    hilog.info(0, 'testTag ui', `updateSendCommandComponent dataOfIO: ${this.dataOfSendCommandPage}`);
  }

  updateComCommandComponent(result: number, respData: string) {
    this.execResultOfComCommandPage = result.toString();
    this.dataOfComCommandPage = respData;
    hilog.info(0, 'testTag ui', `updateComCommandComponent dataOfIO: ${this.dataOfComCommandPage}`);
  }

  getSaveMessage() {
    if(!this.vendorId || this.vendorId.length == 0) {
      console.log('===>00');
      return '当前设备未连接';
    } else {
      console.log('===>11');
      return `save config success`;

    }
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Row() {
            ForEach(this.topMenu, (item:string|Resource, index) => {
              Column() {
                Image((this.currentIndex == index) ? item[2] : item[1])
                  .width(IMAGE_WIDTH_HEIGHT)
                  .height(IMAGE_WIDTH_HEIGHT)
                Text(item[0])
                  .margin({ top: IMAGE_TEXT_INTERVAL })
              }
              .margin({ right: IMAGE_INTERVAL })
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.currentIndex = index;
              })
            })
          }
          .margin({ left: MARGIN_LEFT_RIGHT, bottom: MARGIN_TOP_BOTTOM })

          Row() {
            ForEach(this.bottomMenu, (item:(string|Resource)[], index) => {
              Column() {
                Image(item[1])
                  .width(IMAGE_WIDTH_HEIGHT)
                  .height(IMAGE_WIDTH_HEIGHT)
                Text(item[0])
                  .margin({ top: 10 })
              }
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                if (item[0] === '退出') {
                  this.context.terminateSelf();
                }
              })
            })
          }
          .margin({ right: MARGIN_LEFT_RIGHT, bottom: MARGIN_TOP_BOTTOM })
        }
        .width('100%')
        .margin({ top: MARGIN_TOP_BOTTOM })
        .border({ width: { bottom: 0.5 }, color: Color.Gray })
        .justifyContent(FlexAlign.SpaceBetween)

        Stack() {
          // 主内容区域
          Row() {
            Tabs({ controller: this.controller, index: this.currentIndex }) {
              TabContent() {
                DevParamsComponent({devParams: $devParams})
              }
              TabContent() {
                SendCommandComponent({dataOfSendCommandPage: $dataOfSendCommandPage, execResult: $execResult})
              }
              TabContent() {
                ComCommandComponent({
                  dataOfComCommandPage: $dataOfComCommandPage, 
                  execResultOfComCommandPage: $execResultOfComCommandPage
                })
              }
            }
            .barHeight(0)
            .height('100%')
            .scrollable(false)
          }
          .layoutWeight(1)
        }
        .alignContent(Alignment.TopStart)
        .layoutWeight(1)
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

      Text(this.connectStatus ? $r('app.string.device_connect') : $r('app.string.device_disconnect'))
        .fontColor(this.connectStatus ? Color.Black : Color.Red)
        .margin({ right: 30, bottom: 5 })
        .fontSize(14)
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.BottomEnd)
  }
}

export {Index}