/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start test_safeAsyncCall]
  // [StartExclude test_safeAsyncCall]
import { errorManager } from '@kit.AbilityKit';
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

// 方舟正则运算对于\b处理与预期不一致。
function testWordBoundaryInArkRegex() {
  // [Start test_wordBoundaryInArkRegex]
  let str = '\u2642';
  let res = str.replace(/\b/g, '/');
  console.info('res = ' + res);
  // 期望输出: res = ♂。
  // 实际输出: res = /♂/。
  // [End test_wordBoundaryInArkRegex]

  let logMsg = 'res = ' + res;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// 方舟正则运算对于先行断言((?=pattern)或(?!pattern)) 嵌套在后行断言((?<=pattern)或(?<!pattern))内部的场景与预期不一致。
function testLookbehindWithNestedLookahead() {
  // [Start test_lookbehindWithNestedLookahead]
  console.info(`res:${'abcdef'.match(/(?<=ab(?=c)cd)ef/)}`);
  // 期望输出: res:ef。
  // 实际输出: res:null。
  // [End test_lookbehindWithNestedLookahead]

  let logMsg = `res:${'abcdef'.match(/(?<=ab(?=c)cd)ef/)}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// 方舟正则运算对于大小写的处理与预期不一致。
function testRegexIgnoreCaseCaseFolding() {
  // [Start test_regexIgnoreCaseCaseFolding]
  let res = /\u{10400}/ui.test('\u{10428}');
  console.info('res = ' + res);
  // 期望输出: res = true。
  // 实际输出: res = false。
  // [End test_regexIgnoreCaseCaseFolding]

  let logMsg = 'res = ' + res;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// 方舟正则运算/()/ug匹配时lastIndex与预期不一致。
function testRegexLastIndexWithEmptyGroupInGlobalUnicodeMode() {
  // [Start test_regexLastIndexWithEmptyGroupInGlobalUnicodeMode]
  let L = '\ud800';
  let T = '\udc00';
  let u = /()/ug;
  u.lastIndex = 1;
  u.exec(L + T + L + T);
  console.info('u.lastIndex = ' + u.lastIndex);
  // 期望输出: u.lastIndex = 0。
  // 实际输出: u.lastIndex = 1。
  // [End test_regexLastIndexWithEmptyGroupInGlobalUnicodeMode]

  let logMsg = 'u.lastIndex = ' + u.lastIndex;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// 方舟正则运算[]内部使用'-'与预期不一致。
function testRegexHyphenInCharacterClass() {
  // [Start test_beforeRegexHyphenInCharacterClass]
  let str = 'a-b';
  let reg = /[+-\s]/;
  console.info('reg.exec(str) = ' + reg.exec(str));
  // 期望输出: reg.exec(str) = -。
  // 实际输出: reg.exec(str) = null。
  // [End test_beforeRegexHyphenInCharacterClass]

  let logMsg = 'before reg.exec(str) = ' + reg.exec(str) + '\n';

  {
    // 规避方案：使用转义后的'-'。
    // [Start test_afterRegexHyphenInCharacterClass]
    let str = 'a-b';
    let reg = /[+\-\s]/;
    console.info('reg.exec(str) = ' + reg.exec(str));
    // [End test_afterRegexHyphenInCharacterClass]

    logMsg += 'after reg.exec(str) = ' + reg.exec(str);
  }

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// 方舟正则运算具名捕获组获取与预期不一致。
function testNamedCaptureGroupAccess() {
  // [Start test_namedCaptureGroupAccess]
  let reg = new RegExp('(a)(?<b>b)');
  let res = reg.exec('ab');
  console.info('JSON.stringify(res?.groups) = ' + JSON.stringify(res?.groups));
  // 期望输出: JSON.stringify(res?.groups) = {'b':'b'}。
  // 实际输出: JSON.stringify(res?.groups) = {'b':'a'}。
  // [End test_namedCaptureGroupAccess]

  let logMsg = 'JSON.stringify(res?.groups) = ' + JSON.stringify(res?.groups);
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// 规避方案：计算具名捕获组位置获取具名捕获组匹配的内容。
function testGetNamedGroupMatchByIndexFallback() {
  // [Start test_getNamedGroupMatchByIndexFallback]
  let reg = new RegExp('(a)(?<b>b)');
  let res = reg.exec('ab') as Array<string>;
  console.info('JSON.stringify(res?.groups) = {\'b\':' + JSON.stringify(res[2]) + '}');
  // [End test_getNamedGroupMatchByIndexFallback]

  let logMsg = 'JSON.stringify(res?.groups) = {\'b\':' + JSON.stringify(res[2]) + '}';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// 方舟正则匹配使用'|'与预期不一致。
function testRegexAlternationOperator() {
  // [Start test_beforeRegexAlternationOperator]
  let reg = /a(?:|x)$/;
  let res = reg.exec('ax');
  console.info('JSON.stringify(res) = ' + JSON.stringify(res));
  // 期望输出: JSON.stringify(res) = ['ax']。
  // 实际输出: JSON.stringify(res) = null。
  // [End test_beforeRegexAlternationOperator]

  // 规避方案：使用reg2或reg3替换reg1。
  // [Start test_afterRegexAlternationOperator]
  let reg1 = /a(?:|x)$/;
  let reg2 = /a(?:x)?$/;
  let reg3 = /a(?:x){0,1}$/;
  // [End test_afterRegexAlternationOperator]
  let res1 = reg1.exec('ax');
  let res2 = reg2.exec('ax');
  let res3 = reg3.exec('ax');
  console.info('JSON.stringify(res1) = ' + JSON.stringify(res1));
  console.info('JSON.stringify(res2) = ' + JSON.stringify(res2));
  console.info('JSON.stringify(res3) = ' + JSON.stringify(res3));

  let logMsg = 'JSON.stringify(res) = ' + JSON.stringify(res) + '\nJSON.stringify(reg1) = ' +
  JSON.stringify(reg1) + '\nJSON.stringify(res2) = ' +
  JSON.stringify(res2) + '\nJSON.stringify(res3) = ' + JSON.stringify(res3);
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// 方舟字符串 replace 接口对于第一个参数为空字符串的场景与预期不一致。
function testStringReplaceWithEmptySearchValue() {
  // [Start test_beforeStringReplaceWithEmptySearchValue]
  let str = 'dddd';
  let res = str.replace('', 'abc');
  console.info('res = ' + res);
  // 期望输出: res = abcdddd。
  // 实际输出: res = dddd。
  // [End test_beforeStringReplaceWithEmptySearchValue]
  let logMsg = 'res = ' + res + '\n';

  // 规避方案：使用正则表达式 /^/ 表示字符串起始符，作为第一个参数。
  {
    // [Start test_afterStringReplaceWithEmptySearchValue]
    let str = 'dddd';
    let res = str.replace(/^/, 'abc');
    // [End test_afterStringReplaceWithEmptySearchValue]

    console.info('res1 = ' + res);
    logMsg += 'res1 = ' + res;
  }

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// Async函数内部异常的捕获方式。
function testSafeAsyncCall() {
  // [EndExclude test_safeAsyncCall]
  errorManager.on('unhandledRejection', (a:ESObject, b:Promise<ESObject>) => {
    console.info('Async test', a);
    // [StartExclude test_safeAsyncCall]
    let logMsg = 'Async test ' + a;
    if (globalLogUpdate) {
      globalLogUpdate(logMsg, false);
    }
    // [EndExclude test_safeAsyncCall]
  })
  // [End test_safeAsyncCall]
}

async function foo() {
  throw new Error('new error message');
}

interface ProxyHandler<T> {}
// 方舟Array.flatMap()接口常见问题。
function testArrayFlatMapCompliance() {
  // [Start test_arrayFlatMapCompliance]
  let arr1 = [0, 1];
  let arr2 = [2, 3];
  const emptyHandler = {} as ProxyHandler<number[]>;
  let proxy1 = new Proxy(arr1, emptyHandler);
  let proxy2 = new Proxy(arr2, emptyHandler);
  let arr3 = [proxy1, proxy2];
  let res = arr3.flatMap(x => x);

  console.info('res length:', res.length.toString());
  // 期望输出: res length: 4。
  // 实际输出: res length: 2。
  console.info('res[0] is: ', res[0].toString());
  // 期望输出: res[0] is: 0。
  // 实际输出: res[0] is: 0,1。
  // [End test_arrayFlatMapCompliance]

  let logMsg = 'res length: ' + res.length.toString() + '\nres[0] is:  ' + res[0].toString() + '\n';

  {
    // [Start test_afterArrayFlatMapCompliance]
    // 使用规避方案前。
    let res = arr3.flatMap(x => x);
    // [StartExclude test_afterArrayFlatMapCompliance]

    console.info('res1 length:', res.length.toString());
    console.info('res1[0] is: ', res[0].toString());

    logMsg += 'res1 length: ' + res.length.toString() + '\nres1[0] is:  ' + res[0].toString() + '\n';
  }
  {
    // [EndExclude test_afterArrayFlatMapCompliance]
    // 使用规避方案后。
    let res = arr3.map(x => x).flat();
    // [End test_afterArrayFlatMapCompliance]
    console.info('res2 length: ', res.length.toString());
    console.info('res2[0] is: ', res[0].toString());

    logMsg += 'res2 length: ' + res.length.toString() + '\nres2[0] is:  ' + res[0].toString() + '\n';
  }

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

@Entry
@Component
struct IndexArkTs {
  @State currentState: string | ResourceStr = $r('app.string.state_not_initialized');
  @State logMessages: string | ResourceStr = $r('app.string.log_no_info');

  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }

  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Text($r('app.string.real_time_status'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.current_state'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.currentState)
              .fontSize(14)
              .fontColor('#007DFF')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.log_info'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.logMessages)
                .fontSize(12)
                .fontColor('#52C41A')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 10 })
        }
        .width('100%')
        .padding(18)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 16 })

        Column() {
          Text($r('app.string.test_boundary_handling')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testWordBoundaryInArkRegex();
          this.currentState = $r('app.string.test_boundary_handling_complete');
        })

        Column() {
          Text($r('app.string.test_lookahead_lookbehind')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testLookbehindWithNestedLookahead();
          this.currentState = $r('app.string.test_lookahead_lookbehind_complete');
        })

        Column() {
          Text($r('app.string.test_ignore_case')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testRegexIgnoreCaseCaseFolding();
          this.currentState = $r('app.string.test_ignore_case_complete');
        })

        Column() {
          Text($r('app.string.test_last_index_empty_group')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testRegexLastIndexWithEmptyGroupInGlobalUnicodeMode();
          this.currentState = $r('app.string.test_last_index_empty_group_complete');
        })

        Column() {
          Text($r('app.string.test_hyphen_in_char_class')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testRegexHyphenInCharacterClass();
          this.currentState = $r('app.string.test_hyphen_in_char_class_complete');
        })

        Column() {
          Text($r('app.string.test_named_capture_group')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testNamedCaptureGroupAccess();
          this.currentState = $r('app.string.test_named_capture_group_complete');
        })

        Column() {
          Text($r('app.string.test_named_capture_group_fallback')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testGetNamedGroupMatchByIndexFallback();
          this.currentState = $r('app.string.test_named_capture_group_fallback_complete');
        })

        Column() {
          Text($r('app.string.test_regex_alternation')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testRegexAlternationOperator();
          this.currentState = $r('app.string.test_regex_alternation_complete');
        })

        Column() {
          Text($r('app.string.test_replace_empty_string')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testStringReplaceWithEmptySearchValue();
          this.currentState = $r('app.string.test_replace_empty_string_complete');
        })

        Column() {
          Text($r('app.string.test_async_error_catch')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          foo();
          testSafeAsyncCall();
          this.currentState = $r('app.string.test_async_error_catch_complete');
        })

        Column() {
          Text($r('app.string.test_array_flatmap')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testArrayFlatMapCompliance();
          this.currentState = $r('app.string.test_array_flatmap_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}