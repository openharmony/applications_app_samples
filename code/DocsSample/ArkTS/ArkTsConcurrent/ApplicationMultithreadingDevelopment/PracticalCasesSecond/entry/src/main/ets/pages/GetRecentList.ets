/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
// [Start get_recentList]
// GetRecentList.ets
import { taskpool } from '@kit.ArkTS';
import { lruCache } from '../utils/LruCache'
// [StartExclude get_recentList]
import { GotoButton } from '../utils/MyButton';
// [EndExclude get_recentList]

@Concurrent
async function updateBooks(key: string, value: string) {
  // 在子线程更新最近访问列表
  await lruCache.put(key, value);
}

@Entry
@Component
struct GetRecentList {
  @State message: string = '书架';
  @State books: string[] = [];

  async aboutToAppear () {
    // 自动获取最近访问的图书列表
    this.books = await lruCache.keys();
  }

  build() {
    Column({ space: 1 }) {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: 'container', align: VerticalAlign.Center },
          middle: { anchor: 'container', align: HorizontalAlign.Center }
        })
      Button(this.books[3])
        .fontSize(20)
        .padding(10)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          // 获取绑定的图书信息
          let value = await lruCache.get(this.books[3]);
          // 更新最近访问列表
          taskpool.execute(updateBooks, this.books[3], value);
          this.getUIContext().getRouter().pushUrl({ url: 'pages/' + value });
        })
      Button(this.books[2])
        .fontSize(20)
        .padding(10)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          // 获取绑定的图书信息
          let value = await lruCache.get(this.books[2]);
          // 更新最近访问列表
          taskpool.execute(updateBooks, this.books[2], value);
          this.getUIContext().getRouter().pushUrl({ url: 'pages/' + value });
        })
      Button(this.books[1])
        .fontSize(20)
        .padding(10)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          // 获取绑定的图书信息
          let value = await lruCache.get(this.books[1]);
          // 更新最近访问列表
          taskpool.execute(updateBooks, this.books[1], value);
          this.getUIContext().getRouter().pushUrl({ url: 'pages/' + value });
        })
      Button(this.books[0])
        .fontSize(20)
        .padding(10)
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          // 获取绑定的图书信息
          let value = await lruCache.get(this.books[0]);
          // 更新最近访问列表
          taskpool.execute(updateBooks, this.books[0], value);
          this.getUIContext().getRouter().pushUrl({ url: 'pages/' + value });
        })
      // [StartExclude get_recentList]
      GotoButton({ text: '跳转回Index页面', dstUri: 'pages/Index'});
      // [EndExclude get_recentList]
    }
    .height('100%')
    .width('100%')
  }
}
// [End get_recentList]