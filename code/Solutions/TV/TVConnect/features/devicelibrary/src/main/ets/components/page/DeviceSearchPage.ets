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
import { DetailItemInfo, DeviceLibraryManager } from '../../viewmodel/DeviceLibraryManager';
import { HistoryRecordComponent } from '../search/HistoryRecordComponent';
import { SearchResultsComponent } from '../search/SearchResultsComponent';
import { HistoryRecordManager } from '../../viewmodel/HistoryRecordManager';
import { HMRouter } from '@hadss/hmrouter';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import inputEventClient from '@ohos.multimodalInput.inputEventClient';
import { inputMethod } from '@kit.IMEKit';
import { Logger } from '@ohos/common';

export function tabClick() {
  let keyDownOpt: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };
  let keyUpOpt: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };

  try {
    Logger.info('settingList inputEventClient', 'TAB');
    // 触发tab点击，使默认焦点组件多态样式生效
    inputEventClient.injectEvent({ KeyEvent: keyDownOpt });
    inputEventClient.injectEvent({ KeyEvent: keyUpOpt });
  } catch (err) {
    Logger.error('settingList inputEventClient' + err);
  }
}

@HMRouter({ pageUrl: 'DeviceSearchPage' })
@Component
export struct DeviceSearchPage {
  @Provide currentSearchField: string = '';
  @Provide searchResultList: DetailItemInfo[] = [];
  @Provide historyRecordManager: HistoryRecordManager = new HistoryRecordManager();
  private scrollerForScroll: Scroller = new Scroller();
  inputController: inputMethod.InputMethodController | null = inputMethod.getController();
  @State isPageShow: boolean = true;

  @Builder
  searchBox() {
    Row() {
      Search({ placeholder: $r('app.string.searching'), value: this.currentSearchField })
        .focusable(true)
        .fontColor($r('app.color.text_color_white'))
        .backgroundColor($r('app.color.default_search_bg'))
        .enableKeyboardOnFocus(true)
        .onChange((value: string) => {
          this.currentSearchField = value;
          if (this.currentSearchField.length != 0) {
            this.search();
          } else {
            this.searchResultList = [];
          }
        })
        .onSubmit(() => {
          this.addHistory();
        })
        .onKeyEvent((event: KeyEvent) => {
          if (event.type == KeyType.Down) {
            if (event.keyCode == KeyCode.KEYCODE_ENTER) {
              focusControl.requestFocus('ssss');
            }
            if (event.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
              tabClick();
            }
            if (event.keyCode == KeyCode.KEYCODE_DPAD_LEFT && event.type === KeyType.Up) {
              focusControl.requestFocus('back');
              event.stopPropagation();
            }
          }
        })
        .flexShrink(1)
        .id('search');
    }
    .key('ssss')
    .groupDefaultFocus(true)
    .defaultFocus(true)
    .onFocus(() => {
      if (this.isPageShow) {
        this.inputController?.hideTextInput();
        this.isPageShow = false;
      }
    })
    .width('100%')
    .height($r('app.string.page_toolbar_height'))
    .padding({
      left: $r('app.string.20_vp'),
      right: $r('app.string.20_vp')
    })
    .alignItems(VerticalAlign.Center)
    .margin({ bottom: 20 });
  }

  aboutToAppear(): void {
    this.historyRecordManager.queryHistoryRecord();
    this.inputController = inputMethod.getController();
  }

  private search() {
    this.searchResultList = DeviceLibraryManager.getInstance().searchListByNameFullField(this.currentSearchField);
  }

  addHistory() {
    this.historyRecordManager.addHistoryRecord(this.currentSearchField);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        this.searchBox();
        Scroll(this.scrollerForScroll) {
          Column() {
            HistoryRecordComponent()
              .key('history');
            SearchResultsComponent();
          };
        }.edgeEffect(EdgeEffect.Spring)
        .align(Alignment.Top)
        .width('100%')
        .height('100%');
      }
      .width('70%');
    }
    .width('100%')
    .height('100%')
    .padding({ top: $r('app.string.default_page_padding'), bottom: 60 })
    .backgroundColor($r('app.color.page_background'));
  }
}