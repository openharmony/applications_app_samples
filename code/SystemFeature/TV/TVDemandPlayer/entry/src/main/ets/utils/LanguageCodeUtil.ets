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
// 语言代码映射表
const LANGUAGE_MAP: Record<string, string> = {
  // 汉语及其变体
  'CHI': '汉语',
  'ZH': '汉语',
  'ZHO': '汉语',
  'ZH-CN': '汉语(简体)',
  'ZH-HANS': '汉语(简体)',
  'ZH-TW': '汉语(繁体)',
  'ZH-HANT': '汉语(繁体)',
  'ZH-HK': '汉语(香港)',
  'ZH-SG': '汉语(新加坡)',
  'ZH-MO': '汉语(澳门)',

  // 英语及其变体
  'ENG': '英语',
  'EN': '英语',
  'EN-US': '英语(美国)',
  'EN-GB': '英语(英国)',
  'EN-AU': '英语(澳大利亚)',
  'EN-CA': '英语(加拿大)',

  // 其他主要语言
  'JPN': '日语', 'JA': '日语',
  'KOR': '韩语', 'KO': '韩语',
  'FRA': '法语', 'FR': '法语', 'FR-CA': '法语(加拿大)',
  'DEU': '德语', 'DE': '德语',
  'SPA': '西班牙语', 'ES': '西班牙语', 'ES-419': '西班牙语(拉丁美洲)',
  'RUS': '俄语', 'RU': '俄语',
  'ITA': '意大利语', 'IT': '意大利语',
  'POR': '葡萄牙语', 'PT': '葡萄牙语', 'PT-BR': '葡萄牙语(巴西)',
  'ARA': '阿拉伯语', 'AR': '阿拉伯语',
  'HIN': '印地语', 'HI': '印地语',
  'NLD': '荷兰语', 'NL': '荷兰语',
  'POL': '波兰语', 'PL': '波兰语',
  'TUR': '土耳其语', 'TR': '土耳其语',
  'THA': '泰语', 'TH': '泰语',
  'VIE': '越南语', 'VI': '越南语',
  'IND': '印尼语', 'ID': '印尼语',
  'CES': '捷克语', 'CS': '捷克语',
  'SWE': '瑞典语', 'SV': '瑞典语',
  'FIN': '芬兰语', 'FI': '芬兰语',
  'DAN': '丹麦语', 'DA': '丹麦语',
  'NOR': '挪威语', 'NO': '挪威语', 'NB': '挪威语(博克马尔)', 'NN': '挪威语(尼诺斯克)',
  'UKR': '乌克兰语', 'UK': '乌克兰语',
  'GRE': '希腊语', 'EL': '希腊语',
  'HUN': '匈牙利语', 'HU': '匈牙利语',
  'RON': '罗马尼亚语', 'RO': '罗马尼亚语',
  'SLK': '斯洛伐克语', 'SK': '斯洛伐克语',
  'BUL': '保加利亚语', 'BG': '保加利亚语',
  'HRV': '克罗地亚语', 'HR': '克罗地亚语',
  'SRP': '塞尔维亚语', 'SR': '塞尔维亚语',
  'HEB': '希伯来语', 'HE': '希伯来语',
  'PER': '波斯语', 'FA': '波斯语',
  'MAY': '马来语', 'MS': '马来语',
  'FIL': '菲律宾语', 'TL': '菲律宾语',
  'SWA': '斯瓦希里语', 'SW': '斯瓦希里语',
  'BEN': '孟加拉语', 'BN': '孟加拉语',
  'TAM': '泰米尔语', 'TA': '泰米尔语',
  'TEL': '泰卢固语', 'TE': '泰卢固语',
  'URD': '乌尔都语', 'UR': '乌尔都语',

  // 特殊语言或方言
  'YUE': '粤语', 'YU': '粤语',
  'WUU': '吴语', 'WU': '吴语',
  'HAK': '客家语',
  'NAN': '闽南语',

  // 其他语言
  'CAT': '加泰罗尼亚语', 'CA': '加泰罗尼亚语',
  'EUS': '巴斯克语', 'EU': '巴斯克语',
  'GLG': '加利西亚语', 'GL': '加利西亚语',
  'WEL': '威尔士语', 'CY': '威尔士语',
  'GAE': '苏格兰盖尔语', 'GD': '苏格兰盖尔语',
  'MAO': '毛利语', 'MI': '毛利语',
  'HAW': '夏威夷语',

  // 未知
  'UND': '未知',
  '': '未知'
};

/**
 * 将语言代码转换为中文名称
 * @param {string} code - 语言代码 (如 'CHI', 'zh-CN', 'en')
 */
export function getLanguageName(code: string): string {
  // 匹配
  const upperCode = code.toUpperCase();
  if (LANGUAGE_MAP[upperCode]) {
    return LANGUAGE_MAP[upperCode];
  }

  // 未找到匹配，直接返回原数据值
  return code;
}

export function languageToCode(languageName: string): string {
  const entries = Object.entries(LANGUAGE_MAP);
  for (let i = 0; i < entries.length; i++) {
    const entry = entries[i];
    if (entry[1] === languageName) {
      return entry[0];
    }
  }
  return languageName;
}

export function codeToLanguage(code: string): string {
  return getLanguageName(code);
}
