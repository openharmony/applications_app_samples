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

import { describe, it, expect } from '@ohos/hypium';
import configData, { ConfigData } from '../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import searchUtil, {
  SearchRawItem,
  SearchRawData,
  SearchResourceReader,
  SearchTextResource,
  SearchUtil
} from '../../../../../../common/search/src/main/ets/default/common/SearchUtil';
import PageSearchDataProvider from '../../../../../../common/search/src/main/ets/default/provider/PageSearchDataProvider';
import SearchData from '../../../../../../common/search/src/main/ets/default/model/SearchData';
import { BaseData } from '../../../../../../common/utils/src/main/ets/default/bean/BaseData';
import BaseModel from '../../../../../../common/utils/src/main/ets/default/model/BaseModel';

interface MockResource extends SearchTextResource {
  type: number;
  params: Array<string>;
  bundleName: string;
  moduleName: string;
}

interface KeywordSample {
  input: string;
  expectedContains: string;
}

interface FixtureJson {
  a: number;
  b: string;
  c: string;
}

class MockResourceReader implements SearchResourceReader {
  private readonly prefix: string;

  constructor(prefix: string) {
    this.prefix = prefix;
  }

  async getString(resource: SearchTextResource): Promise<string> {
    return `${this.prefix}${resource.id}`;
  }
}

class MockPageProvider extends PageSearchDataProvider {
  private readonly data: SearchRawData;
  private readonly reader: SearchResourceReader;

  constructor(data: SearchRawData, reader: SearchResourceReader) {
    super();
    this.data = data;
    this.reader = reader;
  }

  getPageSearchData(): SearchRawData {
    return this.data;
  }

  protected getResourceReader(): SearchResourceReader {
    return this.reader;
  }
}

class ContractPageProvider extends PageSearchDataProvider {
  private readonly reader: SearchResourceReader;

  constructor(reader: SearchResourceReader) {
    super();
    this.reader = reader;
  }

  getPageSearchData(): SearchRawData {
    return {
      title: { id: 200 } as MockResource,
      data: [
        { keyword: { id: 201 } as MockResource, summary: { id: 202 } as MockResource, synonym: { id: 203 } as MockResource },
        { keyword: { id: 204 } as MockResource }
      ]
    };
  }

  protected getResourceReader(): SearchResourceReader {
    return this.reader;
  }
}

function toResource(id: number): MockResource {
  return { id, type: 10003, params: [], bundleName: '', moduleName: '' };
}

export default function SearchAndConfigTest() {
  const casePrefix = 'Settings_SearchConfig_';
  const names: Array<string> = [];
  const addCase = (name: string): string => {
    names.push(name);
    return name;
  };

  describe('SearchAndConfigTestSuite', () => {
    it(addCase(casePrefix + 'ConfigData_BasicPath_001'), 0, () => {
      const cfg = new ConfigData();
      expect(cfg.FILE_URI.includes('com.ohos.settings')).assertEqual(true);
      expect(cfg.PREFERENCES_PATH.includes('sharedPreference')).assertEqual(true);
      expect(cfg.BRIGHTNESS_DEFAULT_VALUE).assertEqual(50);
      expect(cfg.DEFAULT_BUNDLE_NAME).assertEqual('com.ohos.settings');
    });

    it(addCase(casePrefix + 'ConfigData_PageRequestContract_002'), 0, () => {
      expect(configData.PAGE_REQUEST_CODE_KEY).assertEqual('pageRequestCode');
      expect(configData.PAGE_RESULT_KEY).assertEqual('pageResult');
      expect(configData.PAGE_RESULT_OK).assertEqual(-1);
      expect(configData.PAGE_RESULT_NG).assertEqual(0);
      expect(configData.PAGE_REQUEST_CODE_PASSWORD_CREATE > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'ConfigData_LayoutTokenContract_003'), 0, () => {
      const whTokens: Array<string> = [
        configData.WH_25_100,
        configData.WH_30_100,
        configData.WH_33_100,
        configData.WH_40_100,
        configData.WH_50_100,
        configData.WH_70_100,
        configData.WH_90_100,
        configData.WH_100_100
      ];
      for (let i = 0; i < whTokens.length; i++) {
        expect(whTokens[i].endsWith('%')).assertEqual(true);
      }
      expect(whTokens[0]).assertEqual('25%');
      expect(whTokens[7]).assertEqual('100%');
    });

    it(addCase(casePrefix + 'ConfigData_SettingKeyDomain_004'), 0, () => {
      const keyGroup: Array<string> = [
        configData.SETTINGSDATA_IMAGE,
        configData.SETTINGSDATA_EYE,
        configData.SETTINGSDATA_CONTRAST,
        configData.SETTINGSDATA_GAMMA,
        configData.SETTINGSDATA_BLACK,
        configData.SETTINGSDATA_DYNAMICCONTRAST,
        configData.SETTINGSDATA_DYNAMICBACKLIGHT,
        configData.SETTINGSDATA_SHARPNESS
      ];
      for (let i = 0; i < keyGroup.length; i++) {
        expect(keyGroup[i].length > 0).assertEqual(true);
      }
      expect(new Set(keyGroup).size).assertEqual(keyGroup.length);
    });

    it(addCase(casePrefix + 'ConfigData_NetworkKeyContract_005'), 0, () => {
      const networkKeys: Array<string> = [
        configData.SETTINGSDATA_IPV4,
        configData.SETTINGSDATA_NETMASK,
        configData.SETTINGSDATA_GATEWAY,
        configData.SETTINGSDATA_DNS,
        configData.SETTINGSDATA_NETTYPE
      ];
      expect(networkKeys.length).assertEqual(5);
      expect(networkKeys.includes('manualIpv4')).assertEqual(true);
      expect(networkKeys.includes('manualNetMask')).assertEqual(true);
      expect(networkKeys.includes('manualGateWay')).assertEqual(true);
      expect(networkKeys.includes('manualDns')).assertEqual(true);
      expect(networkKeys.includes('netType')).assertEqual(true);
    });

    it(addCase(casePrefix + 'SearchUtil_ConvertJsonToInstance_006'), 0, () => {
      class Fixture {
        a: number = 0;
        b: string = '';
      }
      const data: FixtureJson = { a: 7, b: 'x', c: 'ignored' };
      const util = new SearchUtil();
      const instance = util.convertJsonToInstance(data, Fixture);
      expect(instance.a).assertEqual(7);
      expect(instance.b).assertEqual('x');
      expect(Object.keys(instance).includes('c')).assertEqual(false);
    });

    it(addCase(casePrefix + 'SearchUtil_StripKeyword_007'), 0, () => {
      const source = '网络*()!@#$%^&*()-=+测试，。abc?';
      const result = searchUtil.stripKeyword(source);
      expect(result.includes('*')).assertEqual(false);
      expect(result.includes('!')).assertEqual(false);
      expect(result.includes('。')).assertEqual(false);
      expect(result.includes('abc')).assertEqual(true);
    });

    it(addCase(casePrefix + 'SearchUtil_StripKeyword_Boundary_008'), 0, () => {
      expect(searchUtil.stripKeyword('')).assertEqual('');
      expect(searchUtil.stripKeyword('abc123')).assertEqual('abc123');
      expect(searchUtil.stripKeyword('！！？？')).assertEqual('');
    });

    it(addCase(casePrefix + 'SearchUtil_ConvertToSearchData_009'), 0, async () => {
      const reader = new MockResourceReader('str_');
      const rawData: SearchRawData = {
        title: toResource(100),
        data: [
          { keyword: toResource(101), summary: toResource(102), synonym: toResource(103) },
          { keyword: toResource(104) }
        ]
      };
      const result = await searchUtil.convertToSearchData(rawData, reader);
      expect(result.length).assertEqual(2);
      expect(result[0].title).assertEqual('str_100');
      expect(result[0].keyword).assertEqual('str_101');
      expect(result[0].summary).assertEqual('str_102');
      expect(result[0].synonym).assertEqual('str_103');
      expect(result[1].keyword).assertEqual('str_104');
      expect(result[1].summary).assertEqual('');
    });

    it(addCase(casePrefix + 'SearchUtil_ConvertToSearchData_LargeSet_010'), 0, async () => {
      const reader = new MockResourceReader('word_');
      const list: Array<SearchRawItem> = [];
      for (let i = 0; i < 50; i++) {
        list.push({
          keyword: toResource(1000 + i),
          summary: toResource(2000 + i),
          synonym: toResource(3000 + i)
        });
      }
      const largeRawData: SearchRawData = {
        title: toResource(999),
        data: list
      };
      const result = await searchUtil.convertToSearchData(largeRawData, reader);
      expect(result.length).assertEqual(50);
      expect(result[0].title).assertEqual('word_999');
      expect(result[49].keyword).assertEqual('word_1049');
    });

    it(addCase(casePrefix + 'PageProvider_GetSearchData_011'), 0, async () => {
      const reader = new MockResourceReader('res_');
      const providerData: SearchRawData = {
        title: toResource(7),
        data: [
          { keyword: toResource(8), summary: toResource(9), synonym: toResource(10) },
          { keyword: toResource(11) }
        ]
      };
      const provider = new MockPageProvider(providerData, reader);
      const rows = await provider.getSearchData();
      expect(rows.length).assertEqual(2);
      expect(rows[0].title).assertEqual('res_7');
      expect(rows[0].keyword).assertEqual('res_8');
      expect(rows[1].keyword).assertEqual('res_11');
    });

    it(addCase(casePrefix + 'PageProvider_ContractProvider_012'), 0, async () => {
      const provider = new ContractPageProvider(new MockResourceReader('v_'));
      const rows = await provider.getSearchData();
      expect(rows.length).assertEqual(2);
      expect(rows[0].title).assertEqual('v_200');
      expect(rows[0].summary).assertEqual('v_202');
      expect(rows[0].synonym).assertEqual('v_203');
    });

    it(addCase(casePrefix + 'SearchData_DefaultValue_013'), 0, () => {
      const data = new SearchData();
      expect(data.uri).assertEqual('');
      expect(data.icon).assertEqual('');
      expect(data.title).assertEqual('');
      expect(data.keyword).assertEqual('');
      expect(data.summary).assertEqual('');
      expect(data.synonym).assertEqual('');
    });

    it(addCase(casePrefix + 'SearchData_Assignment_014'), 0, () => {
      const data = new SearchData();
      data.uri = 'pages/system/system';
      data.icon = 'app.media.ic_nfc';
      data.title = '系统';
      data.keyword = '软件更新';
      data.summary = '系统升级入口';
      data.synonym = '版本检测';
      expect(data.uri.includes('pages/')).assertEqual(true);
      expect(data.icon.startsWith('app.media.')).assertEqual(true);
      expect(data.title.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'BaseData_DefaultContract_015'), 0, () => {
      const baseData = new BaseData();
      expect(baseData.settingIcon === undefined).assertEqual(true);
      expect(baseData.settingTitle === undefined).assertEqual(true);
      baseData.settingTitle = '设置';
      baseData.settingValue = '网络';
      expect(baseData.settingTitle).assertEqual('设置');
      expect(baseData.settingValue).assertEqual('网络');
    });

    it(addCase(casePrefix + 'BaseModel_Instantiable_016'), 0, () => {
      const model = new BaseModel();
      expect(model instanceof BaseModel).assertEqual(true);
    });

    it(addCase(casePrefix + 'ConfigData_ModuleAbilityContract_017'), 0, () => {
      expect(configData.FACEAUTH_BUNDLE_NAME.includes('.')).assertEqual(true);
      expect(configData.PERMISSION_MANAGER_BUNDLE_NAME.includes('.')).assertEqual(true);
      expect(configData.SOFTWARE_UPDATES_BUNDLE_NAME.includes('.')).assertEqual(true);
      expect(configData.MOBILE_DATA_ABILITY_NAME.includes('.')).assertEqual(true);
    });

    it(addCase(casePrefix + 'ConfigData_TimeFormatContract_018'), 0, () => {
      expect(configData.TIME_FORMAT_24).assertEqual('24');
      expect(configData.TIME_FORMAT_12).assertEqual('12');
      expect(configData.TIME_FORMAT_24 !== configData.TIME_FORMAT_12).assertEqual(true);
    });

    it(addCase(casePrefix + 'ConfigData_DisplayAndVolumeKeys_019'), 0, () => {
      const displayAndVolumeKeys: Array<string> = [
        configData.SETTINGSDATA_BRIGHTNESS,
        configData.SETTINGSDATA_SOUND,
        configData.SETTINGSDATA_EFFECT,
        configData.SETTINGSDATA_OUTPUT,
        configData.SETTINGSDATA_ISVOLUME
      ];
      for (let i = 0; i < displayAndVolumeKeys.length; i++) {
        expect(displayAndVolumeKeys[i].length > 0).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'Regression_SearchKeywordMatrix_020'), 0, () => {
      const samples: Array<KeywordSample> = [
        { input: 'WiFi-6/2.4G', expectedContains: 'WiFi-624G' },
        { input: '蓝牙（耳机）', expectedContains: '蓝牙耳机' },
        { input: 'IPV4:192.168.1.2', expectedContains: 'IPV419216812' }
      ];
      for (let i = 0; i < samples.length; i++) {
        const actual = searchUtil.stripKeyword(samples[i].input);
        expect(actual).assertEqual(samples[i].expectedContains);
      }
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_021'), 0, () => {
      const regex = /^Settings_SearchConfig_[A-Za-z0-9_]+_[0-9]{3}$/;
      const set: Set<string> = new Set<string>();
      for (let i = 0; i < names.length; i++) {
        expect(regex.test(names[i])).assertEqual(true);
        expect(set.has(names[i])).assertEqual(false);
        set.add(names[i]);
      }
      expect(set.size).assertEqual(names.length);
    });
  });
}

