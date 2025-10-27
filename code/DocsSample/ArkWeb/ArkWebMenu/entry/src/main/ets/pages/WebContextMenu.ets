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
// [Start web_ContextMenu]
import { webview } from '@kit.ArkWeb';
import { pasteboard } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';

const TAG = '[Sample_ContextMenu]'
const DOMAIN = 0xF811
const BUNDLE = 'ContextMenu_'

//MenuItem width
const MENUITEM_WIDTH: number = 100;
//MenuItem height
const MENUITEM_HEIGHT: number = 50;
//MenuBuilder width
const MENUBUILDER_WIDTH: number = 150;
//MenuBuilder height
const MENUBUILDER_HEIGHT: number = 300;

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  private result: WebContextMenuResult | undefined = undefined;
  @State linkUrl: string = '';
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @State showMenu: boolean = false;
  uiContext: UIContext = this.getUIContext();

  @Builder
  // 构建自定义菜单及触发功能接口
  MenuBuilder() {
    // 以垂直列表形式显示的菜单。
    Menu() {
      // 展示菜单Menu中具体的item菜单项。
      MenuItem({
        content: $r('app.string.copy_image'),
      })
        .width(MENUITEM_WIDTH)
        .height(MENUITEM_HEIGHT)
        .onClick(() => {
          this.result?.copyImage();
          this.showMenu = false;
        })
      MenuItem({
        content: $r('app.string.cut'),
      })
        .width(MENUITEM_WIDTH)
        .height(MENUITEM_HEIGHT)
        .onClick(() => {
          this.result?.cut();
          this.showMenu = false;
        })
      MenuItem({
        content: $r('app.string.copy'),
      })
        .width(MENUITEM_WIDTH)
        .height(MENUITEM_HEIGHT)
        .onClick(() => {
          this.result?.copy();
          this.showMenu = false;
        })
      MenuItem({
        content: $r('app.string.paste'),
      })
        .width(MENUITEM_WIDTH)
        .height(MENUITEM_HEIGHT)
        .onClick(() => {
          this.result?.paste();
          this.showMenu = false;
        })
      MenuItem({
        content: $r('app.string.copy_url'),
      })
        .width(MENUITEM_WIDTH)
        .height(MENUITEM_HEIGHT)
        .onClick(() => {
          let pasteData = pasteboard.createData('text/plain', this.linkUrl);
          pasteboard.getSystemPasteboard().setData(pasteData, (error) => {
            if (error) {
              return;
            }
          })
          this.showMenu = false;
        })
      MenuItem({
        content: $r('app.string.all'),
      })
        .width(MENUITEM_WIDTH)
        .height(MENUITEM_HEIGHT)
        .onClick(() => {
          this.result?.selectAll();
          this.showMenu = false;
        })
    }
    .width(MENUBUILDER_WIDTH)
    .height(MENUBUILDER_HEIGHT)
  }

  build() {
    Column() {
      Web({ src: $rawfile('index1.html'), controller: this.controller })
      // 触发自定义弹窗
        .onContextMenuShow((event) => {
          if (event) {
            this.result = event.result
            hilog.info(DOMAIN, TAG, BUNDLE + 'x coord = ' + event.param.x());
            hilog.info(DOMAIN, TAG, BUNDLE + 'link url = ' + event.param.getLinkUrl());
            this.linkUrl = event.param.getLinkUrl();
          }
          hilog.info(DOMAIN, TAG, BUNDLE + `x: ${this.offsetX}, y: ${this.offsetY}`);
          this.showMenu = true;
          this.offsetX = 0;
          this.offsetY = Math.max(this.uiContext!.px2vp(event?.param.y() ?? 0) - 0, 0);
          return true;
        })
        .bindPopup(this.showMenu,
          {
            builder: this.MenuBuilder(),
            enableArrow: false,
            placement: Placement.LeftTop,
            offset: { x: this.offsetX, y: this.offsetY },
            mask: false,
            onStateChange: (e) => {
              if (!e.isVisible) {
                this.showMenu = false;
                this.result!.closeContextMenu();
              }
            }
          })
    }
  }
}
// [End web_ContextMenu]