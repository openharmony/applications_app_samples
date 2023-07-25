/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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
import hilog from '@ohos.hilog';
/**
 * 格式化JSON数据
 * @param jsonObj 需要转换的数据
 */
const TAG: string = '[Sample_DeviceManagement]';
const DOMAIN : number = 0xFF00;
function transitionJsonToString(jsonObj: string): string {
  // 转换后的jsonObj受体对象
  let _jsonObj: string = null;
  // 判断传入的jsonObj对象是不是字符串，如果是字符串需要先转换为对象，再转换为字符串，这样做是为了保证转换后的字符串为双引号
  if (Object.prototype.toString.call(jsonObj) !== '[object String]') {
    try {
      _jsonObj = JSON.stringify(jsonObj);
    } catch (error) {
      // 转换失败错误信息
      errorLog(JSON.stringify(error));
    }
  } else {
    try {
      jsonObj = jsonObj.replace(/(\')/g, '"');
      _jsonObj = JSON.stringify(JSON.parse(jsonObj));
    } catch (error) {
      // 转换失败错误信息
      errorLog(JSON.stringify(error));
    }
  }
  return _jsonObj;
}

function errorLog(...args: string[]): void {
  hilog.error(DOMAIN, TAG, '%{public}s', args);
}

/**
 * 格式化JSON数据
 * @param jsonObj 需要转换的数据
 */
export function formatJson(jsonObj: string): string {
  let formatted: string = '';
  // 换行缩进位数
  let pad: number = 2;
  // 一个tab对应空格位数
  let PADDING: string = '\t';
  // json对象转换为字符串变量
  let jsonString: string = transitionJsonToString(jsonObj);
  if (!jsonString) {
    return jsonString;
  }
  // 将jsonString字符串内容通过\r\n符分割成数组
  let jsonArray: Array<string> = [];
  // 正则匹配到{,}符号则在两边添加回车换行
  jsonString = jsonString.replace(/([\{\}])/g, '\r\n$1\r\n');
  // 正则匹配到[,]符号则在两边添加回车换行
  jsonString = jsonString.replace(/([\[\]])/g, '\r\n$1\r\n');
  // 正则匹配到,符号则在两边添加回车换行
  jsonString = jsonString.replace(/(\,)/g, '$1\r\n');
  // 正则匹配到要超过一行的换行需要改为一行
  jsonString = jsonString.replace(/(\r\n\r\n)/g, '\r\n');
  // 正则匹配到单独处于一行的,符号时需要去掉换行，将,置于同行
  jsonString = jsonString.replace(/\r\n\,/g, ',');
  // 特殊处理双引号中的内容
  jsonArray = jsonString.split('\r\n');
  // 将处理后的数组通过\r\n连接符重组为字符串
  jsonString = jsonArray.join('\r\n');
  // 将匹配到:后为回车换行加大括号替换为冒号加大括号
  jsonString = jsonString.replace(/\:\r\n\{/g, ':{');
  // 将匹配到:后为回车换行加中括号替换为冒号加中括号
  jsonString = jsonString.replace(/\:\r\n\[/g, ':[');
  // 将上述转换后的字符串再次以\r\n分割成数组
  jsonArray = jsonString.split('\r\n');
  // 将转换完成的字符串根据PADDING值来组合成最终的形态
  jsonArray.forEach(function (item, index) {
    let i: number = 0;
    // 表示缩进的位数，以tab作为计数单位
    let indent: number = 0;
    // 表示缩进的位数，以空格作为计数单位
    let padding: string = '';
    if (item.match(/\{$/) || item.match(/\[$/)) {
      // 匹配到以{和[结尾的时候indent加1
      indent += 1;
    } else if (item.match(/\}$/) || item.match(/\]$/) || item.match(/\},$/) || item.match(/\],$/)) {
      // 匹配到以}和]结尾的时候indent减1
      if (pad !== 0) {
        pad -= 1;
      }
    } else {
      indent = 0;
    }
    for (i = 0; i < pad; i++) {
      padding += PADDING;
    }
    formatted += padding + item + '\r\n';
    pad += indent;
  });
  // 返回的数据需要去除两边的空格和换行
  return formatted.trim().replace(new RegExp('^\\' + '<br />' + '+|\\' + '<br />' + '+$', 'g'), '');
}