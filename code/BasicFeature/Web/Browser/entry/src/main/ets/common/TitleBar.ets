/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { Browser, LoadingStatus, WebObject } from '../model/Browser';
import Logger from '../model/Logger';
import webview from '@ohos.web.webview';

const TAG: string = '[TitleBar]';
const BUTTON_WIDTH: number = 22;
const BUTTON_RADIUS: number = 4;
const DOWN_COLOR: string = '#e4e4e4';
const UP_COLOR: string = '#00000000';
// 此处可按照需求到浏览器请求里获取（浏览器请求的HEAD部分，字段为USER_AGENT）
const PAD_USER_AGENT: string = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/92.0.4515.105 Safari/537.36';
const PHONE_USER_AGENT: string = 'HuaweiBrowser/12.0.4.1';

@Component
export struct TabletTitle {
  @Link browser: Browser;
  @State inputValue: string = '';
  @State arrayIndex: number = 0;
  private addr: string = '';
  private navigationButton: Array<{
    imageSrc: Resource,
    id: number
  }> = [
    {
      imageSrc: $r('app.media.ic_public_back'),
      id: 1
    },
    {
      imageSrc: $r('app.media.ic_public_advance'),
      id: 2
    },
    {
      imageSrc: $r('app.media.ic_public_refresh'),
      id: 3
    },
    {
      imageSrc: $r('app.media.ic_public_home'),
      id: 4
    },
  ]
  private actionButton: Array<{
    imageSrc: Resource,
    id: number
  }> = [
    {
      imageSrc: $r('app.media.submit'),
      id: 5
    },
    {
      imageSrc: $r('app.media.ic_public_add'),
      id: 6
    },
  ]

  build() {
    Row() {
      ForEach(this.navigationButton, (item, index) => {
        Button({ type: ButtonType.Normal }) {
          Image(item.imageSrc)
        }
        .margin(8)
        .id(`navigationButton${index}`)
        .width(BUTTON_WIDTH)
        .height(BUTTON_WIDTH)
        .backgroundColor(this.arrayIndex === item.id ? DOWN_COLOR : UP_COLOR)
        .borderRadius(BUTTON_RADIUS)
        .flexShrink(0)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.arrayIndex = item.id;
          }

          if (event.type === TouchType.Up) {
            this.arrayIndex = 0;
          }
        })
        .onClick((event: ClickEvent) => {
          switch (item.id) {
            case 1:
              this.browser.Back();
              break;
            case 2:
              this.browser.Forward();
              break;
            case 3:
              this.browser.Refresh();
              break;
            case 4:
              this.browser.webControllerArray[this.browser.tabArrayIndex]?.controller
                .loadUrl($rawfile('pad.html'));
              break;
          }
        })
      }, item => item.id)

      TextInput({ placeholder: '输入网址...', text: this.browser.inputValue })
        .placeholderFont({ size: 18, weight: 500 })
        .fontSize(18)
        .margin(2)
        .id('inputUrl')
        .width('51%')
        .layoutWeight(1)
        .onChange((value: string) => {
          this.addr = value;
        })
        .onSubmit((enterKey: EnterKeyType) => {
          Logger.info(TAG, `onSubmit`)
          if (this.addr.length !== 0) {
            this.browser.webControllerArray[this.browser.tabArrayIndex]?.controller
              .loadUrl(`https://${this.addr}`);
            this.addr = '';
          }
        })

      ForEach(this.actionButton, (item, index) => {
        Button({ type: ButtonType.Normal }) {
          Image(item.imageSrc)
        }
        .margin(8)
        .id(`actionButton${index}`)
        .width(BUTTON_WIDTH)
        .height(BUTTON_WIDTH)
        .backgroundColor(this.arrayIndex === item.id ? DOWN_COLOR : UP_COLOR)
        .borderRadius(BUTTON_RADIUS)
        .flexShrink(0)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.arrayIndex = item.id;
          }
          if (event.type === TouchType.Up) {
            this.arrayIndex = 0;
          }
        })
        .onClick((event: ClickEvent) => {
          if (item.id === 5) {
            this.browser.loadUrl(this.addr);
            this.addr = '';
          } else if (item.id === 6) {
            Logger.info(TAG, `add tab index = ` + this.arrayIndex);
            this.browser.addTab();
          }
        })
      }, item => item.id)
    }
    .width('100%')
    .padding({ right: 5 })
  }
}

@Component
export struct BrowserTabs {
  @Link browser: Browser;
  @State tabButtonIndex: number = -1;

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
      ForEach(this.browser.webArray, item => {
        Row() {
          Row() {
            Text('主页')
          }.width('100%').flexShrink(1).justifyContent(FlexAlign.Center).height('100%')

          Button({ type: ButtonType.Normal }) {
            Image($r('app.media.ic_public_cancel_filled')).width(24).height(24)
          }
          .backgroundColor(this.tabButtonIndex == item.key ? DOWN_COLOR : '#00000000')
          .id('cancelBtn')
          .margin({ right: 2 })
          .width(33)
          .height(33)
          .borderRadius(5)
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.tabButtonIndex = item.key;
            } else if (event.type == TouchType.Up) {
              this.tabButtonIndex = -1;
            }
          })
          .onClick((event: ClickEvent) => {
            if (this.browser.webArray.length > 1) {
              this.browser.deleteTab(item.key);
            }
          })
        }.width(180).height('100%').backgroundColor(this.browser.tabArrayIndex == item.key ? '#ffffff' : '#ececec')
        .onClick((event: ClickEvent) => {
          Logger.info(TAG, `key= ${item.key}`);
          this.browser.setTabArrayIndex(item.key);
          this.browser.tabsController.changeIndex(item.key);
        })

        Divider().vertical(true).color('#c6c6c6');
      }, item => item.timestamp.toString())
    }.height(33).flexShrink(0).backgroundColor('#ececec');
  }
}

@Component
export struct WebTab {
  @Link browser: Browser;
  @Link isPhone: boolean;
  @State userAgent: string = '';
  isRegistered: boolean = false;
  testObj = {
    test: (addr) => {
      Logger.info(TAG, `addr= ${this.browser.tabArrayIndex}`);
      this.browser.webControllerArray[this.browser.tabArrayIndex]?.controller.loadUrl(`https://${addr}`);
    },
    searchWord: (word: string) => {
      Logger.info(`search word= ${word}`);
      let code = encodeURI(word);
      this.browser.webControllerArray[this.browser.tabArrayIndex]?.controller
        .loadUrl(`https://www.bing.com/search?q=${code}`);
    }
  }

  aboutToAppear() {
    webview.once('webInited', () => {
      try {
        this.userAgent = this.browser.webControllerArray[this.browser.tabArrayIndex]?.controller.getUserAgent();
        Logger.info(`getUserAgent successed, detail: ${this.userAgent}`);
      } catch (error) {
        Logger.error(`getUserAgent failed, error info: ${this.userAgent}`);
      }
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.Start, controller: this.browser.tabsController }) {
      ForEach(this.browser.webArray, item => {
        TabContent() {
          Web({
            src: this.isPhone ? $rawfile('phone.html') : $rawfile('pad.html'),
            controller: this.browser?.webControllerArray[item.key]?.controller
          })
            .javaScriptAccess(true)
            .fileAccess(true)
            .domStorageAccess(true)
            .userAgent(this.userAgent)
            .mixedMode(MixedMode.All)
            .multiWindowAccess(true)
            .onWindowNew((event) => {
              Logger.info(TAG, `onWindowNew targetUrl: ` + event.targetUrl);
              if (event.targetUrl !== 'about:blank' && event.targetUrl !== '') {
                this.browser?.webControllerArray[item.key]?.controller.loadUrl(event.targetUrl);
              }
              event.handler.setWebController(null);
            })
            .onPageBegin((event) => {
              Logger.info(TAG, `onPageBegin= ${JSON.stringify(event)}`)
              if (event.url.startsWith('http')) {
                this.browser.inputValue = event.url;
              } else {
                this.browser.inputValue = '';
              }
              this.browser.loadingStatus = LoadingStatus.LOADING;
            })
            .onPageEnd((event) => {
              Logger.info(TAG, `onPageEnd= ${JSON.stringify(event)}`)
              if (item.key < this.browser.webControllerArray.length && this.browser.webControllerArray[item.key]?.controller) {
                this.browser.webControllerArray[item.key]?.controller?.runJavaScript('adapterDevice()');
                this.browser.loadingStatus = LoadingStatus.END;
                this.registerFunc(this.browser.webControllerArray[item.key]);
              }
            })
            .onProgressChange((event) => {
              Logger.info(TAG, `onProgressChange`);
              this.browser.progress = event.newProgress;
              if (!this.browser.inputValue) {
                if (event.newProgress !== 10) {
                  this.browser.progress = event.newProgress;
                }
              } else {
                this.browser.progress = event.newProgress;
              }
              if (this.browser.progress === 100) {
                this.browser.hideProgress = true;
                this.browser.progress = 0;
              } else {
                this.browser.hideProgress = false;
              }
            })
        }
      }, item => item.timestamp.toString())
    }
    .barHeight(0)
    .scrollable(false)
  }

  registerFunc(webObject: WebObject) {
    if (!webObject.isRegistered) {
      Logger.info(TAG, `registerFunc`);
      webObject.controller.registerJavaScriptProxy(this.testObj, 'etsObj', ['test', 'searchWord']);
      webObject.isRegistered = true;
      webObject.controller.refresh();
    }
  }
}