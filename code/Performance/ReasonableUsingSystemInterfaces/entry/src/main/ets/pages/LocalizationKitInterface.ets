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

// 导入自定义打点模块
import { hiTraceMeter } from '@kit.PerformanceAnalysisKit';
// 导入国际化接口intl
import { intl } from '@kit.LocalizationKit';

/**
 * “国际化使用Localization Kit接口替换ArkTS运行时接口” - 正例：使用Localization Kit接口intl
 */

// 循环创建100次RelativeTimeFormat对象，记录每次创建的耗时和总执行耗时
hiTraceMeter.startTrace('RelativeTimeFormat-100', 1);
for (let i = 0; i < 100; i++) {
  hiTraceMeter.startTrace('RelativeTimeFormat-single', 2);
  let relativeTimeFormat = new intl.RelativeTimeFormat('zh-CN', { numeric: 'auto' });
  hiTraceMeter.finishTrace('RelativeTimeFormat-single', 2);
}
hiTraceMeter.finishTrace('RelativeTimeFormat-100', 1);

// 循环创建100次Locale对象，记录每次创建的耗时和总执行耗时
hiTraceMeter.startTrace('Locale-100', 3);
for (let i = 0; i < 100; i++) {
  hiTraceMeter.startTrace('Locale-single', 4);
  let locale = new intl.Locale('zh-CN');
  hiTraceMeter.finishTrace('Locale-single', 4);
}
hiTraceMeter.finishTrace('Locale-100', 3);

// 循环创建100次DateTimeFormat对象，记录每次创建的耗时和总执行耗时
hiTraceMeter.startTrace('DateTimeFormat-100', 5);
for (let i = 0; i < 100; i++) {
  hiTraceMeter.startTrace('DateTimeFormat-single', 6);
  let dateTimeFormat = new intl.DateTimeFormat('zh-CN', { dateStyle: 'full', timeStyle: 'medium' });
  hiTraceMeter.finishTrace('DateTimeFormat-single', 6);
}
hiTraceMeter.finishTrace('DateTimeFormat-100', 5);

// 循环创建100次NumberFormat对象，记录每次创建的耗时和总执行耗时
hiTraceMeter.startTrace('NumberFormat-100', 7);
for (let i = 0; i < 100; i++) {
  hiTraceMeter.startTrace('NumberFormat-single', 8);
  let numberFormat = new intl.NumberFormat('en-GB', { style: 'decimal', notation: 'scientific' });
  hiTraceMeter.finishTrace('NumberFormat-single', 8);
}
hiTraceMeter.finishTrace('NumberFormat-100', 7);

// 循环创建100次Collator对象，记录每次创建的耗时和总执行耗时
hiTraceMeter.startTrace('Collator-100', 9);
for (let i = 0; i < 100; i++) {
  hiTraceMeter.startTrace('Collator-single', 10);
  let collator = new intl.Collator('zh-CN', { localeMatcher: 'lookup', usage: 'sort' });
  hiTraceMeter.finishTrace('Collator-single', 10);
}
hiTraceMeter.finishTrace('Collator-100', 9);

// 循环创建100次PluralRules对象，记录每次创建的耗时和总执行耗时
hiTraceMeter.startTrace('PluralRules-100', 11);
for (let i = 0; i < 100; i++) {
  hiTraceMeter.startTrace('PluralRules-single', 12);
  let pluralRules = new intl.PluralRules('zh-CN', { localeMatcher: 'lookup', type: 'cardinal' });
  hiTraceMeter.finishTrace('PluralRules-single', 12);
}
hiTraceMeter.finishTrace('PluralRules-100', 11);

@Entry
@Component
struct LocalizationKitInterface {
  @State message: string = 'LocalizationKitInterface';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('LocalizationKitInterface')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}