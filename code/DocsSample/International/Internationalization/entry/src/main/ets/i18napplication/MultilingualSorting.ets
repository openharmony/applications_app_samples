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
import { assertEqual, assertEqualLong } from '../component/AssertEqual';
import { resourceToString } from '../component/ResourceToString';
import { i18n, intl } from '@kit.LocalizationKit';

/**********************************************************************************************************************
 * 本地习惯排序开发参考步骤
 * 1. 导入模块
 *  import { intl } from '@kit.LocalizationKit';
 * 2. 创建collator排序对象
 *  let collator = new intl.Collator(locale: string | Array<string>, options?: CollatorOptions);
 * 3. 比较字符串
 *  let compareResult = collator.compare(first: string, second: string);
 *  // compareResult 为负数，表示第一个参数排在第二个参数之前
 *  // compareResult 为0，表示第一个参数与第二个参数排序不分先后
 *  // compareResult 为正数，表示第一个参数排在第二个参数之后
 *********************************************************************************************************************/

// 创建排序对象
let options: intl.CollatorOptions = {
  localeMatcher: 'lookup',
  usage: 'sort',
  sensitivity: 'case' // 区分大小写
};
let collator = new intl.Collator('zh-CN', options);

// 区分大小写排序
let enArray = ['app', 'App', 'Apple', 'ANIMAL', 'animal', 'apple', 'APPLE'];
enArray.sort((a, b) => {
  return collator.compare(a, b);
})
console.log('result: ', enArray); // animal ANIMAL app App apple Apple APPLE

// 中文拼音排序
let zhArray = [resourceToString($r('app.string.Apple')), resourceToString($r('app.string.Pear')),
  resourceToString($r('app.string.Banana')), resourceToString($r('app.string.Pomegranate')),
  resourceToString($r('app.string.Sugarcane')), resourceToString($r('app.string.Grapes')),
  resourceToString($r('app.string.Orange'))];
zhArray.sort((a, b) => {
  return collator.compare(a, b);
})
console.log('result: ', zhArray); // 甘蔗,橘子,梨,苹果,葡萄,石榴,香蕉

// 按笔画排序
options = {
  localeMatcher: 'lookup',
  usage: 'sort',
  collation: 'stroke'
};
collator = new intl.Collator('zh-CN', options);
let zhStrokeArray = [resourceToString($r('app.string.Apple')), resourceToString($r('app.string.Pear')),
  resourceToString($r('app.string.Banana')), resourceToString($r('app.string.Pomegranate')),
  resourceToString($r('app.string.Sugarcane')), resourceToString($r('app.string.Grapes')),
  resourceToString($r('app.string.Orange'))];
zhStrokeArray.sort((a, b) => {
  return collator.compare(a, b);
})
console.log('result: ', zhStrokeArray); // 甘蔗,石榴,苹果,香蕉,梨,葡萄,橘子

// 搜索匹配的字符串
options = {
  usage: 'search',
  sensitivity: 'base'
};
collator = new intl.Collator('tr', options);
let sourceArray = ['Türkiye', 'TüRkiye', 'salt', 'bright'];
let s = 'türkiye';
let matches = sourceArray.filter(item => collator.compare(item, s) === 0);
console.log(matches.toString()); // Türkiye,TüRkiye

/**********************************************************************************************************************
 * 创建索引开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 创建对象
 *  let indexUtil = i18n.getInstance(locale?:string);  // locale 表示本地化标识符，默认值是系统当前locale
 * 3. 以获取索引列表为例
 *  let indexList = indexUtil.getIndexList();
 *********************************************************************************************************************/

// 创建索引开发实例
// 创建索引
let indexUtil = i18n.getInstance('zh-CN');
let indexList = indexUtil.getIndexList(); // ['...', 'A', 'B', 'C', 'D', 'E' ... 'X', 'Y', 'Z', '...']
// 多语言index混排
indexUtil.addLocale('ru-RU');
// …,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,…,А,Б,В,Г,Д,Е,Ж,З,И,Й,К,Л,М,Н,О,П,Р,С,Т,У,Ф,Х,Ц,Ч,Ш,Щ,Ы,Э,Ю,Я,…
indexList = indexUtil.getIndexList();
indexUtil.getIndex(resourceToString($r('app.string.NiHao'))); // N

const expectedEnglishSort = 'animal ANIMAL app App apple Apple APPLE';
const expectedChineseSort = resourceToString($r('app.string.ExpectedChineseSort'));
const expectedChineseStrokeSort = resourceToString($r('app.string.ExpectedChineseStrokeSort'));
const expectedMatchResult = 'Türkiye,TüRkiye';
const expectedIndexList = ['…', 'A', 'B', 'C', 'Б', 'Г', 'Д', 'Ю', 'Я', '…'];
const expectedIndex = 'N';

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .margin({ top: 20, left: 20, right: 20 });
}

@Entry
@Component
struct MultilingualSorting {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.MultilingualSorting') })
      Text($r('app.string.ResultsOfLocalSort'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(enArray.join(' '), expectedEnglishSort, $r('app.string.ResultOfEnglishSort')))
        .textStyle()
      Text(assertEqual(zhArray.join(','), expectedChineseSort, $r('app.string.ResultOfChineseSort')))
        .textStyle()
      Text(assertEqual(zhStrokeArray.join(','), expectedChineseStrokeSort, $r('app.string.ResultOfChineseStrokeSort')))
        .textStyle()
      Text(assertEqual(matches.toString(), expectedMatchResult, $r('app.string.ResultOfSearchMatch')))
        .textStyle()
      Text($r('app.string.ResultsOfCreateIndex'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqualLong(indexList.join(','), expectedIndexList, $r('app.string.ResultOfIndexList')))
        .textStyle();
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Text(indexList.join(','))
          .textStyle()
      }.direction(Direction.Ltr)

      Text(assertEqual(indexUtil.getIndex(resourceToString($r('app.string.NiHao'))), expectedIndex,
        $r('app.string.ResultOfIndex')))
        .textStyle()
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}