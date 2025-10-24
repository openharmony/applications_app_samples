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
// [Start Internal_Gradual_Migration]
let storage: LocalStorage = new LocalStorage();

@ObservedV2
class V1StorageData {
  @Trace public title: string = 'V1OldComponent'

  @Monitor('title')
  onStrChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      console.info(`${path} changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
      if (path === 'title') {
        storage.setOrCreate('title', this.title);
      }
    })
  }
}

let v1Data: V1StorageData = new V1StorageData();

@Entry(storage)
@Component
struct V1OldComponent {
  @LocalStorageLink('title') title: string = 'V1OldComponent';

  build() {
    Column() {
      Text(`V1OldComponent: ${this.title}`)
        .fontSize(20)
        .onClick(() => {
          this.title = 'new value from V1OldComponent';
        })
      // 定义一个桥接的\@Component自定义组件，用于V1和V2的变量相互同步
      Bridge()
    }
  }
}


@Component
struct Bridge {
  @LocalStorageLink('title') @Watch('titleWatch') title: string = 'Bridge';

  titleWatch() {
    v1Data.title = this.title;
  }

  build() {
    NewV2Component()
  }
}

@ComponentV2
struct NewV2Component {
  build() {
    Column() {
      Text(`NewV2Component: ${v1Data.title}`)
        .fontSize(20)
        .onClick(() => {
          v1Data.title = 'NewV2Component';
        })
    }
  }
}
// [End Internal_Gradual_Migration]
@Component
export struct InternalGradualMigration {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Bridge()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_Gradual_Migration'))
  }
}