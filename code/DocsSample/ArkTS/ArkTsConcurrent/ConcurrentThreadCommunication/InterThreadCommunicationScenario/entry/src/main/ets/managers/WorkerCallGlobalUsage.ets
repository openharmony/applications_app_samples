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

import worker from '@ohos.worker';
import { IconItemSource } from './IconItemSource';

// 创建Worker对象
const workerInstance: worker.ThreadWorker = new worker.ThreadWorker('../workers/Worker');

class PicData {
  public iconItemSourceList: IconItemSource[] = [];

  public setUp(): string {
    for (let index = 0; index < 20; index++) {
      const numStart: number = index * 6;
      // 此处循环使用6张图片资源
      this.iconItemSourceList.push(new IconItemSource('$media:startIcon', `item${numStart + 1}`));
      this.iconItemSourceList.push(new IconItemSource('$media:background', `item${numStart + 2}`));
      this.iconItemSourceList.push(new IconItemSource('$media:foreground', `item${numStart + 3}`));
      this.iconItemSourceList.push(new IconItemSource('$media:startIcon', `item${numStart + 4}`));
      this.iconItemSourceList.push(new IconItemSource('$media:background', `item${numStart + 5}`));
      this.iconItemSourceList.push(new IconItemSource('$media:foreground', `item${numStart + 6}`));

    }
    return 'setUpIconItemSourceList success!';
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          let picData = new PicData();
          // 在Worker上注册需要调用的对象
          workerInstance.registerGlobalCallObject('picData', picData);
          workerInstance.postMessage('run setUp in picData');
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}