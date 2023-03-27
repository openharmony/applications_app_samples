/*
* Copyright (c) 2023 Huawei Device Co., Ltd.
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

import RouterUtil from '../utils/RouterUtil';
import { AddressService } from './common/AddressService';
import { BottomNavigation } from './common/BottomNavigation';
import { Choice } from './common/Choice';
import { GoodsSwiper } from './common/GoodsSwiper';
import { Information } from './common/Information';
import { Location } from './common/Location';
import { SmallVideo } from 'video';
import { Valuation } from './common/Valuation';

let storage = LocalStorage.GetShared();

@Entry(storage)
@Component
struct Index {
  @State sOpacity: number = 1;
  @State isPanel: boolean = false;
  @State currentLocation: string = '';
  @State recommend: string = '';
  // Video组件
  @State isHidden: boolean = false;
  @State isState: boolean = true;
  @State isCancel: boolean = true;
  @State activeVideo: number = 0;
  @State openFirst: boolean = false;
  @Provide('playTime') playNum: number = 20;
  @StorageProp('curBp') curBp: string = 'md';
  @State currentWith: number = 0;
  private scroller: Scroller = new Scroller();

  build() {
    Stack() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          GoodsSwiper({ openFirst: $openFirst })
          Column({ space: 12 }) {
            Information()
            Choice()
            AddressService({ currentLocation: $currentLocation, isPanel: $isPanel })
            Valuation()
          }
          .padding({ left: 12, right: 12 })
        }
        .width('100%');
      }
      .width('100%')
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .padding({ bottom: this.curBp === 'sm' ? 86 : 106 })
      .onScroll(() => {
        if (this.activeVideo === 0 && this.openFirst) {
          if (this.scroller.currentOffset().yOffset > 450) {
            if (this.isState) {
              this.isHidden = true;
              this.isState = false;
            }
          } else {
            this.isHidden = false;
            this.isState = true;
          }
        }
      })

      BottomNavigation()
        .position({ x: 0, y: this.currentWith });

      SmallVideo({ isHidden: $isHidden, isCancel: $isCancel })
        .position({ x: '100%', y: '60%' })
        .translate({ x: -180, y: 0 });

      Panel(this.isPanel) {
        Location({ isPanel: $isPanel, currentLocation: $currentLocation })
      }
      .mode(PanelMode.Half)
      .dragBar(false)
      .halfHeight(this.curBp === 'sm' ? 650 : 530)
      .miniHeight(0)
      .onChange(() => {
        this.isPanel = false;
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.divider'))
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.currentWith = parseInt(newValue.height.toString()) - 56;
    })
  }

  aboutToAppear() {
    let context: Context = getContext(this);
    this.currentLocation = context.resourceManager.getStringSync($r('app.string.address').id);
    this.recommend = context.resourceManager.getStringSync($r('app.string.recommend').id);
    RouterUtil.setContext(getContext(this));
  }
}