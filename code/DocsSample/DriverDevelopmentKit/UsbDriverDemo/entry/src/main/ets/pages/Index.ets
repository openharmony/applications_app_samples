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

import { PensComponent } from '../components/PensComponent';
import { RegionComponent } from '../components/RegionComponent';
import { KeyPressComponent } from '../components/KeyPressComponent';
import { AboutComponent } from '../components/AboutComponent';
import { TestTsInterface } from '../components/TestTsInterface';
import { common } from '@kit.AbilityKit';
import RpcTool from '../tool/RpcTool'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { prompt } from '@kit.ArkUI';

const IMAGE_WIDTH_HEIGHT: number = 60; // 图片宽高
const IMAGE_INTERVAL: number = 30; // 图片与图片间距
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

  private topMenu = [
    //['笔设置', $rawfile('ic_pen_set_normal.svg'), $rawfile('ic_pen_set_select.svg')],
    ['按键设置', $rawfile('ic_keyboard_set_normal.svg'), $rawfile('ic_keyboard_set_select.svg')],
    ['区域设置', $rawfile('ic_locale_set_normal.svg'), $rawfile('ic_locale_set_select.svg')],
    ['关于', $rawfile('ic_about_normal.svg'), $rawfile('ic_about_select.svg')],
    ['保存', $rawfile('ic_save_normal.svg'), $rawfile('ic_save_normal.svg')],
    ['tokenID', $rawfile('ic_pen_set_normal.svg'), $rawfile('ic_pen_set_select.svg')],
  ];
  private bottomMenu = [['退出', $rawfile('ic_quit_normal.svg'), $rawfile('ic_quit_normal.svg')]];
  private controller: TabsController = new TabsController();
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    hilog.info(0, 'testTag ui', 'aboutToAppear enter');
    RpcTool.getInstance().init((vendorId: string, productId: string, description: string) => {
      this.bindCallback(vendorId, productId, description);
    })
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
            ForEach(this.topMenu, (item: string | Resource[], index) => {
              Column() {
                Image((this.currentIndex == index) ? item[2] : item[1])
                  .width(IMAGE_WIDTH_HEIGHT)
                  .height(IMAGE_WIDTH_HEIGHT)
                Text(item[0])
                  .margin({ top: IMAGE_TEXT_INTERVAL })
              }
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
            ForEach(this.bottomMenu, (item: string | Resource[], index) => {
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
          // 标题栏
          Row() {
            Text(this.topMenu[this.currentIndex][0])
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
          }
          .alignSelf(ItemAlign.Start)
          .width('100%')
          .padding({ left: 20, top: 10, bottom: 10 })

          // 主内容区域
          Row() {
            Tabs({ controller: this.controller, index: this.currentIndex }) {

              TabContent() {
                KeyPressComponent()
              }

              TabContent() {
                RegionComponent()
              }

              TabContent() {
                AboutComponent({ vendorId: $vendorId, productId: $productId, description: $description })
              }
              TabContent() {}
              TabContent() {
                TestTsInterface()
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