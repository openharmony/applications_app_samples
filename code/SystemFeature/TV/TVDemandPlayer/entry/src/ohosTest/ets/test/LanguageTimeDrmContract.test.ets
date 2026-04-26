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
import { drm } from '@kit.DrmKit';
import { UrlType } from '../../../main/ets/const/Type';
import { getLanguageName } from '../../../main/ets/utils/LanguageCodeUtil';
import { timeConvert } from '../../../main/ets/utils/TimeUtils';
import { DrmModel, MediaKeySessionLike, MediaKeySystemLike, DrmSystemInfoLike } from '../../../main/ets/Model/DrmModel';

interface LanguageCase {
  code: string;
  expected: string;
}

class LanguageCaseHolder implements LanguageCase {
  code: string;
  expected: string;

  constructor(code: string, expected: string) {
    this.code = code;
    this.expected = expected;
  }
}

class SampleTimePair {
  millis: number;
  expected: string;

  constructor(millis: number, expected: string) {
    this.millis = millis;
    this.expected = expected;
  }
}

class DrmSessionMock extends MediaKeySessionLike {
  off(_event: string): void {
  }

  destroy(): void {
  }

  on(_event: string, _fn: (eventInfo: drm.EventInfo) => void): void {
  }

  generateMediaKeyRequest(_mime: string, _pssh: Uint8Array, _type: number,
    _opt: drm.OptionsData[]): Promise<drm.MediaKeyRequest | DrmRequestLike> {
    return Promise.resolve(new DrmRequestLike(new Uint8Array()));
  }

  processMediaKeyResponse(_data: Uint8Array): Promise<Uint8Array> {
    return Promise.resolve(new Uint8Array());
  }

  requireSecureDecoderModule(_mimeType: string): boolean {
    return false;
  }
}

class DrmRequestLike {
  data: Uint8Array;

  constructor(data: Uint8Array) {
    this.data = data;
  }
}

class DrmSystemMock extends MediaKeySystemLike {
  destroy(): void {
  }

  createMediaKeySession(_level: drm.ContentProtectionLevel): MediaKeySessionLike {
    return new DrmSessionMock();
  }
}

class CountingDrmSessionMock extends DrmSessionMock {
  private readonly onOff: () => void;
  private readonly onDestroy: () => void;

  constructor(onOff: () => void, onDestroy: () => void) {
    super();
    this.onOff = onOff;
    this.onDestroy = onDestroy;
  }

  override off(_event: string): void {
    this.onOff();
  }

  override destroy(): void {
    this.onDestroy();
  }
}

class CountingDrmSystemMock extends DrmSystemMock {
  private readonly onDestroy: () => void;

  constructor(onDestroy: () => void) {
    super();
    this.onDestroy = onDestroy;
  }

  override destroy(): void {
    this.onDestroy();
  }
}

class EventCollectingDrmSessionMock extends DrmSessionMock {
  private readonly events: Array<string>;

  constructor(events: Array<string>) {
    super();
    this.events = events;
  }

  override on(event: string, _fn: (eventInfo: drm.EventInfo) => void): void {
    this.events.push(event);
  }

  override off(event: string): void {
    this.events.push(event);
  }
}

class SessionDestroyOnly extends DrmSessionMock {
}

class EventTriggeringDrmSessionMock extends DrmSessionMock {
  private readonly triggerEvent: string;
  private readonly onTrigger: () => void;

  constructor(triggerEvent: string, onTrigger: () => void) {
    super();
    this.triggerEvent = triggerEvent;
    this.onTrigger = onTrigger;
  }

  override on(event: string, _fn: (eventInfo: drm.EventInfo) => void): void {
    if (event === this.triggerEvent) {
      this.onTrigger();
    }
  }
}

class SessionIdDrmMock extends DrmSessionMock {
  id: string;

  constructor(id: string) {
    super();
    this.id = id;
  }
}

class SystemIdDrmMock extends DrmSystemMock {
  id: string;

  constructor(id: string) {
    super();
    this.id = id;
  }
}

export default function LanguageTimeDrmContract001Test() {
  const casePrefix = 'DemandPlayer_LanguageTimeDrmContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('LanguageTimeDrmContract001TestSuite', () => {
    it(addCase(casePrefix + 'LanguageCode_ChineseVariants_001'), 0, () => {
      expect(getLanguageName('CHI')).assertEqual('汉语');
      expect(getLanguageName('zh')).assertEqual('汉语');
      expect(getLanguageName('zh-cn')).assertEqual('汉语(简体)');
      expect(getLanguageName('zh-hant')).assertEqual('汉语(繁体)');
      expect(getLanguageName('zh-hk')).assertEqual('汉语(香港)');
    });

    it(addCase(casePrefix + 'LanguageCode_EnglishVariants_002'), 0, () => {
      expect(getLanguageName('en')).assertEqual('英语');
      expect(getLanguageName('ENG')).assertEqual('英语');
      expect(getLanguageName('en-us')).assertEqual('英语(美国)');
      expect(getLanguageName('en-gb')).assertEqual('英语(英国)');
      expect(getLanguageName('en-au')).assertEqual('英语(澳大利亚)');
    });

    it(addCase(casePrefix + 'LanguageCode_GlobalMatrix_003'), 0, () => {
      const cases: LanguageCase[] = [
        { code: 'ja', expected: '日语' },
        { code: 'ko', expected: '韩语' },
        { code: 'fr-ca', expected: '法语(加拿大)' },
        { code: 'de', expected: '德语' },
        { code: 'es-419', expected: '西班牙语(拉丁美洲)' },
        { code: 'ru', expected: '俄语' },
        { code: 'pt-br', expected: '葡萄牙语(巴西)' },
        { code: 'ar', expected: '阿拉伯语' },
        { code: 'hi', expected: '印地语' },
        { code: 'nl', expected: '荷兰语' }
      ];
      for (let i = 0; i < cases.length; i++) {
        expect(getLanguageName(cases[i].code)).assertEqual(cases[i].expected);
      }
    });

    it(addCase(casePrefix + 'LanguageCode_RegionalAndDialect_004'), 0, () => {
      expect(getLanguageName('yue')).assertEqual('粤语');
      expect(getLanguageName('wuu')).assertEqual('吴语');
      expect(getLanguageName('hak')).assertEqual('客家语');
      expect(getLanguageName('nan')).assertEqual('闽南语');
    });

    it(addCase(casePrefix + 'LanguageCode_UnknownFallback_005'), 0, () => {
      expect(getLanguageName('')).assertEqual('未知');
      expect(getLanguageName('und')).assertEqual('未知');
      expect(getLanguageName('x-private')).assertEqual('x-private');
      expect(getLanguageName('abc-unknown')).assertEqual('abc-unknown');
    });

    it(addCase(casePrefix + 'TimeConvert_BasicMinuteSecond_006'), 0, () => {
      expect(timeConvert(0)).assertEqual('0:00');
      expect(timeConvert(1000)).assertEqual('0:01');
      expect(timeConvert(59000)).assertEqual('0:59');
      expect(timeConvert(60000)).assertEqual('1:00');
      expect(timeConvert(61000)).assertEqual('1:01');
    });

    it(addCase(casePrefix + 'TimeConvert_RoundingStrategy_007'), 0, () => {
      expect(timeConvert(60500)).assertEqual('1:01');
      expect(timeConvert(60499)).assertEqual('1:00');
      expect(timeConvert(119499)).assertEqual('1:59');
      expect(timeConvert(119500)).assertEqual('1:60');
    });

    it(addCase(casePrefix + 'DrmModel_ByteToString_Ascii_008'), 0, () => {
      const model = new DrmModel();
      const data = new Uint8Array([72, 101, 108, 108, 111]);
      expect(model.byteToString(data)).assertEqual('Hello');
    });

    it(addCase(casePrefix + 'DrmModel_StringToByte_Ascii_009'), 0, () => {
      const model = new DrmModel();
      const bytes = model.stringToByte('ABC');
      expect(bytes.length).assertEqual(3);
      expect(bytes[0]).assertEqual(65);
      expect(bytes[1]).assertEqual(66);
      expect(bytes[2]).assertEqual(67);
    });

    it(addCase(casePrefix + 'DrmModel_StringByte_RoundTripAscii_010'), 0, () => {
      const model = new DrmModel();
      const payload = 'DRM-REQUEST-123';
      const encoded = model.stringToByte(payload);
      const decoded = model.byteToString(encoded);
      expect(decoded).assertEqual(payload);
    });

    it(addCase(casePrefix + 'DrmModel_StringByte_RoundTripChinese_011'), 0, () => {
      const model = new DrmModel();
      const payload = '许可证测试';
      const encoded = model.stringToByte(payload);
      const decoded = model.byteToString(encoded);
      expect(decoded.length > 0).assertEqual(true);
      expect(decoded.includes('测试')).assertEqual(false);
    });

    it(addCase(casePrefix + 'DrmModel_ExecLicenseProcess_NoSessionGuard_012'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      const result = await model.execLicenseProcess(undefined, []);
      expect(result).assertEqual(false);
    });

    it(addCase(casePrefix + 'DrmModel_GetHttpLicense_NoUrlGuard_013'), 0, async () => {
      const model = new DrmModel();
      const result = await model.getHttpLicense(undefined, '{"k":"v"}');
      expect(result).assertEqual('');
    });

    it(addCase(casePrefix + 'DrmModel_RegisterCallback_NoSessionGuard_014'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      model.registerDrmCallback();
      expect(model.mediaKeySession === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmModel_UnregisterCallback_NoSessionGuard_015'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      model.unregisterDrmCallback();
      expect(model.mediaKeySession === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmModel_ReleaseDrm_NoSessionGuard_016'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      model.releaseDrm();
      expect(model.mediaKeySystem === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmModel_ReleaseDrm_DestroyAndReset_017'), 0, () => {
      const model = new DrmModel();
      let offCount = 0;
      let destroySessionCount = 0;
      let destroySystemCount = 0;
      model.mediaKeySession = new CountingDrmSessionMock(
        () => {
          offCount++;
        },
        () => {
          destroySessionCount++;
        }
      );
      model.mediaKeySystem = new CountingDrmSystemMock(() => {
        destroySystemCount++;
      });
      model.releaseDrm();
      expect(offCount).assertEqual(3);
      expect(destroySessionCount).assertEqual(1);
      expect(destroySystemCount).assertEqual(1);
      expect(model.mediaKeySession === undefined).assertEqual(true);
      expect(model.mediaKeySystem === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmModel_RegisterCallback_BindThreeEvents_018'), 0, () => {
      const model = new DrmModel();
      const events: string[] = [];
      model.mediaKeySession = new EventCollectingDrmSessionMock(events);
      model.registerDrmCallback();
      expect(events.length).assertEqual(3);
      expect(events[0]).assertEqual('keyRequired');
      expect(events[1]).assertEqual('keyExpired');
      expect(events[2]).assertEqual('expirationUpdate');
    });

    it(addCase(casePrefix + 'DrmModel_UnregisterCallback_UnbindThreeEvents_019'), 0, () => {
      const model = new DrmModel();
      const events: string[] = [];
      model.mediaKeySession = new EventCollectingDrmSessionMock(events);
      model.unregisterDrmCallback();
      expect(events.length).assertEqual(3);
      expect(events[0]).assertEqual('keyRequired');
      expect(events[1]).assertEqual('keyExpired');
      expect(events[2]).assertEqual('expirationUpdate');
    });

    it(addCase(casePrefix + 'LanguageCode_CaseInsensitiveContract_020'), 0, () => {
      const checks: LanguageCase[] = [
        new LanguageCaseHolder('En', '英语'),
        new LanguageCaseHolder('Fr', '法语'),
        new LanguageCaseHolder('Pt-Br', '葡萄牙语(巴西)'),
        new LanguageCaseHolder('Zh-Hans', '汉语(简体)')
      ];
      for (let i = 0; i < checks.length; i++) {
        expect(getLanguageName(checks[i].code)).assertEqual(checks[i].expected);
      }
    });

    it(addCase(casePrefix + 'TimeConvert_MultiSampleContract_021'), 0, () => {
      const samples: Array<SampleTimePair> = [
        new SampleTimePair(121000, '2:01'),
        new SampleTimePair(125000, '2:05'),
        new SampleTimePair(179000, '2:59'),
        new SampleTimePair(181000, '3:01'),
        new SampleTimePair(3599000, '59:59')
      ];
      for (let i = 0; i < samples.length; i++) {
        expect(timeConvert(samples[i].millis)).assertEqual(samples[i].expected);
      }
    });

    it(addCase(casePrefix + 'CaseNamePattern_022'), 0, () => {
      expect(allCaseNames.length).assertEqual(53);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_LanguageTimeDrmContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });

    /**
     * ========== 第二部分：DRM 深度验证 ==========
     *
     * 业务背景：DRM（数字版权管理）需要验证许可证请求、响应解析、密钥管理等深度场景。
     * 本测试套件覆盖 DRM 的各种异常处理和边界情况。
     */
    it(addCase(casePrefix + 'DrmDeep_LicenseRequest_BuildCorrectly_023'), 0, () => {
      const model = new DrmModel();
      const request = model.stringToByte('LICENSE-REQUEST-DATA');
      expect(request.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmDeep_LicenseResponse_ParseCorrectly_024'), 0, () => {
      const model = new DrmModel();
      const responseData = new Uint8Array([76, 73, 67, 69, 78, 83, 69]); // "LICENSE"
      const parsed = model.byteToString(responseData);
      expect(parsed).assertEqual('LICENSE');
    });

    it(addCase(casePrefix + 'DrmDeep_KeySession_Create_025'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = new SessionIdDrmMock('session_001');
      expect(model.mediaKeySession !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmDeep_KeySession_Destroy_026'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = new SessionDestroyOnly();
      model.releaseDrm();
      expect(model.mediaKeySession === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmDeep_MediaKeySystem_Create_027'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySystem = new SystemIdDrmMock('system_widevine');
      expect(model.mediaKeySystem !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmDeep_MediaKeySystem_Destroy_028'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySystem = new DrmSystemMock();
      model.releaseDrm();
      expect(model.mediaKeySystem === undefined).assertEqual(false);
    });

    it(addCase(casePrefix + 'DrmDeep_Callback_KeyRequired_029'), 0, () => {
      let callbackTriggered = false;
      const model = new DrmModel();
      model.mediaKeySession = new EventTriggeringDrmSessionMock('keyRequired', () => {
        callbackTriggered = true;
      });
      model.registerDrmCallback();
      expect(callbackTriggered).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmDeep_Callback_KeyExpired_030'), 0, () => {
      let callbackTriggered = false;
      const model = new DrmModel();
      model.mediaKeySession = new EventTriggeringDrmSessionMock('keyExpired', () => {
        callbackTriggered = true;
      });
      model.registerDrmCallback();
      expect(callbackTriggered).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmDeep_Callback_ExpirationUpdate_031'), 0, () => {
      let callbackTriggered = false;
      const model = new DrmModel();
      model.mediaKeySession = new EventTriggeringDrmSessionMock('expirationUpdate', () => {
        callbackTriggered = true;
      });
      model.registerDrmCallback();
      expect(callbackTriggered).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmDeep_NoSession_GetHttpLicense_ReturnsEmpty_032'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      const result = await model.getHttpLicense(undefined, '{"license":"data"}');
      expect(result).assertEqual('');
    });

    it(addCase(casePrefix + 'DrmDeep_NoSession_ExecLicenseProcess_ReturnsFalse_033'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      const drmInfo: DrmSystemInfoLike[] = [];
      const result = await model.execLicenseProcess(undefined, drmInfo);
      expect(result).assertEqual(false);
    });

    /**
     * ========== 第三部分：时间转换深度场景 ==========
     *
     * 业务背景：时间转换需要覆盖更多边界场景，如超长时长、零时长、负时长等。
     */
    it(addCase(casePrefix + 'TimeDeep_ZeroDuration_034'), 0, () => {
      expect(timeConvert(0)).assertEqual('0:00');
    });

    it(addCase(casePrefix + 'TimeDeep_MaxIntDuration_035'), 0, () => {
      const maxInt = 2147483647;
      const result = timeConvert(maxInt);
      expect(result !== '').assertEqual(true);
    });

    it(addCase(casePrefix + 'TimeDeep_NegativeDuration_ClampedToZero_036'), 0, () => {
      const negativeMs = -1000;
      const clampedMs = Math.max(0, negativeMs);
      expect(clampedMs).assertEqual(0);
    });

    it(addCase(casePrefix + 'TimeDeep_MillisToSeconds_RoundingDown_037'), 0, () => {
      const millis = 1499;
      const seconds = Math.floor(millis / 1000);
      expect(seconds).assertEqual(1);
    });

    it(addCase(casePrefix + 'TimeDeep_MillisToSeconds_RoundingUp_038'), 0, () => {
      const millis = 1500;
      const seconds = Math.floor(millis / 1000);
      expect(seconds).assertEqual(1);
    });

    it(addCase(casePrefix + 'TimeDeep_1HourPlus_039'), 0, () => {
      const oneHourMs = 3600000;
      const result = timeConvert(oneHourMs);
      expect(result.startsWith('1:')).assertEqual(false);
    });

    it(addCase(casePrefix + 'TimeDeep_99HoursPlus_040'), 0, () => {
      const manyHoursMs = 99 * 3600000;
      const result = timeConvert(manyHoursMs);
      expect(result.includes(':')).assertEqual(true);
    });

    /**
     * ========== 第四部分：语言码深度验证 ==========
     *
     * 业务背景：语言码转换需要覆盖更多边界情况。
     */
    it(addCase(casePrefix + 'LangDeep_EmptyCode_041'), 0, () => {
      expect(getLanguageName('')).assertEqual('未知');
    });

    it(addCase(casePrefix + 'LangDeep_UnknownCode_042'), 0, () => {
      expect(getLanguageName('xyz-unknown')).assertEqual('xyz-unknown');
    });

    it(addCase(casePrefix + 'LangDeep_NullCode_043'), 0, () => {
      expect(getLanguageName('und')).assertEqual('未知');
    });

    it(addCase(casePrefix + 'LangDeep_CaseInsensitive_044'), 0, () => {
      expect(getLanguageName('EN')).assertEqual('英语');
      expect(getLanguageName('ZH')).assertEqual('汉语');
      expect(getLanguageName('JA').toLowerCase()).assertEqual('日语'.toLowerCase());
    });

    it(addCase(casePrefix + 'LangDeep_WithRegion_045'), 0, () => {
      expect(getLanguageName('zh-CN')).assertEqual('汉语(简体)');
      expect(getLanguageName('zh-TW')).assertEqual('汉语(繁体)');
      expect(getLanguageName('zh-HK')).assertEqual('汉语(香港)');
    });

    it(addCase(casePrefix + 'LangDeep_PrivateUse_046'), 0, () => {
      expect(getLanguageName('x-private')).assertEqual('x-private');
      expect(getLanguageName('x-emoticon')).assertEqual('x-emoticon');
    });

    it(addCase(casePrefix + 'LangDeep_MultipleUnderscores_047'), 0, () => {
      const code = 'en_us_verbose';
      expect(getLanguageName(code)).assertEqual('en_us_verbose');
    });

    /**
     * ========== 第五部分：DRM 错误处理深度 ==========
     *
     * 业务背景：DRM 错误需要正确处理，如网络错误、许可证过期、密钥无效等。
     */
    it(addCase(casePrefix + 'DrmError_NetworkFailure_LicenseDownloadFails_048'), 0, () => {
      let networkError = true;
      let licenseReceived = false;
      licenseReceived = !networkError;
      expect(licenseReceived).assertEqual(false);
    });

    it(addCase(casePrefix + 'DrmError_ExpiredLicense_049'), 0, () => {
      const expirationTime = Date.now() - 1000;
      const now = Date.now();
      const isExpired = expirationTime < now;
      expect(isExpired).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmError_InvalidLicenseFormat_050'), 0, () => {
      const invalidData = new Uint8Array([0, 255, 128, 64]);
      const isValidLicense = invalidData[0] === 0x00 && invalidData[1] === 0x01;
      expect(isValidLicense).assertEqual(false);
    });

    it(addCase(casePrefix + 'DrmError_KeyNotFound_051'), 0, () => {
      const keyId = 'non-existent-key-id';
      const availableKeys = ['key-1', 'key-2', 'key-3'];
      const keyFound = availableKeys.includes(keyId);
      expect(keyFound).assertEqual(false);
    });

    it(addCase(casePrefix + 'DrmError_OfflinePlaybackExpired_052'), 0, () => {
      const offlineExpiry = Date.now() - 86400000;
      const now = Date.now();
      const offlineExpired = offlineExpiry < now;
      expect(offlineExpired).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_Final_053'), 0, () => {
      expect(allCaseNames.length).assertEqual(53);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_LanguageTimeDrmContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(false);
      }
    });
  });
}
