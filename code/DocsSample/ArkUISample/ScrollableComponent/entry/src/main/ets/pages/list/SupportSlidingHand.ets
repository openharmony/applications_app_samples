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
// [Start class_News]
import { LengthMetrics } from '@kit.ArkUI';
import { ComponentCard } from '../../common/Card';
// [Start class_news_content]
class News {
  public id: string;
  public title: ResourceStr;
  public content: ResourceStr;
  public type: string;

  constructor(id: string, title: ResourceStr, content: ResourceStr, type: string) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.type = type;
  }
}
// [End class_news_content]
const FRICTION_SCALE: number = 4.2;
const DEFAULT_FRICTION: number = 1;

// [End class_News]
@Entry
@Component
export struct SupportSlidingHand {
  // [Start news_data]
  @State newsData: Array<News> = [
    // app.string.new_title 资源文件中的value值为'新闻标题'
    // app.string.new_short 资源文件中的value值为'这是第一条短新闻，内容较少，快速滑动切换'
    new News('1', $r('app.string.new_title'), $r('app.string.new_short'), 'short'),
    new News('2', $r('app.string.new_title'), $r('app.string.new_short'), 'short'),
    // app.string.new_long 资源文件中的value值为'这是第二条长新闻，内容较多，可以自由滑动查看完整内容。'
    new News('3', $r('app.string.new_title'), $r('app.string.new_long'), 'long'),
    new News('4', $r('app.string.new_title'), $r('app.string.new_short'), 'short'),
    new News('5', $r('app.string.new_title'), $r('app.string.new_long'), 'long'),
  ];
  // [End news_data]
  // 当前显示的新闻的索引
  @State currentIndex: number = 0;
  private scrollerForList: Scroller = new Scroller();
  @State listHeight: number = 500;

  // 判断当前是否为短新闻
  IsShortNews(currentIndex: number): boolean {
    return this.newsData[currentIndex].type === 'short'
  }

  build() {
    NavDestination() {
      Column({ space: 10 }) {
        //   顶部导航栏
        this.topBar()
        //   新闻列表
        List({ scroller: this.scrollerForList, space: 10 }) {
          ForEach(this.newsData, (item: News, index) => {
            ListItem() {
              Column({ space: 10 }) {
                Text(item.title)
                  .fontSize(18)
                  .fontColor(Color.Black)
                  .fontWeight(index === this.currentIndex ? 700 : 400)
                  .backgroundColor(index === this.currentIndex ? '#FF9800' : '#FFFFFF')
                  .padding({ top: 10, bottom: 5 })

                Text(item.content)
                  .fontSize(14)
                  .fontColor('#666666')
              }
              .width('100%')
              .height(item.type === 'short' ? '70%' : '200%')
              .backgroundColor(index === this.currentIndex ? '#FFFFFF' : '#F5F5F5')
              .borderRadius(8)
              .shadow(index === this.currentIndex ? { fill: true, color: '#9E9E9E', radius: 5 } :
                { radius: 5, fill: false })
            }
          }, (item: News) => item.id)
        }
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .width('100%')
        .height('80%')
        .onScrollIndex((startIndex: number) => {
          this.currentIndex = startIndex
        })
        .id('scrollToIndex')
        // 实现参考
        // [Start scroll_index_scroller_list]
        .onWillStopDragging((velocity: number) => {
          if (velocity < 0) {
            // 向下滑动处理
          } else {
            // 向上滑动处理
          }
          // [StartExclude scroll_index_scroller_list]
          // 短新闻处理
          if (this.IsShortNews(this.currentIndex)) {
            // [Start scroll_to_index]
            if (velocity > 10) {
              this.scrollerForList.scrollToIndex(this.currentIndex, true, ScrollAlign.START)
            } else if (velocity < -10) {
              this.scrollerForList.scrollToIndex(this.currentIndex + 1, true, ScrollAlign.START)
            }
            // [End scroll_to_index]
            return;
          }
          // 长新闻处理
          // [Start scroller_for_list]
          // [Start scroller_list_rect]
          let rect = this.scrollerForList.getItemRect(this.currentIndex);
          // [End scroller_list_rect]
          if (velocity < -30) {
            if (rect) {
              // 当前节点在页面内的剩余显示范围
              let leftRect = rect.y + rect.height;
              //   终点位置
              let mainPosition = -velocity * DEFAULT_FRICTION / FRICTION_SCALE;
              if (leftRect + mainPosition > 0.75 * this.listHeight) {
                this.scrollerForList.scrollToIndex(this.currentIndex + 1, true, ScrollAlign.START);
                return;
              } else if (leftRect + mainPosition < 0.25 * this.listHeight) {
                this.scrollerForList.scrollToIndex(this.currentIndex, true, ScrollAlign.END,
                  { extraOffset: LengthMetrics.vp(this.listHeight * 0.3) })
                return;
              }
            }
          } else if (velocity > 30) {
            let leftRect = rect?.y + rect?.height;
            let mainPosition = velocity * DEFAULT_FRICTION / FRICTION_SCALE;
            if (leftRect + mainPosition > 0.75 * this.listHeight) {
              this.scrollerForList.scrollToIndex(this.currentIndex, true, ScrollAlign.START);
              return;
            }
          }
          // [End scroller_for_list]
          // [EndExclude scroll_index_scroller_list]
        })
        // [End scroll_index_scroller_list]
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
      .height(this.listHeight)
      .backgroundColor(Color.White)
      .padding({ top: 20 })
    }.backgroundColor('#f1f2f3')
    .title($r('app.string.Support_Sliding_Hand_Event'))

  }

  @Builder
  topBar() {
    Column() {
      Column() {
        // $r('app.string.Today_Hot_News')需要替换为开发者所需的资源文件
        Text($r('app.string.Today_Hot_News'))
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(700)
          .margin({ bottom: 10 })
      }
    }
  }
}