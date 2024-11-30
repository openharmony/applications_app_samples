/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { MemoDataSource } from './DataSource';
import { MemoInfo } from './MemoInfo';
import MemoItem from './MemoItem';
import { promptAction } from '@kit.ArkUI';

@Builder
export function titleContent() {
  TitleContent();
}

/**
 * 页面内容
 */
@Component
struct TitleContent {

  // 懒加载模拟数据源
  @State memoData: MemoDataSource = new MemoDataSource();
  // 滚动控制器
  private scroller: ListScroller = new ListScroller();
  // toast弹窗时长
  private toastDuration: number = 2000;
  private searchMemoSpace: number = 12;

  build() {
    List({ space: this.searchMemoSpace, scroller: this.scroller }) {
      ListItem() {
        Search({ placeholder: $r('app.string.expanded_title_search_placeholder') })
          .width($r('app.string.expanded_title_layout_100_percent'))
          .height($r('app.string.expanded_title_layout_8_percent'))
          .backgroundColor(Color.White)
      }

      // TODO: 性能知识点：动态加载数据场景可以使用LazyForEach遍历数据。参考资料：
      // https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.0-Release/zh-cn/application-dev/quick-start/arkts-rendering-control-lazyforeach.md
      LazyForEach(this.memoData, (item: MemoInfo) => {
        ListItem() {
          MemoItem({ memoItem: item })
        }
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.expanded_title_toast_hint_message'),
            duration: this.toastDuration
          });
        })
      }, (item: MemoInfo) => JSON.stringify(item))
    }
    .margin({ left: $r('app.string.expanded_title_layout_10'), right: $r('app.string.expanded_title_layout_10') })
    .width($r('app.string.expanded_title_layout_90_percent'))
  }
}