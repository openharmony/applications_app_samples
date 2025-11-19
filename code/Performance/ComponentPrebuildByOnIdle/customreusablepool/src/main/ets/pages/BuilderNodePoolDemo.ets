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

import { flowItemWrapper, REUSE_VIEW_TYPE_ITEM, TabNode } from '../view/TabNode';
import { Title } from '../data/TitleBean';
import { TitleDataSource } from '../data/TitleDataSource';
import { TitleView } from '../view/TitleView';
import { Constants } from '../constants/Constants';
import { FrameCallback } from '@kit.ArkUI';
import { systemDateTime } from '@kit.BasicServicesKit';
import { NodePool } from '../utils/BuilderNodePool';
import { ViewItem } from '../data/ViewItem';
import { hiTraceMeter } from '@kit.PerformanceAnalysisKit';

export class IdleCallback extends FrameCallback {
  private uiContext: UIContext;
  private todoCount: number = 0;
  private viewItems: ViewItem[] = [];

  constructor(context: UIContext, preBuildData: ViewItem[]) {
    super();
    this.uiContext = context;
    this.viewItems = preBuildData;
  }


  onIdle(idleTimeInNano: number): void {
    if (this.todoCount >= this.viewItems.length) {
      return;
    }
    let cur: number = systemDateTime.getTime(true);
    let timeLeft = idleTimeInNano;
    while (timeLeft >= 1000000) {
      hiTraceMeter.startTrace('onIdle_prebuild', 1);
      NodePool.getInstance()
        .preBuild(REUSE_VIEW_TYPE_ITEM, this.viewItems[this.todoCount], flowItemWrapper, this.uiContext);
      hiTraceMeter.finishTrace('onIdle_prebuild', 1);
      let now = systemDateTime.getTime(true);
      timeLeft = timeLeft - (now - cur);
      cur = now;
      this.todoCount++;
      if (this.todoCount >= this.viewItems.length) {
        return;
      }
    }
    if (this.todoCount < this.viewItems.length) {
      this.uiContext.postFrameCallback(this);
    }
  }
}

// 全局自定义组件复用池页面，可以实现跨页面、跨父组件复用子组件，减少组件创建耗时，提高应用性能
@Component
export struct BuilderNodePoolDemo {
  @State arrayTitle: Title[] = [];
  arrayStr: string[] = [Constants.HOME, Constants.FILM, Constants.TELEPLAY, Constants.ANIMATION, Constants.SPORT];
  @State array: TitleDataSource = new TitleDataSource();
  swiperController: SwiperController = new SwiperController();
  @State selectIndex: number = 0;

  aboutToAppear(): void {
    // 添加标题模拟数据
    for (let i = 0; i < this.arrayStr.length; i++) {
      let title: Title = new Title();
      if (i === 0) {
        title.isSelected = true;
      }
      title.name = this.arrayStr[i];
      this.arrayTitle.push(title);
      this.array.addItem(this.arrayStr[i]);
    }
  }

  build() {
    NavDestination() {
      List() {
        ForEach(this.arrayTitle, (title: Title, index: number) => {
          ListItem() {
            TitleView({
              title: title, clickListener: () => {
                if (title.isSelected) {
                  return;
                }
                // 点击标题时，Swiper组件跳转到对应的页面
                this.swiperController.changeIndex(index, true);
                // 设置标题为选中状态
                this.arrayTitle[index].isSelected = true;
                this.arrayTitle[this.selectIndex].isSelected = false;
                this.selectIndex = index;
              }
            }).padding({
              left: index === 0 ? $r('app.integer.customreusablepool_title_view_padding_left_side') :
              $r('app.integer.customreusablepool_title_view_padding_left'),
              right: index === this.arrayTitle.length - 1 ?
              $r('app.integer.customreusablepool_title_view_padding_right_side') :
              $r('app.integer.customreusablepool_title_view_padding_right')
            })
          }
        })
      }
      .height($r('app.integer.customreusablepool_title_view_list_height'))
      .listDirection(Axis.Horizontal)

      Swiper(this.swiperController) {
        LazyForEach(this.array, (item: string, index: number) => {
          TabNode({ index: index })
        }, (title: string) => title)
      }
      .loop(false)
      .onChange((index: number) => {
        // Swiper滑动切换页面时，改变标题栏的选中状态
        if (this.selectIndex !== index) {
          this.arrayTitle[index].isSelected = true;
          this.arrayTitle[this.selectIndex].isSelected = false;
          this.selectIndex = index;
        }
      })
      .cachedCount(0)
    }
  }
}