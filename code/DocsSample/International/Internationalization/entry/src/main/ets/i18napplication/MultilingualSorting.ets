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
// [Start import_module]
import { i18n, intl } from '@kit.LocalizationKit';
// [End import_module]

/**********************************************************************************************************************
 * 创建索引开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 创建对象
 *  let indexUtil = i18n.getInstance(locale?:string);  // locale 表示本地化标识符，默认值是系统当前locale
 * 3. 以获取索引列表为例
 *  let indexList = indexUtil.getIndexList();
 *********************************************************************************************************************/
// [Start create_index]
// 创建索引开发实例
// 创建索引
let indexUtil: i18n.IndexUtil = i18n.getInstance('zh-CN');
let indexList = indexUtil.getIndexList(); // indexList = ['…', 'A', 'B', 'C', ... 'X', 'Y', 'Z', '…']

// 多语言index混排
indexUtil.addLocale('ru-RU');
// indexList = ['…', 'A', 'B', 'C', ... 'X', 'Y', 'Z', '…', 'А', 'Б', 'В', ... 'Э', 'Ю', 'Я', '…']
indexList = indexUtil.getIndexList();

// 获取字符串的索引值
let index = indexUtil.getIndex('你好'); // index = 'N'
// [End create_index]

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
      Text($r('app.string.ResultsOfCreateIndex'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqualLong(indexList.join(','), expectedIndexList, $r('app.string.ResultOfIndexList')))
        .textStyle();
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Text(indexList.join(','))
          .textStyle()
      }.direction(Direction.Ltr)

      Text(assertEqual(index, expectedIndex,
        $r('app.string.ResultOfIndex')))
        .textStyle()
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}