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
import XComponentContext from 'libentry.so';

type MethodName = keyof XComponentContext

@Builder
export function NdkPageBuilder(_: string, param: MethodName) {
  NdkPage({ methodName: param });
}

let xComponentId = 'componentId';

@Component
export default struct NdkPage {
  private xComponentContext: XComponentContext | undefined;
  @Prop methodName: MethodName;

  build() {
    NavDestination() {
      Column() {
        XComponent({ id: xComponentId, type: XComponentType.SURFACE, libraryname: 'entry' })
          .width('85%')
          .height('60%')
          .backgroundColor(Color.White)
          .borderRadius(12)
          .onLoad((xComponentContext) => {
            xComponentId += '1'
            if (!this.xComponentContext) {
              this.xComponentContext = xComponentContext as XComponentContext;
            }
            this.xComponentContext[this.methodName]();
          })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
    }
  }
}