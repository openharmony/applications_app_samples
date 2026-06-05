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

// [Start CombineWithFlexGrow]
import {ContainerReader, ContainerReaderAttribute, Size} from '@kit.ArkUI';
@Entry
@Component
struct Page8 {
  @State cSize: Size = {width:100,height:100};
  @State wBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_MD;
  @State hBreakpoint: HeightBreakpoint = HeightBreakpoint.HEIGHT_SM;
  @State cSize1: Size = {width:100,height:100};
  @State wBreakpoint1: WidthBreakpoint = WidthBreakpoint.WIDTH_MD;
  @State hBreakpoint1: HeightBreakpoint = HeightBreakpoint.HEIGHT_SM;

  build() {
    Column(){
      Row() {
        ContainerReader({
          size: this.cSize!!,
          widthBreakpoint:this.wBreakpoint!!,
          heightBreakpoint: this.hBreakpoint!!
        })
        .width(50)
        .flexGrow(1)
        .backgroundColor('#2787D9')
        Text('Text').width(100).height(100).backgroundColor('#F0FAFF')
        ContainerReader({
          size: this.cSize1!!,
          widthBreakpoint:this.wBreakpoint1!!,
          heightBreakpoint: this.hBreakpoint1!!
        })
        .width(50)
        .flexGrow(2)
        .backgroundColor('#2787D9')
      }
      .height('30%')
      .width('80%')
      .backgroundColor('#D5D5D5')
    }
    .height('100%')
    .width('100%')
  }
}
// [End CombineWithFlexGrow]