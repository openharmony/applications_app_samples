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

import { ComponentCard } from '../../common/Card';

// [Start switch_the_tab_specific_tab]
// [StartExclude switch_the_tab_specific_tab]
@Entry
@Component
export struct ContentWillChange {
  scroller: Scroller = new Scroller();
  @State currentIndexThree: number = 2;
  @State currentIndexTwo: number = 2;
  private controllerTwo: TabsController = new TabsController();
  // [EndExclude switch_the_tab_specific_tab]
  @State currentIndex: number = 2;
  @State currentAnimationMode: AnimationMode = AnimationMode.CONTENT_FIRST;
  private controller: TabsController = new TabsController();

  // [StartExclude switch_the_tab_specific_tab]
  @Builder
  tabBuilder(title: ResourceStr, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#F111C1' : '#6B6B6B')
    }
  }

  @Builder
  tabBuilderTwo(title: ResourceStr, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndexTwo === targetIndex ? '#F111C1' : '#6B6B6B')
    }
  }

  @Builder
  tabBuilderThree(title: ResourceStr, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndexThree === targetIndex ? '#F111C1' : '#6B6B6B')
    }
  }

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          ComponentCard({ title: $r('app.string.ContentWillChange_titleContentAndTabSync') }) {
            Tabs({ barPosition: BarPosition.End }) {
              TabContent() {
                Text($r('app.string.homepage_content'))
                  .fontSize(30)
              }
              .backgroundColor(Color.Blue)
              .tabBar(this.tabBuilder($r('app.string.homepage'), 0))

              TabContent() {
                Text($r('app.string.discover_content'))
                  .fontSize(30)
              }
              .backgroundColor(Color.Green)
              .tabBar(this.tabBuilder($r('app.string.discover'), 1))

              TabContent() {
                Text($r('app.string.recommend_content'))
                  .fontSize(30)
              }
              .backgroundColor(Color.Yellow)
              .tabBar(this.tabBuilder($r('app.string.recommend'), 2))

              TabContent() {
                Text($r('app.string.mine_content'))
                  .fontSize(30)
              }
              .backgroundColor(Color.Orange)
              .tabBar(this.tabBuilder($r('app.string.mine'), 3))
            }
            .animationDuration(0)
            .height(300)
            .onChange((index: number) => {
              this.currentIndex = index;
            })
          }

          ComponentCard({ title: $r('app.string.ContentWillChange_titleSpecifiedTab') }) {
            Column({ space: 8 }) {
              // [EndExclude switch_the_tab_specific_tab]
              Tabs({ barPosition: BarPosition.End, index: this.currentIndexTwo, controller: this.controller }) {
                // [StartExclude switch_the_tab_specific_tab]
                TabContent() {
                  Text($r('app.string.homepage_content'))
                    .fontSize(30)
                }
                .backgroundColor(Color.Blue)
                .tabBar(this.tabBuilderTwo($r('app.string.homepage'), 0))

                TabContent() {
                  Text($r('app.string.discover_content'))
                    .fontSize(30)
                }
                .backgroundColor(Color.Green)
                .tabBar(this.tabBuilderTwo($r('app.string.discover'), 1))

                TabContent() {
                  Text($r('app.string.recommend_content'))
                    .fontSize(30)
                }
                .backgroundColor(Color.Yellow)
                .tabBar(this.tabBuilderTwo($r('app.string.recommend'), 2))

                TabContent() {
                  Text($r('app.string.mine_content'))
                    .fontSize(30)
                }
                .backgroundColor(Color.Orange)
                .tabBar(this.tabBuilderTwo($r('app.string.mine'), 3))
                // [EndExclude switch_the_tab_specific_tab]
              }
              .animationDuration(0)
              .height(300)
              .animationMode(this.currentAnimationMode)
              .onChange((index: number) => {
                this.currentIndexTwo = index;
              })

              // app.string.ContentWillChange_changeIndex资源文件中的value值为‘动态修改index’
              Button('app.string.ContentWillChange_changeIndex').width('50%').margin({ top: 1 }).height(25)
                .onClick(()=>{
                  if (this.currentAnimationMode === AnimationMode.CONTENT_FIRST) {
                    this.currentAnimationMode = AnimationMode.ACTION_FIRST;
                  } else if (this.currentAnimationMode === AnimationMode.ACTION_FIRST) {
                    this.currentAnimationMode = AnimationMode.NO_ANIMATION;
                  } else if (this.currentAnimationMode === AnimationMode.NO_ANIMATION) {
                    this.currentAnimationMode = AnimationMode.CONTENT_FIRST_WITH_JUMP;
                  } else if (this.currentAnimationMode === AnimationMode.CONTENT_FIRST_WITH_JUMP) {
                    this.currentAnimationMode = AnimationMode.ACTION_FIRST_WITH_JUMP;
                  } else if (this.currentAnimationMode === AnimationMode.ACTION_FIRST_WITH_JUMP) {
                    this.currentAnimationMode = AnimationMode.CONTENT_FIRST;
                  }
              })

              // app.string.ContentWillChange_changeIndex资源文件中的value值为‘动态修改index’
              Button($r('app.string.ContentWillChange_changeIndex')).width('50%').margin({ top: 20 })
                .onClick(() => {
                  this.currentIndexTwo = (this.currentIndexTwo + 1) % 4;
                })

              Button('changeIndex').width('50%').margin({ top: 20 })
                .onClick(() => {
                  let index = (this.currentIndexTwo + 1) % 4;
                  this.controller.changeIndex(index);
                })
              // [End switch_the_tab_specific_tab]
            }
          }

          ComponentCard({ title: $r('app.string.ContentWillChange_titleInterception') }) {
            Column({ space: 8 }) {
              // [Start custom_page_toggle_interception_events]
              Tabs({ barPosition: BarPosition.End, index: this.currentIndexThree, controller: this.controllerTwo }) {
                // [StartExclude custom_page_toggle_interception_events]
                TabContent() {
                  Text($r('app.string.homepage_content'))
                    .fontSize(30)
                }
                .backgroundColor(Color.Blue)
                .tabBar(this.tabBuilderThree($r('app.string.homepage'), 0))

                TabContent() {
                  Text($r('app.string.discover_content'))
                    .fontSize(30)
                }
                .backgroundColor(Color.Green)
                .tabBar(this.tabBuilderThree($r('app.string.discover'), 1))

                TabContent() {
                  Text($r('app.string.recommend_content'))
                    .fontSize(30)
                }
                .backgroundColor(Color.Yellow)
                .tabBar(this.tabBuilderThree($r('app.string.recommend'), 2))

                TabContent() {
                  Text($r('app.string.mine_content'))
                    .fontSize(30)
                }
                .backgroundColor(Color.Orange)
                .tabBar(this.tabBuilderThree($r('app.string.mine'), 3))
                // [EndExclude custom_page_toggle_interception_events]
              }
              // [StartExclude custom_page_toggle_interception_events]
              .animationDuration(0)
              .height(300)
              .onChange((index: number) => {
                this.currentIndexThree = index;
              })
              // [EndExclude custom_page_toggle_interception_events]
              .onContentWillChange((currentIndex, comingIndex) => {
                if (comingIndex == 2) {
                  return false;
                }
                return true;
              })
              // [End custom_page_toggle_interception_events]

              Button($r('app.string.ContentWillChange_changeIndex')).width('50%')
                .onClick(() => {
                  this.currentIndexThree = (this.currentIndexThree + 1) % 4;
                })

              Button('changeIndex').width('50%')
                .onClick(() => {
                  let index = (this.currentIndexThree + 1) % 4;
                  this.controllerTwo.changeIndex(index);
                })
            }
          }
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ContentWillChange_title'))
  }
}