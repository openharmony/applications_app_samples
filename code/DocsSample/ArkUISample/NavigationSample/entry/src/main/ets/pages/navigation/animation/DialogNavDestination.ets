/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start DialogNavDesAnimation]
@Builder
export function DialogNavDestinationBuilder() {
  DialogNavDestination();
}

@Component
export struct DialogNavDestination {
  stack: NavPathStack = AppStorage.get<NavPathStack>('basicNavigationStack')!;
  @State backColor: ResourceColor = '#0000000';

  build() {
    NavDestination() {
      Stack() {
        Text('Dialog')
          .fontSize(44)
          .backgroundColor(Color.White)
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor(this.backColor)
    .mode(NavDestinationMode.DIALOG)
    .onWillAppear(() => {
      //启动时候蒙层渐现
      this.getUIContext().animateTo({ duration:450 }, () => {
        this.backColor = '#66000000';
      });
    })
    .onWillDisappear(() => {
      // 消失时候蒙层渐隐
      this.getUIContext().animateTo({ duration: 450 }, () => {
        this.backColor = '#00000000';
      });
    })
  }
}
// [End DialogNavDesAnimation]