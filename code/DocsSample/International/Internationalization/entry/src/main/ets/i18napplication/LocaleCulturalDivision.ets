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

import TitleBar from '../component/TitleBar';
import { assertEqual } from '../component/AssertEqual';
import { intl } from '@kit.LocalizationKit';

// 创建区域标识对象。格式化时间日期如下给出了三种方法:
let date = new Date(2023, 9, 15);

// 方法一: 通过区域标识字符串创建区域标识对象
let zhLocale = new intl.Locale('zh-Hans-CN-u-nu-latn');
let zhDateTimeFmt = new intl.DateTimeFormat(zhLocale.toString());
let result1 = zhDateTimeFmt.format(date); // "2023/10/15"

// 方法二: 通过区域标识字符串和LocaleOptions对象创建区域标识对象
let enLocale = new intl.Locale('en', { numberingSystem: 'latn' });
let enDateTimeFmt = new intl.DateTimeFormat(enLocale.toString());
let result2 = enDateTimeFmt.format(date); // "10/15/23"

// 方法三: 通过默认Locale函数创建系统区域标识对象
let systemLocale = new intl.Locale();
let systemDateTimeFmt = new intl.DateTimeFormat(systemLocale.toString());
let result3 = systemDateTimeFmt.format(date); // "2023/10/15" （具体显示效果依赖于当前系统环境）

const expectedResult1 = '2023/10/15';
const expectedResult2 = '10/15/23';
const expectedResult3 = '2023/10/15';

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .margin({ top: 20, left: 30, right: 30 });
}

@Entry
@Component
struct LocaleCulturalDivision {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.LocaleCulturalDivision') })
      Text($r('app.string.MethodOne'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(result1, expectedResult1, $r('app.string.ResultOfMethodOne')))
        .textStyle()
      Text($r('app.string.MethodTwo'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(result2, expectedResult2, $r('app.string.ResultOfMethodTwo')))
        .textStyle()
      Text($r('app.string.MethodThree'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(result3, expectedResult3, $r('app.string.ResultOfMethodThree')))
        .textStyle()
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}