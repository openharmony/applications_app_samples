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
// [Start startup008]
import { startupManager } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @State message: ResourceStr = $r('app.string.manual_mode');
  @State startParams1: Array<string> = ['StartupTask_006'];
  @State startParams2: Array<string> = ['libentry_00'];

  build() {
    RelativeContainer() {
      Button(this.message)
        .id('AppStartup')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          if (!startupManager.isStartupTaskInitialized('StartupTask_006') ) { // 判断是否已经完成初始化
            startupManager.run(this.startParams1);
          }
          if (!startupManager.isStartupTaskInitialized('libentry_006') ) {
            startupManager.run(this.startParams2);
          }
        })
        .alignRules({
          center: {anchor: '__container__', align: VerticalAlign.Center},
          middle: {anchor: '__container__', align: HorizontalAlign.Center}
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [EndExclude startup008]