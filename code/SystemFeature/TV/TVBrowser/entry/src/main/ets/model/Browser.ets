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
import Logger from './Logger';
import { webview } from '@kit.ArkWeb';
import { promptAction } from '@kit.ArkUI';

function customUUID(): string {
  const timestamp = Date.now().toString(16);
  const randomPart = Math.random().toString(16).substr(2, 8);
  return `${timestamp}-${randomPart}`;
}

@Observed
export class WebKey {
  public uuid: string;
  public webTitle: string;
  public url: ResourceStr;
  public controller: webview.WebviewController;
  public isRegister: boolean;

  constructor(uuid: string, webTitle: string, url: ResourceStr, controller: webview.WebviewController,
    isRegister: boolean) {
    this.uuid = uuid;
    this.webTitle = webTitle;
    this.url = url;
    this.controller = controller;
    this.isRegister = isRegister;
  }
}

// 加载状态
export enum LoadingStatus {
  LOADING,
  END
}

const TAG: string = '[browser]';
const HOME_FILE = $rawfile('pad.html');
export const HOME_TITLE = '主页';

export class Browser {
  private defaultUUID: string = customUUID();
  private defaultTab: WebKey =
    new WebKey(this.defaultUUID, HOME_TITLE, HOME_FILE, new webview.WebviewController(this.defaultUUID), false);
  public inputValue: string = '';
  public loadingStatus: LoadingStatus = LoadingStatus.LOADING;
  public currentTabIndex: number = 0;
  public progress: number = 0;
  public webArray: Array<WebKey> = [this.defaultTab];
  public tabsController: TabsController = new TabsController();

  // 删除页签
  deleteTabByClick(index: number) {
    const len = this.webArray.length;
    // 当前页签为1时，则不允许删除
    if (len === 1) {
      promptAction.showToast({ message: '唯一网页不可删除' });
      return
    }
    let currentTabIndex = this.currentTabIndex; // 记录当前tab的值
    this.currentTabIndex = -1; // 改变tabindex前先将tab值改变为-1，避免不触发界面刷新
    let curIndex: number;
    if (currentTabIndex === index) { //如果删除项为当前tab且index不为0则改变tab值
      curIndex = index === 0 ? 0 : currentTabIndex - 1;
    } else {
      curIndex = currentTabIndex > index ? currentTabIndex - 1 : currentTabIndex;
    }
    this.webArray.splice(index, 1); // 删除
    console.log('删除后的页签', JSON.stringify(this.webArray));
    this.setCurrentTabIndex(curIndex); // 切换页签
  }

  // 获取当前tab索引
  getCurrentTabIndex() {
    return this.currentTabIndex;
  }

  // 切换页签
  setCurrentTabIndex(index: number) {
    this.currentTabIndex = index;
    setTimeout(() => {
      this.tabsController.changeIndex(index);

      this.changeUrl();
    }, 50);
  }

  // 添加页签
  addTab() {
    if (this.webArray.length >= 7) {
      promptAction.showToast({ message: '页签数量已满' });
      return;
    }
    let uuid = customUUID();
    let webItem = new WebKey(uuid, HOME_TITLE, HOME_FILE, new webview.WebviewController(uuid), false);
    this.webArray.push(webItem);
    console.log('添加后的页签', JSON.stringify(this.webArray));
    // 切换到当前页签
    let len = this.webArray.length;
    this.setCurrentTabIndex(len - 1);
  }

  setInputVal(inputValue: string) {
    this.inputValue = inputValue;
  }

  async changeUrl() {
    try {
      let curWebController = await this.getCurrentWebController();
      let curUrl = curWebController.getUrl();
      this.setInputVal(curUrl.includes('pad.html') ? '' : this.cleanUrl(curUrl));
    } catch (error) {
      Logger.error(TAG, 'changeUrl err ' + JSON.stringify(error));
    }
  }

  /**
   * 验证网址格式
   * @param webObject
   */
  cleanUrl(url: string): string {
    // 移除协议部分并转换为小写
    return url.replace(/^(http:\/\/|https:\/\/)?/, '').toLowerCase();
  }


  // 获取当前webView controller
  getCurrentWebController() {
    return this.webArray?.[this.currentTabIndex]?.controller;
  }

  // 加载url
  loadUrl(addr: ResourceStr) {
    try {
      let curWebController = this.getCurrentWebController();
      this.webArray[this.currentTabIndex].url = addr;
      curWebController.loadUrl(addr);
    } catch (error) {
      Logger.error(TAG, 'loadUrl err ' + JSON.stringify(error));
    }
  }

  Back() {
    try {
      let curWebController = this.getCurrentWebController();
      if (curWebController?.accessBackward()) {
        curWebController.backward();
      }
    } catch (error) {
      Logger.error(TAG, 'Back err ' + JSON.stringify(error));
    }
  }

  Forward() {
    try {
      let curWebController = this.getCurrentWebController();
      if (curWebController?.accessForward()) {
        curWebController.forward();
      }
    } catch (error) {
      Logger.error(TAG, 'Forward err ' + JSON.stringify(error));
    }
  }

  Refresh() {
    try {
      let curWebController = this.getCurrentWebController();
      curWebController?.refresh();
    } catch (error) {
      Logger.error(TAG, 'Refresh err ' + JSON.stringify(error));
    }
  }
}
