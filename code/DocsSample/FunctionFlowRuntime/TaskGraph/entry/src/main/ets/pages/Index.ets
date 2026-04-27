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
 
import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import CommonConstants from '../../common/CommonConstants';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State parallelDepResult: string = 'Not Executed';
  @State parallelFibResult: string = 'Not Executed';

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        Column({ space: CommonConstants.COLUMN_SPACE }) {
          Row() {
            Text($r('app.string.title'))
              .fontSize($r('app.float.title_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.title_text_height'))
              .align(Alignment.Center)
              .maxLines(CommonConstants.TITLE_MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .height($r('app.float.title_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          Row() {
            Text($r('app.string.FFRT_TaskGraph_Dep_des'))
              .fontSize($r('app.float.text_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.description_text_height'))
              .align(Alignment.Start)
              .maxLines(CommonConstants.TEXT_MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .padding({ left: $r('app.float.text_padding'), right: $r('app.float.text_padding') })
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
          Row() {
            Image($r('app.media.FFRT_TaskGraph_Dep'))
              .height($r('app.float.image_height'))
          }
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
          Row() {
            Text(this.parallelDepResult)
              .fontSize($r('app.float.output_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
          }
          .width(CommonConstants.PARTIAL_PARENT)
          .borderRadius($r('app.float.display_area_border_radius'))
          .height($r('app.float.display_area_height'))
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
          .backgroundColor(Color.White)
          Row() {
            Button($r('app.string.FFRT_TaskGraph_Dep_lable'))
              .id("FFRTTaskGraphC")
              .fontSize($r('app.float.button_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height(CommonConstants.FILL_PARENT)
              .width($r('app.float.button_width_wide'))
              .onClick(() => {
                this.parallelDepResult = 'Submit Success C';
                hilog.info(DOMAIN, 'TestTag', 'FFRT Task Graph Dependence C Demo %{public}d', testNapi.parallel_dependence_exec(true));
              })
          }
          .height($r('app.float.button_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          .margin({ top: $r('app.float.button_margin'), bottom: $r('app.float.button_margin')})
          Row() {
            Button($r('app.string.FFRT_TaskGraph_Dep_Cpp_lable'))
              .id("FFRTTaskGraphCpp")
              .fontSize($r('app.float.button_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height(CommonConstants.FILL_PARENT)
              .width($r('app.float.button_width'))
              .onClick(() => {
                this.parallelDepResult = 'Submit Success Cpp';
                hilog.info(DOMAIN, 'TestTag', 'FFRT Task Graph Dependence Cpp Demo %{public}d', testNapi.parallel_dependence_exec(false));
              })
          }
          .height($r('app.float.button_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          .margin({ top: $r('app.float.button_margin'), bottom: $r('app.float.button_margin')})
          Row() {
            Text($r('app.string.Print_des'))
              .fontSize($r('app.float.text_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.description_text_height'))
              .align(Alignment.Start)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .padding({ left: $r('app.float.text_padding'), right: $r('app.float.text_padding') })
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
        }
        .width(CommonConstants.FILL_PARENT)
        .height(CommonConstants.FILL_PARENT)
        .backgroundColor($r('app.color.background_color'))
      }
      .tabBar('图依赖并发')

      TabContent() {
        Column({ space: CommonConstants.COLUMN_SPACE }) {
          Row() {
            Text($r('app.string.title'))
              .fontSize($r('app.float.title_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.title_text_height'))
              .align(Alignment.Center)
              .maxLines(CommonConstants.TITLE_MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .height($r('app.float.title_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          Row() {
            Text($r('app.string.FFRT_TaskGraph_Fib_des'))
              .fontSize($r('app.float.text_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.description_text_height'))
              .align(Alignment.Start)
              .maxLines(CommonConstants.TEXT_MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .padding({ left: $r('app.float.text_padding'), right: $r('app.float.text_padding') })
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
          Row() {
            Image($r('app.media.FFRT_TaskGraph_Fib'))
              .height($r('app.float.image_height_l'))
          }
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
          Row() {
            Text(this.parallelFibResult)
              .fontSize($r('app.float.output_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
          }
          .width(CommonConstants.PARTIAL_PARENT)
          .borderRadius($r('app.float.display_area_border_radius'))
          .height($r('app.float.display_area_height'))
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
          .backgroundColor(Color.White)
          Row() {
            Button($r('app.string.FFRT_TaskGraph_Fib_lable'))
              .fontSize($r('app.float.button_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height(CommonConstants.FILL_PARENT)
              .width($r('app.float.button_width_wide'))
              .onClick(() => {
                this.parallelFibResult = 'Submit Success C';
                hilog.info(DOMAIN, 'TestTag', 'FFRT Task Graph Fibonacci C Demo %{public}d', testNapi.parallel_fib_exec(true));
              })
          }
          .height($r('app.float.button_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          .margin({ top: $r('app.float.button_margin'), bottom: $r('app.float.button_margin')})
          Row() {
            Button($r('app.string.FFRT_TaskGraph_Fib_Cpp_lable'))
              .fontSize($r('app.float.button_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height(CommonConstants.FILL_PARENT)
              .width($r('app.float.button_width'))
              .onClick(() => {
                this.parallelFibResult = 'Submit Success Cpp';
                hilog.info(DOMAIN, 'TestTag', 'FFRT Task Graph Fibonacci Cpp Demo %{public}d', testNapi.parallel_fib_exec(false));
              })
          }
          .height($r('app.float.button_height'))
          .width(CommonConstants.FILL_PARENT)
          .justifyContent(FlexAlign.Center)
          .margin({ top: $r('app.float.button_margin'), bottom: $r('app.float.button_margin')})
          Row() {
            Text($r('app.string.Print_des'))
              .fontSize($r('app.float.text_font_size'))
              .fontWeight(CommonConstants.FONT_WEIGHT)
              .height($r('app.float.description_text_height'))
              .align(Alignment.Start)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .padding({ left: $r('app.float.text_padding'), right: $r('app.float.text_padding') })
          .margin({ top: $r('app.float.text_margin'), bottom: $r('app.float.text_margin')})
        }
        .width(CommonConstants.FILL_PARENT)
        .height(CommonConstants.FILL_PARENT)
        .backgroundColor($r('app.color.background_color'))
      }
      .tabBar('图依赖斐波那契')
    }
  }
}
