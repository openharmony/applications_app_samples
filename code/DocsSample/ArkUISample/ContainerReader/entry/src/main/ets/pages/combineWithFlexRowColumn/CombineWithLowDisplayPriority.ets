/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
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

// [Start CombineWithLowDisplayPriority]
import {ContainerReader, ContainerReaderAttribute, Size} from '@kit.ArkUI';
@Entry
@Component
struct Page8 {
  @State cSize: Size = {width:100,height:100};
  @State wBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_MD;
  @State hBreakpoint: HeightBreakpoint = HeightBreakpoint.HEIGHT_SM;

  build() {
    Column(){
      Flex() {
        Text('Text').width(100).height(100).displayPriority(2).backgroundColor('#004AAF')
        Text('Text').width(100).height(100).displayPriority(2).backgroundColor('#2787D9')

        ContainerReader({
          size: this.cSize!!,
          widthBreakpoint:this.wBreakpoint!!,
          heightBreakpoint: this.hBreakpoint!!
        })
        .displayPriority(1)
        .backgroundColor('#004AAF')
      }
      .height('30%')
      .width('80%')
      .backgroundColor('#F0FAFF')
    }
    .height('100%')
    .width('100%')
  }
}
// [End CombineWithLowDisplayPriority]