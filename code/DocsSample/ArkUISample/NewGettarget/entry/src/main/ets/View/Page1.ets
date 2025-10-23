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
// [Start Changes_to_the_content_in_the_original]
import { UIUtils } from '@kit.ArkUI';
@Observed
class Info {
  public name: string = 'Tom';
}
@Entry
@Component
struct Page1 {
  @State info: Info = new Info();

  build() {
    Column() {
      Text(`info.name: ${this.info.name}`)
      // $r('app.string.arkts_new_gettarget2') 需要替换为开发者所需的资源文件
      Button($r('app.string.arkts_new_gettarget2'))
        .onClick(() => {
          this.info.name = 'Alice'; // Text组件能够刷新
        })
      // $r('app.string.arkts_new_gettarget3') 需要替换为开发者所需的资源文件
      Button($r('app.string.arkts_new_gettarget3'))
        .onClick(() => {
          let rawInfo: Info = UIUtils.getTarget(this.info);
          rawInfo.name = 'Bob'; // Text组件不能刷新
        })
    }
  }
}
// [End Changes_to_the_content_in_the_original]
