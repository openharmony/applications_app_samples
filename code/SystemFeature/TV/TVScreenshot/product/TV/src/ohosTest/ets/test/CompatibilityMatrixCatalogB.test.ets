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
 
import { describe, it, expect } from '@ohos/hypium'

interface CompatibilityScenario {
  id: string
  resolution: string
  dpi: string
  locale: string
}

const COMPATIBILITY_MATRIX_CATALOG_B: CompatibilityScenario[] = [
  {
    id: 'matrix_0261',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0262',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0263',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0264',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0265',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0266',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0267',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0268',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0269',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0270',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0271',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0272',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0273',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0274',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0275',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0276',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0277',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0278',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0279',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0280',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0281',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0282',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0283',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0284',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0285',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0286',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0287',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0288',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0289',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0290',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0291',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0292',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0293',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0294',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0295',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0296',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0297',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0298',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0299',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0300',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0301',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0302',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0303',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0304',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0305',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0306',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0307',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0308',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0309',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0310',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0311',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0312',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0313',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0314',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0315',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0316',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0317',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0318',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0319',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0320',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0321',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0322',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0323',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0324',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0325',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0326',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0327',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0328',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0329',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0330',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0331',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0332',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0333',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0334',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0335',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0336',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0337',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0338',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0339',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0340',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0341',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0342',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0343',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0344',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0345',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0346',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0347',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0348',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0349',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0350',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0351',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0352',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0353',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0354',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0355',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0356',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0357',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0358',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0359',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0360',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0361',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0362',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0363',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0364',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0365',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0366',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0367',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0368',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0369',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0370',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0371',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0372',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0373',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0374',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0375',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0376',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0377',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0378',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0379',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0380',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0381',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0382',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0383',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0384',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0385',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0386',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0387',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0388',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0389',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0390',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0391',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0392',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0393',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0394',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0395',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0396',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0397',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0398',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0399',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0400',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0401',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0402',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0403',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0404',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0405',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0406',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0407',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0408',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0409',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0410',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0411',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0412',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0413',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0414',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0415',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0416',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0417',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0418',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0419',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0420',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0421',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0422',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0423',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0424',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0425',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0426',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0427',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0428',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0429',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0430',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0431',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0432',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0433',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0434',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0435',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0436',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0437',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0438',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0439',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0440',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0441',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0442',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0443',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0444',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0445',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0446',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0447',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0448',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0449',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0450',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0451',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0452',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0453',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0454',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0455',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0456',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0457',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0458',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0459',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0460',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0461',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0462',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0463',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0464',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0465',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0466',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0467',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0468',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0469',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0470',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0471',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0472',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0473',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0474',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0475',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0476',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0477',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0478',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0479',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0480',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0481',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0482',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0483',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0484',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0485',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0486',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0487',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0488',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0489',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0490',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0491',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0492',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0493',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0494',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0495',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0496',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0497',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0498',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0499',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0500',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0501',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0502',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0503',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0504',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0505',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0506',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0507',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0508',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0509',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0510',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0511',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0512',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0513',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0514',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0515',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0516',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0517',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0518',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0519',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0520',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  }
]

export default function compatibilityMatrixCatalogBTest() {
  describe('CompatibilityMatrixCatalogBTest', () => {
    it('compatibility_matrix_catalog_b_count_001', 0, () => {
      expect(COMPATIBILITY_MATRIX_CATALOG_B.length).assertEqual(260)
      expect(COMPATIBILITY_MATRIX_CATALOG_B[0].id.length).assertLarger(0)
      expect(COMPATIBILITY_MATRIX_CATALOG_B[259].resolution.includes('x')).assertTrue()
      expect(COMPATIBILITY_MATRIX_CATALOG_B[1].dpi.length).assertLarger(0)
      expect(COMPATIBILITY_MATRIX_CATALOG_B[2].locale.includes('-')).assertTrue()
    })
  })
}
