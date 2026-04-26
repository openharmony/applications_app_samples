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

const COMPATIBILITY_MATRIX_CATALOG_C: CompatibilityScenario[] = [
  {
    id: 'matrix_0521',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0522',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0523',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0524',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0525',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0526',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0527',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0528',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0529',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0530',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0531',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0532',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0533',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0534',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0535',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0536',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0537',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0538',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0539',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0540',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0541',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0542',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0543',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0544',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0545',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0546',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0547',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0548',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0549',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0550',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0551',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0552',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0553',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0554',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0555',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0556',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0557',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0558',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0559',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0560',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0561',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0562',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0563',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0564',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0565',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0566',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0567',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0568',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0569',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0570',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0571',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0572',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0573',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0574',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0575',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0576',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0577',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0578',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0579',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0580',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0581',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0582',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0583',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0584',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0585',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0586',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0587',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0588',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0589',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0590',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0591',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0592',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0593',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0594',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0595',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0596',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0597',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0598',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0599',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0600',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0601',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0602',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0603',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0604',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0605',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0606',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0607',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0608',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0609',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0610',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0611',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0612',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0613',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0614',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0615',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0616',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0617',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0618',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0619',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0620',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0621',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0622',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0623',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0624',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0625',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0626',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0627',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0628',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0629',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0630',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0631',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0632',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0633',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0634',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0635',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0636',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0637',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0638',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0639',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0640',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0641',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0642',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0643',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0644',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0645',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0646',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0647',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0648',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0649',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0650',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0651',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0652',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0653',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0654',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0655',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0656',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0657',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0658',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0659',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0660',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0661',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0662',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0663',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0664',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0665',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0666',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0667',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0668',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0669',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0670',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0671',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0672',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0673',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0674',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0675',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0676',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0677',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0678',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0679',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0680',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0681',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0682',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0683',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0684',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0685',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0686',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0687',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0688',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0689',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0690',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0691',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0692',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0693',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0694',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0695',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0696',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0697',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0698',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0699',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0700',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0701',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0702',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0703',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0704',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0705',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0706',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0707',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0708',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0709',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0710',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0711',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0712',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0713',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0714',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0715',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0716',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0717',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0718',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0719',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0720',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0721',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0722',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0723',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0724',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0725',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0726',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0727',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0728',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0729',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0730',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0731',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0732',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0733',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0734',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0735',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0736',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0737',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0738',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0739',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0740',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0741',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0742',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0743',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0744',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0745',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0746',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0747',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0748',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0749',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0750',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0751',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0752',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0753',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0754',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0755',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0756',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0757',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0758',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0759',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0760',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0761',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0762',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0763',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0764',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0765',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0766',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0767',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0768',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0769',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0770',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0771',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0772',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0773',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0774',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0775',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0776',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0777',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0778',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0779',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0780',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0781',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0782',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0783',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0784',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0785',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0786',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0787',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0788',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0789',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0790',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0791',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0792',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0793',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0794',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0795',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0796',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0797',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0798',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0799',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0800',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0801',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0802',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0803',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0804',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0805',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0806',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0807',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0808',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0809',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0810',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0811',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0812',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0813',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0814',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0815',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0816',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0817',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0818',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0819',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0820',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0821',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0822',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0823',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0824',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0825',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0826',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0827',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0828',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0829',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0830',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0831',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0832',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0833',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0834',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0835',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0836',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0837',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  },
  {
    id: 'matrix_0838',
    resolution: '1280x720',
    dpi: '160',
    locale: 'zh-CN'
  },
  {
    id: 'matrix_0839',
    resolution: '1920x1080',
    dpi: '240',
    locale: 'en-US'
  },
  {
    id: 'matrix_0840',
    resolution: '3840x2160',
    dpi: '320',
    locale: 'de-DE'
  }
]

export default function compatibilityMatrixCatalogCTest() {
  describe('CompatibilityMatrixCatalogCTest', () => {
    it('compatibility_matrix_catalog_c_count_001', 0, () => {
      expect(COMPATIBILITY_MATRIX_CATALOG_C.length).assertEqual(320)
      expect(COMPATIBILITY_MATRIX_CATALOG_C[0].id.length).assertLarger(0)
      expect(COMPATIBILITY_MATRIX_CATALOG_C[319].resolution.includes('x')).assertTrue()
      expect(COMPATIBILITY_MATRIX_CATALOG_C[1].dpi.length).assertLarger(0)
      expect(COMPATIBILITY_MATRIX_CATALOG_C[2].locale.includes('-')).assertTrue()
    })
  })
}
