/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { TabContentOverFlowComponent } from 'tabcontentoverflow';

@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      /**
       * 功能描述：本示例介绍使用Flex组件实现图片在不同个数情况下的布局效果(默认布局和自定义布局)。
       * 参数介绍：无
       */
      TabContentOverFlowComponent()
    }
    .height('100%')
    .width('100%')
  }
}