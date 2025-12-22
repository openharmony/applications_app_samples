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
import { common } from '@kit.AbilityKit';

interface Ary {
  path: string,
  name: string
}

@Entry
@Component
struct Index {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  ary: Ary[] = [
    {
      // 请在resources\base\element\string.json文件中配置name为'watch_text1'，value为非空字符串的资源，本例为"@Watch和自定义组件更新"
      name: this.context.resourceManager.getStringByNameSync('watch_text1'),
      path: 'pages/CountModifier'
    },
    {
      // 请在resources\base\element\string.json文件中配置name为'watch_text2'，value为非空字符串的资源，本例为"@Watch与@Link组合使用"
      name: this.context.resourceManager.getStringByNameSync('watch_text2'),
      path: 'pages/BasketModifier'
    },
    {
      // 请在resources\base\element\string.json文件中配置name为'watch_text3'，value为非空字符串的资源，本例为"@Watch的触发时机"
      name: this.context.resourceManager.getStringByNameSync('watch_text3'),
      path: 'pages/ParentComponent'
    },
    {
      // 请在resources\base\element\string.json文件中配置name为'watch_text4'，value为非空字符串的资源，本例为"使用changedPropertyName进行不同的逻辑处理"
      name: this.context.resourceManager.getStringByNameSync('watch_text4'),
      path: 'pages/UsePropertyName'
    },
  ]

  build() {
    Scroll() {
      Column({ space: 10 }) {
        ForEach(this.ary, (item: Ary) => {
          Button(item.name)
            .onClick(() => this.getUIContext().getRouter().pushUrl({ url: item.path }));
        }, (item: Ary) => item.name)
      }
      .width('100%')
    }
  }
}