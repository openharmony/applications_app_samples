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
// [Start Word_Break]
import { common } from '@kit.AbilityKit';
@Entry
@Component
export struct WordBreakd {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private manager = this.context.resourceManager;

  // 'Text_WordBreak'资源文件中的value值为'混合Hello World! honorificabilitudinitatibus'
  @State message: string = this.manager.getStringByNameSync('Text_WordBreak');
  build() {
    NavDestination() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize('25fp')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis})
        .onClick(() => {
          this.message = 'Welcome try try try 1235628327434348';
        })
        .border({ width: 1})
        .wordBreak(WordBreak.BREAK_ALL) // 修改断词模式
    }
    .width(300)
    .border({ width: 1, color: Color.Blue})
    .margin({left: 30, top: 50})
    }
    // [StartExclude Word_Break]
    .backgroundColor('#f1f 2f3')
    .title($r('app.string.Word_Break'))
    // [EndExclude Word_Break]
  }
}
// [End Word_Break]