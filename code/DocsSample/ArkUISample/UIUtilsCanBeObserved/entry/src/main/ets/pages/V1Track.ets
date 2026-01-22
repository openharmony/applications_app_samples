/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start v1_track]
import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'CanBeObserved';

@Observed
class TrackUser {
  @Track
  public name?: string;
  @Track
  public age?: number;

  constructor(name?: string, age?: number) {
    this.name = name ?? '';
    this.age = age ?? 0;
  }

  // 在对象中提供判断该对象是否为可被观察对象的方法
  test(): void {
    hilog.info(0x00, TAG, `res: ${JSON.stringify(UIUtils.canBeObserved(this))}`);
  }
}

@Entry
@Component
struct V1Track {
  @State trackUser: TrackUser = new TrackUser('Robert', 25);

  build() {
    Column({ space: 20 }) {
      TrackChild({ trackUser: this.trackUser })
      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象，并且可被获取对象关联的组件信息
          this.trackUser.test();
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@Component
struct TrackChild {
  @ObjectLink trackUser: TrackUser;

  build() {
    Column() {
      // 组件中使用可被观察对象的属性
      Text('user name: ' + this.trackUser.name)
      // 组件中使用可被观察对象的属性
      Text('user age: ' + this.trackUser.age)
    }
  }
}
// [End v1_track]