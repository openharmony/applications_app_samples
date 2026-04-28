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

import { Browser, WebKey, HOME_TITLE } from '../model';
import Logger from '../model/Logger';
import { ImageSrc } from '../model/ImageSrc';
import { promptAction } from '@kit.ArkUI';

const TAG: string = '[TitleBar]';
const BUTTON_WIDTH: number = 22;
const BUTTON_RADIUS: number = 4;
const DOWN_COLOR: string = '#e4e4e4';
const UP_COLOR: string = '#00000000';
// 此处可按照需求到浏览器请求里获取（浏览器请求的HEAD部分，字段为USER_AGENT）
const PAD_USER_AGENT: string =
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/92.0.4515.105 Safari/537.36';
const PHONE_USER_AGENT: string = 'HuaweiBrowser/12.0.4.1';


@Component
export struct TabletTitle {
  @Link browser: Browser;
  @State private arrayIndex: number = 0;
  @Link inputKey: string;
  private navigationButton: Array<ImageSrc> = [
    {
      image: $r('app.media.ic_back_onblur'),
      id: 1
    },
    {
      image: $r('app.media.ic_advance_onblur'),
      id: 2
    },
    {
      image: $r('app.media.ic_refresh_onblur'),
      id: 3
    },
    {
      image: $r('app.media.ic_home_onblur'),
      id: 4
    },
  ];
  private actionButton: Array<ImageSrc> = [
    {
      image: $r('app.media.ic_submit_onblur'),
      id: 5
    },
    {
      image: $r('app.media.ic_add_onblur'),
      id: 6
    },
  ];

  build() {
    Row() {
      ForEach(this.navigationButton, (item: ImageSrc, index:number) => {
        Button({ type: ButtonType.Normal }) {
          Image(item.image)
            .focusable(true)
        }
        .height('60lpx')
        .aspectRatio(1)
        .margin('10lpx')
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
              this.browser.loadUrl($rawfile('pad.html'));
              this.browser.webArray[this.browser.currentTabIndex].webTitle = HOME_TITLE;
              break;
          }
        })
        .key(item.id.toString())
      }, (item: ImageSrc, index: number) => {
        return item.id.toString();
      })

      TextInput({ placeholder: '输入网址...', text: this.browser.inputValue })
        .backgroundColor('#ECECEE')
        .fontColor(Color.Black)
        .placeholderFont({ size: '35lpx', weight: '500lpx' })
        .fontSize('35lpx')
        .margin('2lpx')
        .margin({ top: '2lpx', bottom: '2lpx', left: '12lpx', right: '12lpx' })
        .id('inputUrl')
        .width('50%')
        .layoutWeight(1)
        .key(this.inputKey)
        .enableKeyboardOnFocus(true)
        .defaultFocus(true)
        .onChange((value: string) => {
          this.browser.setInputVal(value);
        })

      ForEach(this.actionButton, (item: ImageSrc, index) => {
        Button({ type: ButtonType.Normal }) {
          Image(item.image)
            .focusable(true)
        }
        .height('60lpx')
        .aspectRatio(1)
        .margin('10lpx')
        .id(`actionButton${index}`)
        .backgroundColor(this.arrayIndex === item.id ? DOWN_COLOR : UP_COLOR)
        .borderRadius('4lpx')
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
            let curUrl = this.browser.inputValue;
            if (curUrl === '') {
              promptAction.showToast({ message: '网址不能为空' });
            } else {
              let exp: RegExp = /^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/\S*)?$/;
              if (exp.test(curUrl)) {
                this.browser.loadUrl(curUrl);
              } else {
                promptAction.showToast({ message: '网址格式错误' });
              }
            }
          } else if (item.id === 6) {
            this.browser.addTab();
          }
        })
      }, (item: ImageSrc, index: number) => {
        return item.id.toString();
      })
    }
    .width('100%')
    .padding({ bottom: '10lpx', top: '10lpx' })
  }
}

@Component
export struct BrowserTabs {
  @Link browser: Browser;
  @State tabButtonIndex: number = -1;
  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      ForEach(this.browser.webArray, (item: WebKey, index: number) => {
        Row() {
          Row() {
            Text(item.webTitle)
              .fontSize('25lpx')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: '5lpx', right: '5lpx' })
          }
          .width('95%')
          .height('95%')
          .flexShrink(1)
          .justifyContent(FlexAlign.Center)

          if (this.browser.webArray?.length > 1) {
            Button({ type: ButtonType.Normal }) {
              Image($r('app.media.ic_delete_onfocus'))
                .focusable(true)
            }
            .backgroundColor(this.browser.getCurrentTabIndex() === index ? DOWN_COLOR : '#00000000')
            .id('cancelBtn')
            .margin({ right: '10lpx' })
            .height('40lpx')
            .aspectRatio(1)
            .onClick((event: ClickEvent) => {
              this.browser.deleteTabByClick(index);

            })
          }
        }
        .borderRadius('15lpx')
        .margin({ left: '5lpx' })
        .width('300lpx')
        .height('80%')
        .backgroundColor(this.browser.getCurrentTabIndex() === index ? '#ffffff' : '#ececec')
        .onClick((event: ClickEvent) => {
          this.browser.setCurrentTabIndex(index);
        })
      })
    }
    .width('100%')
    .height('65lpx')
    .padding({ left: '1px', right: '1px' })
    .flexShrink(0)
    .backgroundColor('#F0F0F4');
  }
}

@Component
export struct WebTab {
  @Link browser: Browser;
  @Link isPhone: boolean;
  @Prop inputKey: string;

  build() {
    Tabs({ barPosition: BarPosition.Start, controller: this.browser.tabsController }) {
      ForEach(this.browser?.webArray, (item: WebKey, index: number) => {
        TabContent() {
          Web({
            src: item.url,
            controller: item.controller
          })
            .onTitleReceive((event) => {
              if (!event) {
                return
              }
              item.webTitle = event.title === 'pad.html' ? HOME_TITLE : event.title;
              this.browser.changeUrl();
            })
            .onBeforeUnload(() => {
              item.isRegister = false;
              return true
            })
            .focusable(true)
            .javaScriptAccess(true)
            .fileAccess(true)
            .domStorageAccess(true)
            .onControllerAttached(() => {
              try {
                this.browser.getCurrentWebController()?.setCustomUserAgent(PAD_USER_AGENT);
                item?.controller?.runJavaScript('adapterDevice()');
                this.registerFunc(item);
              } catch (error) {
                Logger.error(TAG, JSON.stringify(error));
              }
            })
            .onPageEnd(() => {
              focusControl.requestFocus(this.inputKey);
            })
            .onErrorReceive((event) => {
              if (event.error.getErrorInfo() === 'ERR_INTERNET_DISCONNECTED') {
                this.browser.loadUrl($rawfile('error.html'));
              }
            })
            .onProgressChange((event: OnProgressChangeEvent) => {
              if (event) {
                this.browser.progress = event.newProgress;
              }
            })
        }
      }, (item: WebKey, index: number) => {
        return item.uuid
      })
    }
    .barHeight(0)
    .scrollable(false)
  }

  /**
   * 对网址进行截取
   * @param url
   * @returns
   */
  interceptUrl(url: string): string {
    let regexp: RegExp = new RegExp('^(?:https?:\\/\\/)?(?:www\\.)?([^\\/]+).*');
    const match = url.match(regexp);
    if (match && match[1]) {
      return match[1];
    }
    return url;
  }

  registerFunc(webObject: WebKey) {
    if (typeof webObject.url !== 'string' && !webObject.isRegister) {
      webObject.controller.registerJavaScriptProxy(
        {
          test: (addr: string) => {
            this.browser.loadUrl(`https://${addr}`);
          },
          searchWord: (word: string) => {
            let code = encodeURI(word);
            this.browser.loadUrl(`https://www.bing.com/search?q=${code}`);
          },
        }
        , 'etsObj', ['test', 'searchWord']
      );

      webObject.isRegister = true;
    }
  }
}
