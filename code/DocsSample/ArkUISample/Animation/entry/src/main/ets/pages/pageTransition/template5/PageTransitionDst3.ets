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
@Entry
@Component
struct PagePageTransition3 {
  build() {
    Column() {
      // $r('app.media.mountain')需要替换为开发着所需要的资源文件
      Image($r('app.media.mountain'))
        .width('90%')
        .height('80%')
        .objectFit(ImageFit.Fill)
        .syncLoad(true) // 同步加载图片，使页面出现时图片已经加载完成
        .margin(30)

      Row({ space: 10 }) {
        Button('pushUrl')
          .onClick(() => {
            // 路由到下一页面，push操作
            this.getUIContext().getRouter().pushUrl({ url: 'pages/pageTransition/template5/pageA' });
          })
        Button('back')
          .onClick(() => {
            // 返回到上一页面，相当于pop操作
            this.getUIContext().getRouter().back();
          })
      }.justifyContent(FlexAlign.Center)
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Center)
  }

  // [Start pageTransition_template5_pageB_start]
  // page B
  pageTransition() {
    // 定义页面进入时的效果，从右侧滑入，时长为1000ms，无论页面栈发生push还是pop操作均可生效
    PageTransitionEnter({ type: RouteType.None, duration: 1000 })
      .slide(SlideEffect.Right)
    // 定义页面退出时的效果，向右侧滑出，时长为1200ms，无论页面栈发生push还是pop操作均可生效
    PageTransitionExit({ type: RouteType.None, duration: 1200 })
      .slide(SlideEffect.Right)
  }
  // [End pageTransition_template5_pageB_start]
}
