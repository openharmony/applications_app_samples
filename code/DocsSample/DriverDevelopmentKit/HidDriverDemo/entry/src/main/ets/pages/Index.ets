/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { InputComponent } from '../components/InputComponent';
import { AttributesComponent } from '../components/AttributesComponent';
import { common } from '@kit.AbilityKit';
import RpcTool from '../tool/RpcTool';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { prompt } from '@kit.ArkUI';
import { OutputComponent } from '../components/OutputComponent';
import { InputParams } from '../utils/Params';
import { RequestCode } from '../utils/RequestCode';
import { FeatureComponent } from '../components/FeatureComponent';

const IMAGE_WIDTH_HEIGHT: number = 60; // 图片宽高
const IMAGE_INTERVAL: number = 20; // 图片与图片间距
const IMAGE_TEXT_INTERVAL: number = 10; // 图片和文本间距
const MARGIN_LEFT_RIGHT: number = 20; // 顶部菜单栏与屏幕边缘间隔
const MARGIN_TOP_BOTTOM: number = 20; // 菜单栏上下间距

@Preview
@Entry
@Component
struct Index {
  @State vendorId: string = '';
  @State productId: string = '';
  @State description: string = '';
  @State currentIndex: number = 0;
  @State connectStatus: boolean = false;
  saveMessage : string = `save config success`;

  // 输入页面
  @State inputParams: InputParams = new InputParams();

  // 特性页面
  @State featureData: string = '';

  // 关于页面
  @State rawName: string = '';
  @State rawUniqueId: string = '';
  @State physicalAddress: string = '';
  @State rawInfo: string = '';
  @State descriptor: string = '';

  private topMenu = [
    ['输入', $rawfile('ic_keyboard_set_normal.svg'), $rawfile('ic_keyboard_set_select.svg')],
    ['输出', $rawfile('ic_locale_set_normal.svg'), $rawfile('ic_locale_set_select.svg')],
    ['特性', $rawfile('ic_locale_set_normal.svg'), $rawfile('ic_locale_set_select.svg')],
    ['关于', $rawfile('ic_about_normal.svg'), $rawfile('ic_about_select.svg')]
  ];
  private bottomMenu = [['退出', $rawfile('ic_quit_normal.svg'), $rawfile('ic_quit_normal.svg')]];
  private controller: TabsController = new TabsController();
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    RpcTool.getInstance().init(this);
    RpcTool.getInstance().bindDevice();
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

  updateInputPage(inputParams: InputParams) {
    this.inputParams.setValue(inputParams);
  }

  updateAttributePage(requestType: RequestCode, data: string) {
    switch (requestType) {
      case RequestCode.GetRawName:
        this.rawName = data;
        break;
      case RequestCode.GetRawUniqueId:
        this.rawUniqueId = data;
        break;
      case RequestCode.GetPhysicalAddr:
        this.physicalAddress = data;
        break;
      case RequestCode.GetRawInfo:
        this.rawInfo = data;
        break;
      case RequestCode.GetDescriptor:
        this.descriptor = data;
        break;
      default:
        break;
    }
  }

  updateFeaturePage(data: string) {
    this.featureData = data;
  }

  getSaveMessage() {
    if(!this.vendorId || this.vendorId.length == 0) {
      return '当前设备未连接';
    } else {
      return `save config success`;
    }
  }

  build() {
    Stack() {
      Column() {
        // 侧边栏
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
                if (item[0] == '保存') {
                  prompt.showToast({ message: this.getSaveMessage(), bottom: 100, duration: 1800 });
                } else {
                  this.currentIndex = index;
                }
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
                  RpcTool.getInstance().unbind();
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
                InputComponent({inputParams: $inputParams});
              }

              TabContent() {
                OutputComponent();
              }

              TabContent() {
                FeatureComponent({featureData: $featureData});
              }

              TabContent() {
                AttributesComponent({rawName: $rawName, rawUniqueId: $rawUniqueId, physicalAddress: $physicalAddress, rawInfo: $rawInfo, descriptor: $descriptor});
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
        .margin({ right: 30, bottom: 20 })
        .fontSize(14)
    }.width('100%')
    .height('100%')
    .alignContent(Alignment.BottomEnd)
  }
}

export {Index}