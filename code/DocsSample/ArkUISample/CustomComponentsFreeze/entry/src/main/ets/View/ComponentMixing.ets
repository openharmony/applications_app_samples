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
// [Start arkts_custom_components_freeze9]
import { hilog } from '@kit.PerformanceAnalysisKit';
@Component
struct ChildOfParamComponent {
  @Prop @Watch('onChange') childVal: number;

  onChange() {
    hilog.info(0x0000, 'ChildComponent has been recycled', 'FreezeChild message callback func %{public}d, index: %{public}d',this.childVal);
  }

  build() {
    Column() {
      Text(`Child Param： ${this.childVal}`);
    }
  }
}

@Component
struct ParamComponent {
  @Prop @Watch('onChange') paramVal: number;

  onChange() {
    hilog.info(0x0000, 'ChildComponent has been recycled', 'FreezeChild message callback func %{public}d, index: %{public}d',this.paramVal);
  }

  build() {
    Column() {
      Text(`val： ${this.paramVal}`)
      ChildOfParamComponent({ childVal: this.paramVal });
    }
  }
}



@Component
struct DelayComponent {
  @Prop @Watch('onChange') delayVal: number;

  onChange() {
    hilog.info(0x0000, 'ChildComponent has been recycled', 'FreezeChild message callback func %{public}d, index: %{public}d',this.delayVal);
  }

  build() {
    Column() {
      Text(`Delay Param： ${this.delayVal}`);
    }
  }
}

@Component({ freezeWhenInactive: true })
struct TabsComponent {
  private controller: TabsController = new TabsController();
  @State @Watch('onChange') tabState: number = 47;

  onChange() {
    hilog.info(0x0000, 'ChildComponent has been recycled', 'FreezeChild message callback func %{public}d, index: %{public}d',this.tabState);
  }

  build() {
    Column({ space: 10 }) {
      Button(`Incr state ${this.tabState}`)
        .fontSize(25)
        .onClick(() => {
          hilog.info(0x0000, 'Button increment state valued', 'FreezeChild message callback func %{public}d, index: %{public}d');
          this.tabState = this.tabState + 1;
        })

      Tabs({ barPosition: BarPosition.Start, index: 0, controller: this.controller }) {
        TabContent() {
          ParamComponent({ paramVal: this.tabState });
        }.tabBar('Update')

        TabContent() {
          DelayComponent({ delayVal: this.tabState });
        }.tabBar('DelayUpdate')
      }
      .vertical(false)
      .scrollable(true)
      .barMode(BarMode.Fixed)
      .barWidth(400)
      .barHeight(150)
      .animationDuration(400)
      .width('100%')
      .height(200)
      .backgroundColor(0xF5F5F5)
    }
  }
}

@Entry
@Component
struct ComponentMixing {
  @Provide('pageInfo') pageInfo: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string) {
    if (name === 'pageOne') {
      PageOneStack2()
    } else if (name === 'pageTwo') {
      PageTwoStack()
    }
  }

  build() {
    Column() {
      Navigation(this.pageInfo) {
        Column() {
          Button('Next Page', { stateEffect: true, type: ButtonType.Capsule })
            .width('80%')
            .height(40)
            .margin(20)
            .onClick(() => {
              this.pageInfo.pushPath({ name: 'pageOne' }); //将name指定的NavDestination页面信息入栈
            })
        }
      }.title('NavIndex')
      .navDestination(this.PageMap)
      .mode(NavigationMode.Stack)
    }
  }
}

@Component
struct PageOneStack2 {
  @Consume('pageInfo') pageInfo: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        TabsComponent();

        Button('Next Page', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.pageInfo.pushPathByName('pageTwo', null);
          })
      }.width('100%').height('100%')
    }.title('pageOne')
    .onBackPressed(() => {
      this.pageInfo.pop();
      return true;
    })
  }
}

@Component
struct PageTwoStack {
  @Consume('pageInfo') pageInfo: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Button('Back Page', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.pageInfo.pop();
          })
      }.width('100%').height('100%')
    }.title('pageTwo')
    .onBackPressed(() => {
      this.pageInfo.pop();
      return true;
    })
  }
}
// [End arkts_custom_components_freeze9]