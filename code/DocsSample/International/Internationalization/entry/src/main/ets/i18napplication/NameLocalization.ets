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
import { assertEqual, assertEqualFuzzy } from '../component/AssertEqual';
import { resourceToString } from '../component/ResourceToString';
import { i18n } from '@kit.LocalizationKit';

/**********************************
 * 本地化语言与地区名称开发步骤
 **********************************/

let displayLanguage = i18n.System.getDisplayLanguage('de', 'zh-Hans-CN'); // 德文
// language: 语言两字母代码，如"zh"，"de"，"fr"等
// locale: 本地化标识符，如"en-GB"、"en-US"、"zh-Hans-CN"等
// sentenceCase: 返回的语言名称是否需要首字母大写，默认值：true
let displayCountry = i18n.System.getDisplayCountry('SA', 'en-GB'); // Saudi Arabia
// country: 国家/地区两字母代码，如"CN"、"DE"、"SA"等
// locale: 本地化标识符，如"en-GB"、"en-US"、"zh-Hans-CN"等
// sentenceCase: 返回的国家/地区名称是否需要首字母大写，默认值：true

/**********************************
 * 本地化时区名称开发步骤
 **********************************/

let timezone = i18n.getTimeZone('America/Sao_Paulo');
let timeZoneName = timezone.getDisplayName('zh-Hans', true); // 巴西利亚标准时间

const expectedDisplayLanguage = resourceToString($r('app.string.ExpectedDisplayLanguage'));
const expectedDisplayCountry = 'Saudi Arabia';
const expectedTimeZoneName = [resourceToString($r('app.string.ExpectedTimeZoneName'))];

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .margin({ top: 20, left: 20, right: 20 });
}

@Entry
@Component
struct NameLocalization {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.NameLocalization') })
      Text($r('app.string.ResultsOfLanguageRegion'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(displayLanguage, expectedDisplayLanguage, $r('app.string.DisplayLanguage')))
        .textStyle()
      Text(assertEqual(displayCountry, expectedDisplayCountry, $r('app.string.DisplayCountry')))
        .textStyle()
      Text($r('app.string.ResultsOfDisplayTimezone'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqualFuzzy(timeZoneName, expectedTimeZoneName, $r('app.string.ResultOfTimezoneName')))
        .textStyle()
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}