'use static'
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
// [Start web_PreviewBuilder]
import webview from '@ohos.web.webview';
import { Entry, Text, Column, Component, Web, Image, Resource, Menu, ImageFit, Stack,
  WebContextMenuResult, Progress, UIContext, TextOverflow, MenuItem, TextAlign, CopyOptions,
  Alignment, SelectionMenuOptionsExt, ProgressType, HitTestMode, LinearStyleOptions, ProgressOptions,
  $rawfile, WebResponseType, WebElementType, MenuType, Color } from '@ohos.arkui.component';
import { State } from '@ohos.arkui.stateManagement';
import pasteboard from '@ohos.pasteboard';

interface PreviewBuilderParam {
  width: number;
  height: number;
  url: string | Resource;
}

interface PreviewBuilderParamForImage {
  previewImage: Resource | string | undefined;
  width: number;
  height: number;
}


@Builder function previewBuilderGlobalForImage($$: PreviewBuilderParamForImage) {
  Column() {
    Image($$.previewImage)
      .objectFit(ImageFit.Fill)
      .autoResize(true)
  }.width($$.width).height($$.height)
}

@Entry
@Component
struct SelectionMenuLongPress {
  controller: webview.WebviewController = new webview.WebviewController(undefined);
  previewController: webview.WebviewController = new webview.WebviewController(undefined);

  private result: WebContextMenuResult | undefined = undefined;
  @State previewImage: Resource | string | undefined = undefined;
  @State previewWidth: number = 1;
  @State previewHeight: number = 1;
  @State previewWidthImage: number = 1;
  @State previewHeightImage: number = 1;
  @State linkURL: string = '';
  @State progressValue: number = 0;
  @State progressVisible: boolean = true;
  uiContext: UIContext = this.getUIContext();

  @Builder
  LinkPreviewWrapper() {
    Column() {
      Stack() {
        Text(this.linkURL) // 可选择是否展示url
          .padding(5)
          .width('100%')
          .textAlign(TextAlign.Start)
          .backgroundColor(Color.White)
          .copyOption(CopyOptions.LocalDevice)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Progress({ value: this.progressValue, total: 100, type: ProgressType.Linear } as ProgressOptions) // 展示进度条
          .style({ strokeWidth: 3, enableSmoothEffect: true } as LinearStyleOptions)
          .backgroundColor(Color.White)
          .opacity(this.progressVisible ? 1 : 0)
          .backgroundColor(Color.White)
      }.alignContent(Alignment.Bottom)
      Web({ src: this.linkURL, controller: this.previewController })
        .javaScriptAccess(true)
        .fileAccess(true)
        .onlineImageAccess(true)
        .imageAccess(true)
        .domStorageAccess(true)
        .onPageBegin(() => {
          this.progressValue = 0;
          this.progressVisible = true;
        })
        .onProgressChange((event) => {
          this.progressValue = event.newProgress;
        })
        .onPageEnd(() => {
          this.progressVisible = false;
        })
        .hitTestBehavior(HitTestMode.None) // 使预览Web不响应手势
    }.width(500).height(400) // 设置预览宽高
  }

  @Builder
  ImagePreviewWrapper() {
    previewBuilderGlobalForImage({
      previewImage: this.previewImage,
      width: this.previewWidthImage,
      height: this.previewHeightImage,
    })
  }

  @Builder
  LinkMenuBuilder() {
    Menu() {
      MenuItem({ content: 'Copy link', })
        .onClick(() => {
          const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.linkURL);
          const systemPasteboard = pasteboard.getSystemPasteboard();
          systemPasteboard.setData(pasteboardData);
        })
      MenuItem({ content: 'Open the link' })
        .onClick(() => {
          this.controller.loadUrl(this.linkURL);
        })
    }
  }
  @Builder
  ImageMenuBuilder() {
    Menu() {
      MenuItem({ content: 'Copy Image' })
        .onClick(() => {
          this.result?.copyImage();
          this.result?.closeContextMenu();
        })
    }
  }

  build() {
    Column() {
      Web({ src: $rawfile('index3.html'), controller: this.controller })
        .javaScriptAccess(true)
        .fileAccess(true)
        .onlineImageAccess(true)
        .imageAccess(true)
        .domStorageAccess(true)
        .bindSelectionMenu(WebElementType.LINK, this.LinkMenuBuilder, WebResponseType.LONG_PRESS,
          {
            onAppear: () => {},
            onDisappear: () => {
              this.result?.closeContextMenu();
            },
            preview: this.LinkPreviewWrapper,
            menuType: MenuType.PREVIEW_MENU,
          } as SelectionMenuOptionsExt)
        .bindSelectionMenu(WebElementType.IMAGE, this.ImageMenuBuilder, WebResponseType.LONG_PRESS,
          {
            onAppear: () => {},
            onDisappear: () => {
              this.result?.closeContextMenu();
            },
            preview: this.ImagePreviewWrapper,
            menuType: MenuType.PREVIEW_MENU,
          } as SelectionMenuOptionsExt)
        .zoomAccess(true)
        .onContextMenuShow((event) => {
          if (event) {
            this.result = event.result;
            this.previewWidthImage = this.uiContext!.px2vp(event.param.getPreviewWidth());
            this.previewHeightImage = this.uiContext!.px2vp(event.param.getPreviewHeight());
            if (event.param.getSourceUrl().indexOf('resource://rawfile/') == 0) {
              this.previewImage = $rawfile(event.param.getSourceUrl().substring(19));
            } else {
              this.previewImage = event.param.getSourceUrl();
            }
            this.linkURL = event.param.getLinkUrl();
            return true;
          }
          return false;
        })
    }
  }

  onBackPress(): boolean {
    if (this.controller.accessStep(-1)) {
      this.controller.backward();
      return true;
    } else {
      return false;
    }
  }
}
// [End web_PreviewBuilder]