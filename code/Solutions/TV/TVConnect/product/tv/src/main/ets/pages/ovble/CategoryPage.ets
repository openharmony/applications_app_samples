/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import eventManager from '@ohos.commonEventManager';
import { CommonConstants } from '../../common/constants/CommonConstants';
import { TabItem } from '../../common/bean/TabItem';
import TabsConfig from '../../common/constants/TabsConfig';
import { Logger, LoginEvent, PageViewUtils, UserDataEvent } from '@ohos/common';
import { DeviceManagerFactory } from '@ohos/device_manager';
import common from '@ohos.app.ability.common';
import { MqttEngine } from '@ohos/connect_cloud';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { display, LengthMetrics } from '@kit.ArkUI';
import { scale } from '../../common/utils/ScreenAdaptation';

/**
 * This module template implements Category functions.
 * The left and right sides of the page are linked. Click the left option and
 * the right list will slide to the specified position, and vice versa.
 * Developers can add corresponding data as needed after creating a template.
 */

const num2 = 2;

const num10 = 10;

const num60 = 60;

const num100 = 100;

const num255 = 255;

@HMRouter({ pageUrl: 'CategoryPage', singleton: true, lifecycle: 'CategoryPageLifecycle' })
@Component
export struct CategoryPage {
  @State categoryTabIndex: number = 0;
  @StorageLink('currentBreakpoint') currentBreakpoint: string = CommonConstants.BREAK_POINT_SM;
  @State scrollerIndex: number = 1;
  scroller?: Scroller;
  private subscriber: eventManager.CommonEventSubscriber | undefined = undefined;
  tabController: TabsController = new TabsController();

  aboutToAppear(): void {
    this.registerLoginEvent();
    LoginEvent.appSetLoginState();
    UserDataEvent.UserDataIsChangeState();
    DeviceManagerFactory.getDeviceManager().bindLifeSvc(getContext(this) as common.UIAbilityContext);
    MqttEngine.connect();
    this.getUIContext().getFocusController().activate(true);
  }

  private registerLoginEvent() {
    let info: eventManager.CommonEventSubscribeInfo = {
      events: [LoginEvent.LOGIN_EVENT]
    };
    eventManager.createSubscriber(info).then((subscriber) => {
      this.subscriber = subscriber;
      eventManager.subscribe(this.subscriber, (error, eventData) => {
        Logger.error('CategoryPage', `app login event ${eventData.data}`);
        if (eventData.data == LoginEvent.APP_LOGIN) {
          MqttEngine.connect();
        } else if (eventData.data == LoginEvent.APP_OUT_LOGIN) {
          MqttEngine.disConnect();
        }
      });
    });
  }

  aboutToDisappear(): void {
    MqttEngine.disConnect();
    if (this.subscriber != undefined) {
      eventManager.unsubscribe(this.subscriber);
      this.subscriber = undefined;
    }
  }

  @State isFocused: number = 0; // 状态变量，表示按钮是否获焦
  private albumGridRowCount = 4;
  @State focusIndex: number = 0;
  @State imageWidth: number = (display.getDefaultDisplaySync().width - scale(152) - scale(60)) / this.albumGridRowCount;

  build() {
    Column() {
      Row() {
        Text($r('app.string.ability_label'))
          .fontFamily('HarmonyOS Sans')
          .fontColor(Color.White)
          .fontSize(scale(px2vp(64)));
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: scale(px2vp(76)),
        right: scale(px2vp(76)),
        top: scale(px2vp(48)),
        bottom: scale(px2vp(48)),
      });

      Grid() {
        ForEach(TabsConfig.tabItems, (item: TabItem, index: number) => {
          GridItem() {
            Column() {
              Stack() {
                Image(this.focusIndex === index ? item.imageActivated : item.imageOriginal)
                  .width('100%')
                  .height('100%')
                  .objectFit(ImageFit.CENTER)
                  .backgroundColor(this.focusIndex === index ? $r('app.color.menu_focus_color') :
                  $r('app.color.menu_normal_color'))
                  .focusable(true)
                  .defaultFocus(index === 0)
                  .focusBox({
                    strokeWidth: LengthMetrics.px(0)
                  })
                  .focusOnTouch(true)
                  .onFocus(() => {
                    this.focusIndex = index;
                  })
                  .borderRadius(scale(px2vp(24)))
                  .onHover(() => {
                    this.focusIndex = index;
                  })
                  .onClick(() => {
                    if (index === 0) {
                      HMRouterMgr.push({ pageUrl: 'DevicesMainPage' });
                    } else if (index === 1) {
                      HMRouterMgr.push({ pageUrl: 'MinePage' });
                    }
                  });
              }
              .width(px2vp(this.imageWidth))
              .height(px2vp(this.imageWidth))
              .padding(scale(px2vp(8)))
              .border({
                width: (scale(px2vp(2))),
                color: this.focusIndex === index ? Color.White : Color.Transparent,
                style: BorderStyle.Solid
              })
              .borderRadius(scale(px2vp(26)));

              Text(item.title)
                .width(CommonConstants.FULL_WIDTH_PERCENT)
                .fontSize(scale(px2vp(36)))
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
                .margin({
                  top: scale(px2vp(40))
                });
            };
          }
          .stateStyles({
            normal: {
              .borderColor(Color.Transparent)
              .backgroundColor(Color.Transparent);
            },
            focused: {
              .borderColor(Color.Transparent);
            }
          })
          .backgroundImageSize({ width: '100%', height: '100%' });
        }, (item: TabItem) => `${item.index}`);
      }
      .columnsTemplate('1fr '.repeat(this.albumGridRowCount))
      .columnsGap(scale(px2vp(20)))
      .padding({ left: scale(px2vp(76)), right: scale(px2vp(76)) })
      .height('80%')
      .width('100%');
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.home_back'))
    .backgroundImageSize(ImageSize.FILL)
    .backgroundColor($r('app.color.page_background'));
  }
}