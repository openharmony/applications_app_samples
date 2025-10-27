/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { NodeContent,UIContext } from '@kit.ArkUI';
import entry from 'libentry.so';

@Component
struct CAPIComponent {
  private rootSlot = new NodeContent();

  aboutToAppear(): void {
    // 页面显示前多线程创建Native组件。
    entry.createNodeTreeOnMultiThread(this.rootSlot, this.getUIContext());
  }

  aboutToDisappear(): void {
    // 页面销毁前释放已创建的Native组件。
    entry.disposeNodeTreeOnMultiThread(this.rootSlot);
  }

  build() {
    Column() {
      // Native组件挂载点。
      ContentSlot(this.rootSlot);
    }
  }
}

@Entry
@Component
struct Index {

  @State isShow: boolean = false;
  @State message: string = 'CreateNodeTree';

  build() {
    Flex() {
      Column() {
        Text('CreateNodeTreeOnMultiThread')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
        Button(this.message)
          .onClick(() => {
            this.isShow = !this.isShow;
            if (this.isShow) {
              this.message = 'DisposeNodeTree'
            } else {
              this.message = 'CreateNodeTree'
            }
          })
        if (this.isShow) {
          CAPIComponent()
        }
        Button('ShowDrawPage')
          .onClick(()=>{
            const uiContext: UIContext = this.getUIContext();
            const router = uiContext.getRouter();
            router.pushUrl({
              url:'pages/drawPage/DrawPage'
            })
          })
        Button('ShowNativeUIPage')
          .onClick(()=>{
            const uiContext: UIContext = this.getUIContext();
            const router = uiContext.getRouter();
            router.pushUrl({
              url:'pages/nativeUI/NativeUIPage'
            })
          })
        Button($r('app.string.Create_Component')).onClick(() => {
          const uiContext: UIContext = this.getUIContext();
          const router = uiContext.getRouter();
          router.pushUrl({
            url: 'pages/Index'
          });
        })
        Button($r('app.string.Custom_Attribute_Test')).onClick(() => {
          const uiContext: UIContext = this.getUIContext();
          const router = uiContext.getRouter();
          router.pushUrl({
            url: 'pages/customproperty'
          });
        })
        Button($r('app.string.LazyForEach_Page')).onClick(() => {
          const uiContext: UIContext = this.getUIContext();
          const router = uiContext.getRouter();
          router.pushUrl({
            url: 'pages/nodeadapter'
          });
        })
        // 该接口作用为NDK侧保存主窗口实例，用户保护实例错误调用场景。
        Button($r('app.string.Setting_NDKNativeWindows_Context')).onClick(()=> {
          entry.getContext(this.getUIContext());
        })
      }.width('100%')
    }.width('100%')
  }
}