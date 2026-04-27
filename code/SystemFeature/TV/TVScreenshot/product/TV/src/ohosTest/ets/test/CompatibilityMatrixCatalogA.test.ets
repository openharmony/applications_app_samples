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

const COMPATIBILITY_MATRIX_CATALOG_A: CompatibilityScenario[] = [
  {
    id: 'matrix_0001',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0002',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0003',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0004',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0005',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0006',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0007',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0008',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0009',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0010',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0011',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0012',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0013',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0014',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0015',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0016',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0017',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0018',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0019',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0020',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0021',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0022',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0023',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0024',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0025',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0026',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0027',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0028',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0029',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0030',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0031',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0032',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0033',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0034',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0035',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0036',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0037',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0038',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0039',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0040',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0041',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0042',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0043',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0044',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0045',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0046',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0047',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0048',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0049',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0050',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0051',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0052',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0053',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0054',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0055',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0056',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0057',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0058',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0059',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0060',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0061',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0062',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0063',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0064',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0065',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0066',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0067',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0068',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0069',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0070',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0071',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0072',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0073',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0074',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0075',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0076',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0077',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0078',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0079',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0080',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0081',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0082',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0083',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0084',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0085',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0086',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0087',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0088',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0089',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0090',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0091',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0092',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0093',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0094',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0095',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0096',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0097',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0098',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0099',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0100',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0101',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0102',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0103',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0104',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0105',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0106',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0107',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0108',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0109',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0110',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0111',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0112',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0113',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0114',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0115',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0116',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0117',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0118',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0119',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0120',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0121',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0122',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0123',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0124',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0125',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0126',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0127',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0128',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0129',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0130',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0131',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0132',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0133',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0134',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0135',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0136',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0137',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0138',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0139',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0140',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0141',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0142',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0143',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0144',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0145',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0146',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0147',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0148',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0149',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0150',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0151',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0152',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0153',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0154',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0155',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0156',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0157',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0158',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0159',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0160',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0161',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0162',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0163',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0164',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0165',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0166',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0167',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0168',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0169',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0170',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0171',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0172',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0173',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0174',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0175',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0176',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0177',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0178',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0179',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0180',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0181',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0182',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0183',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0184',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0185',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0186',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0187',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0188',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0189',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0190',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0191',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0192',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0193',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0194',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0195',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0196',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0197',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0198',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0199',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0200',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0201',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0202',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0203',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0204',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0205',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0206',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0207',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0208',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0209',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0210',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0211',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0212',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0213',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0214',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0215',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0216',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0217',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0218',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0219',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0220',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0221',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0222',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0223',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0224',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0225',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0226',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0227',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0228',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0229',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0230',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0231',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0232',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0233',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0234',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0235',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0236',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0237',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0238',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0239',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0240',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0241',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0242',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0243',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0244',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0245',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0246',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0247',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0248',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0249',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0250',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0251',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0252',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0253',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0254',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0255',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0256',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0257',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0258',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0259',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0260',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  }
]

export default function compatibilityMatrixCatalogATest() {
  describe('CompatibilityMatrixCatalogATest', () => {
    it('compatibility_matrix_catalog_a_count_001', 0, () => {
      expect(COMPATIBILITY_MATRIX_CATALOG_A.length).assertEqual(260)
      expect(COMPATIBILITY_MATRIX_CATALOG_A[0].id.length).assertLarger(0)
      expect(COMPATIBILITY_MATRIX_CATALOG_A[259].resolution.includes('x')).assertTrue()
      expect(COMPATIBILITY_MATRIX_CATALOG_A[1].dpi.length).assertLarger(0)
      expect(COMPATIBILITY_MATRIX_CATALOG_A[2].locale.includes('-')).assertTrue()
    })
  })
}
