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
import { i18n } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End import_module]

/**********************************************************************************************************************
 * 字符属性开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 判断字符属性
 *  let isDigit: boolean = i18n.Unicode.isDigit(char: string);
 * 3. 以一般类别值为例，判断字符类类型，具体请参考getType接口文档
 *  let type = i18n.Unicode.getType(char: string);
 *********************************************************************************************************************/

// [Start identify_character_type]
// 判断字符是否是数字
let isDigit = i18n.Unicode.isDigit('1'); // isDigit = true

// 判断字符是否是从右到左语言的字符
let isRTL = i18n.Unicode.isRTL('a'); // isRTL = false

// 判断字符是否是表意文字
let isIdeograph = i18n.Unicode.isIdeograph('华'); // isIdeograph = true

// 获取字符的一般类别值
let unicodeType = i18n.Unicode.getType('a'); // unicodeType = 'U_LOWERCASE_LETTER'
// [End identify_character_type]

/**********************************************************************************************************************
 * 音译开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 创建Transliterator对象，获取音译列表
 *  // 传入音译支持的ID，创建Transliterator对象
 *  let transliterator: i18n.Transliterator = i18n.Transliterator.getInstance(id: string);
 *  let ids: string[] = i18n.Transliterator.getAvailableIDs(); // 获取音译支持的ID列表
 * 3. 音译文本
 *  let res: string = transliterator.transform(text: string); // 对text内容进行音译
 *********************************************************************************************************************/

// [Start get_transliteration]
// 音译成Latn格式
let transliterator: i18n.Transliterator = i18n.Transliterator.getInstance('Any-Latn');
let translatedText = transliterator.transform('中国'); // translatedText = 'zhōng guó'

// 汉语音译去声调
let toneLessTransliterator: i18n.Transliterator = i18n.Transliterator.getInstance('Any-Latn;Latin-Ascii');
let toneLessTranslatedText = toneLessTransliterator.transform('中国'); // toneLessTranslatedText = 'zhong guo'

// 汉语姓氏读音
let nameTransliterator: i18n.Transliterator = i18n.Transliterator.getInstance('Han-Latin/Names');
let nameTranslatedText = nameTransliterator.transform('单老师'); // nameTranslatedText = 'shàn lǎo shī'

// 获取音译支持的转换ID列表
let ids = i18n.Transliterator.getAvailableIDs(); // ids = ['ASCII-Latin', 'Accents-Any', ...]
// [End get_transliteration]

/**********************************************************************************************************************
 * 字符标准化开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 创建标准化对象
 *  let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(mode: NormalizerMode);
 * 3. 文本标准化
 *  let normalizedText: string = normalizer.normalize(text: string); // 对text文本进行标准化
 *********************************************************************************************************************/

// [Start character_normalization]
// 按照NFC范式对文本进行标准化处理
let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFC);
let normalizedText = normalizer.normalize('\u1E9B\u0323'); // normalizedText = 'ẛ̣'
// [End character_normalization]

/**********************************************************************************************************************
 * 断词换行开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 创建用于断句的对象
 *  let iterator: i18n.BreakIterator = i18n.getLineInstance(locale: string);
 * 3. 设置要处理的文本
 *  iterator.setLineBreakText(text: string); // 设置要处理的文本
 *  let breakText: string = iterator.getLineBreakText(); // 查看iterator正在处理的文本
 * 4. 获取可断句的位置
 *  // 获取iterator在当前所处理文本中的位置
 *  let currentPos: number = iterator.current();
 *  // 设置为第一个可断句的分割点，返回该分割点的位置。第一个分割点总是在文本的起始位置，firstPos = 0
 *  let firstPos: number = iterator.first();
 *  // 将iterator移动number数量个分割点，number为正数代表向后移动，number为负数代表向前移动，默认值为1。
 *  // nextPos为移动后在文本中的位置，如果超出文本的长度范围，返回-1
 *  let nextPos: number = iterator.next(number);
 *  // 判断number位置是否是分割点
 *  let isBoundary: boolean = iterator.isBoundary(number);
 *********************************************************************************************************************/

// [Start set_text_line_break_settings]
// 创建获取文本可换行点的对象，该对象将按照指定区域的规则计算文本中的可换行点的位置
let iterator: i18n.BreakIterator  = i18n.getLineInstance('en-GB');

// 设置处理文本
iterator.setLineBreakText('Apple is my favorite fruit.');

// 将换行迭代器移动到文本起始位置
let firstPos = iterator.first(); // firstPos = 0

// 将换行迭代器向后移动2个可换行点，nextPos为移动后在文本中的位置，如果超出文本的长度范围，返回-1
let nextPos = iterator.next(2); // nextPos = 9

// 获取换行迭代器在当前所处理文本中的位置
let currentPos = iterator.current(); // currentPos = 9

// 判断某个位置是否是可换行点
let isBoundary = iterator.isBoundary(9); // isBoundary = true

// 获取BreakIterator对象处理的文本
let breakText = iterator.getLineBreakText(); // breakText = 'Apple is my favorite fruit.'
// [End set_text_line_break_settings]

/**********************************************************************************************************************
 * 文件路径镜像处理开发步骤参考
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 文件路径镜像处理
 *  let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath(path: string, delimiter?: string, locale?: Intl.Locale);
 *********************************************************************************************************************/

// [Start get_unicode_wrapped_file_path]
let mirrorPath = '';
let unMirrorPath = '';

// 传入镜像语言，对路径进行镜像处理
let path = 'data/out/tmp';

try {
  let delimiter = '/';
  let locale: Intl.Locale = new Intl.Locale('ar');
  // mirrorPath = 'tmp/out/data/'
  mirrorPath = i18n.I18NUtil.getUnicodeWrappedFilePath(path, delimiter, locale);

  // 传入非镜像语言，不处理路径
  let localeZh: Intl.Locale = new Intl.Locale('zh');
  // unMirrorPath = '/data/out/tmp'
  unMirrorPath = i18n.I18NUtil.getUnicodeWrappedFilePath(path, delimiter, localeZh);
} catch (error) {
  console.error(`call I18NUtil.getUnicodeWrappedFilePath failed, error code: ${error.code}, message: ${error.message}.`);
}
// [End get_unicode_wrapped_file_path]

const expectedIsDigit = true;
const expectedIsRTL = false;
const expectedIsIdeograph = true;
const expectedType = 'U_LOWERCASE_LETTER';
const expectedTransResult = 'zhōng guó';
const expectedToneTranslatedText = 'zhong guo';
const expectedNameTranslatedText = 'shàn lǎo shī';
const expectedIds = ['ASCII-Latin', 'Accents-Any'];
const expectedNormalizedText = 'ẛ̣';
const expectedFirstPos = 0;
const expectedNextPos = 9;
const expectedIsBoundary = true;
const expectedBreakText = 'Apple is my favorite fruit.';

@Extend(Text)
function textStyle() {
  .fontSize(18)
  .margin({ top: 15, left: 20, right: 20 });
}

@Entry
@Component
export default struct CharacterProcessing {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.CharacterProcessing') })
      Scroll() {
        Column() {
          Text($r('app.string.ResultsOfCharacterType'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text(assertEqual(isDigit, expectedIsDigit, $r('app.string.Character1IsNumber')))
            .textStyle()
          Text(assertEqual(isRTL, expectedIsRTL, $r('app.string.AIsRightToLeft')))
            .textStyle()
          Text(assertEqual(isIdeograph, expectedIsIdeograph, $r('app.string.HuaIsIdeograph')))
            .textStyle()
          Text(assertEqual(unicodeType, expectedType, $r('app.string.AGetType')))
            .textStyle()
          Text($r('app.string.ResultsOfTrans'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text(assertEqual(translatedText, expectedTransResult, $r('app.string.CharacterTransResult')))
            .textStyle()
          Text(assertEqual(toneLessTranslatedText, expectedToneTranslatedText, $r('app.string.ChinaTrans')))
            .textStyle()
          Text(assertEqual(nameTranslatedText, expectedNameTranslatedText, $r('app.string.TeachersSurnameTrans')))
            .textStyle()
          Text(assertEqualLong(ids.join(', '), expectedIds, $r('app.string.ResultsOfSupportedId')))
            .textStyle()
          Scroll() {
            Text(ids.join(', '))
              .textStyle()
              .id('transIdsText')
          }
          .id('transIdsScroll')
          .margin({ left: 50 })
          .border({
            width: 2,
            color: $r('app.color.Border_Gray'),
            style: BorderStyle.Solid,
            radius: 10
          })
          .width('80%')
          .height('20%')

          Text($r('app.string.ResultsOfNormalize'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text(assertEqual(normalizedText, expectedNormalizedText, $r('app.string.NFCNormalizeResult')))
            .textStyle()
          Text($r('app.string.ResultsOfBreakIterator'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text(assertEqual(firstPos, expectedFirstPos, $r('app.string.FirstPos')))
            .textStyle()
          Text(assertEqual(nextPos, expectedNextPos, $r('app.string.NextPos')))
            .textStyle()
          Text(assertEqual(isBoundary, expectedIsBoundary, $r('app.string.IsBoundary')))
            .textStyle()
          Text(assertEqual(breakText, expectedBreakText, $r('app.string.BreakText')))
            .textStyle()
          Text($r('app.string.ResultsOfMirror'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text($r('app.string.originPath'))
            .textStyle()
          Text(path)
            .textStyle()
          Text($r('app.string.MirrorLanguage'))
            .textStyle()
          Text(mirrorPath)
            .textStyle()
          Text($r('app.string.UnMirrorLanguage'))
            .textStyle()
          Text(unMirrorPath)
            .textStyle()
          Blank().height('10%')
        }
        .alignItems(HorizontalAlign.Start)
      }
      .id('outerScrollInCharacter')
      .width('100%')
      .height('100%')
    }
  }
}