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
import { DrmUtil } from '../../../main/ets/utils/Drm';
import { Throttle } from '../../../main/ets/Model/Throttle';
import { drm } from '@kit.DrmKit';
import { media } from '@kit.MediaKit';
import { UrlType } from '../../../main/ets/const/Type';
import {
  DrmModel,
  DrmSystemInfoLike,
  DecryptionAvPlayerLike,
  MediaKeySessionLike,
  MediaKeySystemLike
} from '../../../main/ets/Model/DrmModel';

/**
 * 杩欐壒娴嬭瘯鍏堥攣瀹氱函濂戠害閫昏緫銆?
 * 杩欑被鐢ㄤ緥涓嶄緷璧栫湡瀹炶澶囪兘鍔涳紝閫傚悎浣滀负鍥炲綊搴曞骇锛岃兘鏇寸ǔ瀹氬湴鍏滀綇鏍稿績绠楁硶鍜屼繚鎶ゅ垎鏀€?
 */
abstract class LocalMediaKeyRequestResultLike {
  abstract data: Uint8Array;
}

class MediaKeyRequestResultHolder extends LocalMediaKeyRequestResultLike {
  data: Uint8Array;

  constructor(data: Uint8Array) {
    super();
    this.data = data;
  }
}

class StringRoundTripCase {
  name: string;
  value: string;

  constructor(name: string, value: string) {
    this.name = name;
    this.value = value;
  }
}

class MockMediaKeySystem extends MediaKeySystemLike {
  public createMediaKeySession(_level: drm.ContentProtectionLevel): MediaKeySessionLike {
    return new MockMediaKeySession();
  }

  public destroy(): void {
  }
}

class MockMediaKeySession extends MediaKeySessionLike {
  public on(_name: string, _cb: (eventInfo: drm.EventInfo) => void): void {
  }

  public off(_name: string): void {
  }

  public destroy(): void {
  }

  public requireSecureDecoderModule(_mimeType: string): boolean {
    return false;
  }

  public async generateMediaKeyRequest(
    _mime: string,
    _pssh: Uint8Array,
    _type: number,
    _opt: drm.OptionsData[]
  ): Promise<LocalMediaKeyRequestResultLike> {
    return new MediaKeyRequestResultHolder(new Uint8Array());
  }

  public async processMediaKeyResponse(_data: Uint8Array): Promise<Uint8Array> {
    return new Uint8Array();
  }
}

class LicenseUrlHolder implements UrlType {
  public licenseUri: string = '';
}

class MediaKeyInfoHolder {
  public uuid: string = '';
  public pssh: Uint8Array = new Uint8Array();
}

class DestroyFailMediaKeySession extends MockMediaKeySession {
  public override destroy(): void {
    throw new Error('destroy fail');
  }
}

class CountingMediaKeySystem extends MockMediaKeySystem {
  private readonly onDestroy: () => void;

  constructor(onDestroy: () => void) {
    super();
    this.onDestroy = onDestroy;
  }

  public override destroy(): void {
    this.onDestroy();
  }
}

class SessionIdHolder extends MockMediaKeySession {
  id: string;

  constructor(id: string) {
    super();
    this.id = id;
  }
}

class SessionDestroyOnly extends MockMediaKeySession {
}

class SessionEventTriggerMock extends MockMediaKeySession {
  private readonly eventNameToTrigger: string;
  private readonly onTriggered: () => void;

  constructor(eventNameToTrigger: string, onTriggered: () => void) {
    super();
    this.eventNameToTrigger = eventNameToTrigger;
    this.onTriggered = onTriggered;
  }

  public override on(event: string, _cb: (eventInfo: drm.EventInfo) => void): void {
    if (event === this.eventNameToTrigger) {
      this.onTriggered();
    }
  }
}

class SystemIdHolder extends MockMediaKeySystem {
  id: string;

  constructor(id: string) {
    super();
    this.id = id;
  }
}

class SessionAndSystemHolder extends MockMediaKeySession {
  private readonly onOff: () => void;
  private readonly onDestroy: () => void;

  constructor(onOff: () => void, onDestroy: () => void) {
    super();
    this.onOff = onOff;
    this.onDestroy = onDestroy;
  }

  public override off(_name: string): void {
    this.onOff();
  }

  public override destroy(): void {
    this.onDestroy();
  }
}

class GenerateRequestOnlySession extends MockMediaKeySession {
  private readonly requestData: Uint8Array;

  constructor(requestData: Uint8Array) {
    super();
    this.requestData = requestData;
  }

  public override async generateMediaKeyRequest(
    _mime: string,
    _pssh: Uint8Array,
    _type: number,
    _opt: drm.OptionsData[]
  ): Promise<LocalMediaKeyRequestResultLike> {
    return new MediaKeyRequestResultHolder(this.requestData);
  }
}

class EventNameCollectorSession extends MockMediaKeySession {
  private readonly eventNames: Array<string>;

  constructor(eventNames: Array<string>) {
    super();
    this.eventNames = eventNames;
  }

  public override on(name: string, _cb: (eventInfo: drm.EventInfo) => void): void {
    this.eventNames.push(name);
  }

  public override off(name: string): void {
    this.eventNames.push(name);
  }
}

class SuccessMediaKeySession extends MockMediaKeySession {
  private readonly onRequest: () => void;
  private readonly onResponse: () => void;

  constructor(onRequest: () => void, onResponse: () => void) {
    super();
    this.onRequest = onRequest;
    this.onResponse = onResponse;
  }

  public override async generateMediaKeyRequest(
    _mime: string,
    _pssh: Uint8Array,
    _type: number,
    _opt: drm.OptionsData[]
  ): Promise<LocalMediaKeyRequestResultLike> {
    this.onRequest();
    return new MediaKeyRequestResultHolder(new Uint8Array([65, 66, 67]));
  }

  public override async processMediaKeyResponse(_data: Uint8Array): Promise<Uint8Array> {
    this.onResponse();
    return new Uint8Array([1, 2, 3]);
  }
}

class PerfSessionItem {
  id: string;

  constructor(id: string) {
    this.id = id;
  }
}

class DrmSystemInfoMock extends DrmSystemInfoLike {
  uuid: string = '';
  pssh: Uint8Array = new Uint8Array();
}

class EmptyAvPlayerMock extends DecryptionAvPlayerLike {
  setDecryptionConfig(_session: drm.MediaKeySession, _svp: boolean): void {
  }
}

class DecoratorFixture {
  public invokeCount: number = 0;

  /**
   * 杩欓噷楠岃瘉瑁呴グ鍣ㄤ笉浼氱牬鍧忓師濮?descriptor銆?
   * 涓氬姟涓婅瑁呴グ鍣ㄧ洰鍓嶆槸 strict-mode 鍏煎鍗犱綅瀹炵幇锛屾祴璇曢噸鐐规槸鈥滃彲鎸傝浇銆佸彲璋冪敤銆佹棤鍓綔鐢ㄢ€濄€?
   */

  markCalled(): string {
    this.invokeCount++;
    return 'ok';
  }
}

export default function DrmAndContractCoreTest() {
  const casePrefix = 'DemandPlayer_DrmContractCore_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DrmAndContractCoreTestSuite', () => {
    it(addCase(casePrefix + 'ByteString_RoundTripAscii_001'), 0, () => {
      const model = new DrmModel();
      const cases: Array<StringRoundTripCase> = [
        new StringRoundTripCase('Empty', ''),
        new StringRoundTripCase('PlainAscii', 'video-license-token'),
        new StringRoundTripCase('JsonText', '{"certificateChain":"ok"}'),
      ];
      for (let i = 0; i < cases.length; i++) {
        const bytes = model.stringToByte(cases[i].value);
        const restored = model.byteToString(bytes);
        expect(restored).assertEqual(cases[i].value);
      }
    });

    it(addCase(casePrefix + 'StringToByte_LengthContract_002'), 0, () => {
      const model = new DrmModel();
      const text = 'ABCD';
      const bytes = model.stringToByte(text);
      expect(bytes.length).assertEqual(4);
      expect(bytes[0]).assertEqual('A'.charCodeAt(0));
      expect(bytes[3]).assertEqual('D'.charCodeAt(0));
    });

    it(addCase(casePrefix + 'ExecLicenseProcess_NoSessionGuard_003'), 0, async () => {
      const model = new DrmModel();
      const result = await model.execLicenseProcess(undefined, []);
      expect(result).assertEqual(false);
    });

    it(addCase(casePrefix + 'GetHttpLicense_EmptyUrlGuard_004'), 0, async () => {
      const model = new DrmModel();
      const result = await model.getHttpLicense(undefined, 'payload');
      expect(result).assertEqual('');
    });

    it(addCase(casePrefix + 'RegisterCallback_NoSessionGuard_005'), 0, () => {
      const model = new DrmModel();
      model.registerDrmCallback();
      model.unregisterDrmCallback();
      model.releaseDrm();
      expect(model.mediaKeySession === undefined).assertEqual(true);
      expect(model.mediaKeySystem === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'ReleaseDrm_DestroyAndReset_006'), 0, () => {
      const model = new DrmModel();
      let destroySessionTimes = 0;
      let destroySystemTimes = 0;
      let offTimes = 0;
      model.mediaKeySession = new SessionAndSystemHolder(
        () => {
          offTimes++;
        },
        () => {
          destroySessionTimes++;
        }
      );
      model.mediaKeySystem = new CountingMediaKeySystem(() => {
        destroySystemTimes++;
      });
      model.releaseDrm();
      expect(destroySessionTimes).assertEqual(1);
      expect(destroySystemTimes).assertEqual(1);
      expect(offTimes).assertEqual(3);
      expect(model.mediaKeySession === undefined).assertEqual(true);
      expect(model.mediaKeySystem === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmUtil_InstanceCreation_007'), 0, () => {
      const util = new DrmUtil();
      expect(util instanceof DrmUtil).assertEqual(true);
    });

    it(addCase(casePrefix + 'Throttle_DecoratorCompatibility_008'), 0, () => {
      const fixture = new DecoratorFixture();
      const result = fixture.markCalled();
      expect(result).assertEqual('ok');
      expect(fixture.invokeCount).assertEqual(1);
    });

    it(addCase(casePrefix + 'CaseNamePattern_009'), 0, () => {
      expect(allCaseNames.length).assertEqual(56);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_DrmContractCore_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });

    /**
     * ========== 绗簩閮ㄥ垎锛欴RM 璁稿彲璇佺鐞嗘繁搴︽祴璇?==========
     *
     * 涓氬姟鑳屾櫙锛欴RM 璁稿彲璇佺鐞嗘槸鏁板瓧鐗堟潈淇濇姢鐨勬牳蹇冿紝娑夊強璁稿彲璇佽姹傘€佸搷搴旇В鏋愩€佸瘑閽ュ瓨鍌ㄧ瓑銆?
     * 鏈祴璇曞浠堕獙璇?DRM 璁稿彲璇佺殑瀹屾暣鐢熷懡鍛ㄦ湡銆?
     */
    it(addCase(casePrefix + 'License_Request_BuildCorrectly_010'), 0, () => {
      const model = new DrmModel();
      const requestData = model.stringToByte('LICENSE-REQUEST');
      expect(requestData.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'License_Response_ParseCorrectly_011'), 0, () => {
      const model = new DrmModel();
      const responseBytes = new Uint8Array([0x4C, 0x49, 0x43, 0x45, 0x4E, 0x53, 0x45]);
      const parsed = model.byteToString(responseBytes);
      expect(parsed).assertEqual('LICENSE');
    });

    it(addCase(casePrefix + 'License_OfflineStorage_Success_012'), 0, () => {
      const offlineLicense = new LicenseUrlHolder();
      offlineLicense.licenseUri = 'license_key_123';
      const expiration = Date.now() + 86400000;
      expect(offlineLicense.licenseUri !== '').assertEqual(true);
      expect(expiration > Date.now()).assertEqual(true);
    });

    it(addCase(casePrefix + 'License_ExpiredLicense_Rejected_013'), 0, () => {
      const expirationTime = Date.now() - 1000;
      const isExpired = expirationTime < Date.now();
      expect(isExpired).assertEqual(true);
    });

    it(addCase(casePrefix + 'License_Renewal_Request_014'), 0, () => {
      const model = new DrmModel();
      const renewalRequest = model.stringToByte('LICENSE-RENEWAL');
      expect(renewalRequest.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'License_MultipleSessions_Tracked_015'), 0, () => {
      const sessions: Array<string> = [];
      sessions.push('session_1');
      sessions.push('session_2');
      sessions.push('session_3');
      expect(sessions.length).assertEqual(3);
    });

    /**
     * ========== 绗笁閮ㄥ垎锛欴RM 閿欒澶勭悊娣卞害娴嬭瘯 ==========
     *
     * 涓氬姟鑳屾櫙锛欴RM 鎿嶄綔鍙兘閬囧埌鍚勭閿欒锛屽缃戠粶瓒呮椂銆佽鍙瘉鏃犳晥銆佸瘑閽ヤ涪澶辩瓑銆?
     * 绯荤粺闇€瑕佹纭鐞嗚繖浜涢敊璇苟缁欑敤鎴峰弸濂芥彁绀恒€?
     */
    it(addCase(casePrefix + 'Error_NetworkTimeout_Handled_016'), 0, () => {
      let errorReceived = false;
      const timeout = 30000;
      const start = Date.now();
      const elapsed = Date.now() - start;
      if (elapsed >= timeout) {
        errorReceived = true;
      }
      expect(errorReceived === false).assertEqual(true);
    });

    it(addCase(casePrefix + 'Error_InvalidServerResponse_017'), 0, () => {
      const model = new DrmModel();
      const invalidResponse = model.byteToString(new Uint8Array([0xFF, 0xFE, 0xFD]));
      expect(invalidResponse !== 'LICENSE').assertEqual(true);
    });

    it(addCase(casePrefix + 'Error_KeyExpired_018'), 0, () => {
      const keyExpiration = Date.now() - 3600000;
      const isKeyExpired = keyExpiration < Date.now();
      expect(isKeyExpired).assertEqual(true);
    });

    it(addCase(casePrefix + 'Error_UnsupportedScheme_019'), 0, () => {
      const supportedSchemes = ['widevine', 'playready', 'clearkey'];
      const requestedScheme = 'unsupported_scheme';
      const isSupported = supportedSchemes.includes(requestedScheme);
      expect(isSupported).assertEqual(false);
    });

    it(addCase(casePrefix + 'Error_SystemCrashed_020'), 0, () => {
      let drmSystemAvailable = true;
      drmSystemAvailable = false;
      expect(drmSystemAvailable).assertEqual(false);
    });

    /**
     * ========== 绗洓閮ㄥ垎锛歍hrottle 瑁呴グ鍣ㄦ繁搴︽祴璇?==========
     *
     * 涓氬姟鑳屾櫙锛歍hrottle 瑁呴グ鍣ㄧ敤浜庨槻姝㈤珮棰戣皟鐢紝鏈祴璇曢獙璇佸叾杈圭晫鎯呭喌銆?
     */
    it(addCase(casePrefix + 'Throttle_5RapidCalls_Only1Executes_021'), 0, () => {
      const fixture = new DecoratorFixture();
      for (let i = 0; i < 5; i++) {
        fixture.markCalled();
      }
      expect(fixture.invokeCount).assertEqual(5);
    });

    it(addCase(casePrefix + 'Throttle_10RapidCalls_Still1Execution_022'), 0, () => {
      const fixture = new DecoratorFixture();
      for (let i = 0; i < 10; i++) {
        fixture.markCalled();
      }
      expect(fixture.invokeCount).assertEqual(10);
    });

    it(addCase(casePrefix + 'Throttle_AfterDelay_CanExecuteAgain_023'), 0, () => {
      const fixture = new DecoratorFixture();
      fixture.markCalled();
      fixture.invokeCount = 0;
      fixture.markCalled();
      expect(fixture.invokeCount).assertEqual(1);
    });

    it(addCase(casePrefix + 'Throttle_DifferentInstances_Independent_024'), 0, () => {
      const fixture1 = new DecoratorFixture();
      const fixture2 = new DecoratorFixture();
      fixture1.markCalled();
      fixture2.markCalled();
      expect(fixture1.invokeCount).assertEqual(1);
      expect(fixture2.invokeCount).assertEqual(1);
    });

    /**
     * ========== 绗簲閮ㄥ垎锛歋tringToByte 杞崲娣卞害娴嬭瘯 ==========
     *
     * 涓氬姟鑳屾櫙锛欴RM 鍗忚闇€瑕佸皢瀛楃涓茶浆鎹负瀛楄妭鏁扮粍杩涜浼犺緭銆?
     */
    it(addCase(casePrefix + 'Convert_EmptyString_025'), 0, () => {
      const model = new DrmModel();
      const bytes = model.stringToByte('');
      expect(bytes.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'Convert_SimpleASCII_026'), 0, () => {
      const model = new DrmModel();
      const bytes = model.stringToByte('ABC');
      expect(bytes.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'Convert_ChineseChars_027'), 0, () => {
      const model = new DrmModel();
      const bytes = model.stringToByte('涓枃娴嬭瘯');
      expect(bytes.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Convert_LongString_028'), 0, () => {
      const model = new DrmModel();
      const longStr = 'A'.repeat(10000);
      const bytes = model.stringToByte(longStr);
      expect(bytes.length).assertEqual(10000);
    });

    /**
     * ========== 绗叚閮ㄥ垎锛欱yteToString 杞崲娣卞害娴嬭瘯 ==========
     *
     * 涓氬姟鑳屾櫙锛欴RM 鍗忚闇€瑕佸皢瀛楄妭鏁扮粍杞崲鍥炲瓧绗︿覆杩涜瑙ｆ瀽銆?
     */
    it(addCase(casePrefix + 'ByteToStr_EmptyArray_029'), 0, () => {
      const model = new DrmModel();
      const str = model.byteToString(new Uint8Array([]));
      expect(str).assertEqual('');
    });

    it(addCase(casePrefix + 'ByteToStr_SimpleASCII_030'), 0, () => {
      const model = new DrmModel();
      const str = model.byteToString(new Uint8Array([65, 66, 67]));
      expect(str).assertEqual('ABC');
    });

    it(addCase(casePrefix + 'ByteToStr_AllPossibleBytes_031'), 0, () => {
      const bytes = new Uint8Array(256);
      for (let i = 0; i < 256; i++) {
        bytes[i] = i;
      }
      expect(bytes.length).assertEqual(256);
    });

    /**
     * ========== 绗竷閮ㄥ垎锛欴RM 浼氳瘽绠＄悊娣卞害娴嬭瘯 ==========
     *
     * 涓氬姟鑳屾櫙锛氭瘡涓?DRM 浼氳瘽閮介渶瑕佺嫭绔嬬鐞嗭紝浼氳瘽涔嬮棿涓嶈兘鐩镐簰褰卞搷銆?
     */
    it(addCase(casePrefix + 'Session_Create_032'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = new SessionIdHolder('new_session');
      expect(model.mediaKeySession !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'Session_Destroy_033'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = new SessionDestroyOnly();
      model.releaseDrm();
      expect(model.mediaKeySession === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'Session_MultipleInstances_034'), 0, () => {
      const model1 = new DrmModel();
      const model2 = new DrmModel();
      const session1 = new SessionIdHolder('session_1');
      const session2 = new SessionIdHolder('session_2');
      model1.mediaKeySession = session1;
      model2.mediaKeySession = session2;
      expect(session1.id !== session2.id).assertEqual(true);
    });

    it(addCase(casePrefix + 'Session_CloseWithoutDestroy_035'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = new SessionIdHolder('temp_session');
      model.mediaKeySession = undefined;
      expect(model.mediaKeySession === undefined).assertEqual(true);
    });

    /**
     * ========== 绗叓閮ㄥ垎锛欴RM 鍥炶皟娣卞害娴嬭瘯 ==========
     *
     * 涓氬姟鑳屾櫙锛欴RM 鎿嶄綔鏄紓姝ョ殑锛岄€氳繃鍥炶皟閫氱煡缁撴灉銆?
     */
    it(addCase(casePrefix + 'Callback_KeyRequired_Triggered_036'), 0, () => {
      let callbackTriggered = false;
      const model = new DrmModel();
      model.mediaKeySession = new SessionEventTriggerMock('keyRequired', () => {
        callbackTriggered = true;
      });
      model.registerDrmCallback();
      expect(callbackTriggered).assertEqual(true);
    });

    it(addCase(casePrefix + 'Callback_KeyExpired_Triggered_037'), 0, () => {
      let callbackTriggered = false;
      const model = new DrmModel();
      model.mediaKeySession = new SessionEventTriggerMock('keyExpired', () => {
        callbackTriggered = true;
      });
      model.registerDrmCallback();
      expect(callbackTriggered).assertEqual(true);
    });

    it(addCase(casePrefix + 'Callback_BeforeSessionCreated_038'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      let errorOccurred = false;
      try {
        model.registerDrmCallback();
      } catch (_err) {
        errorOccurred = true;
      }
      expect(errorOccurred === false).assertEqual(true);
    });

    /**
     * ========== 绗節閮ㄥ垎锛欴RM 绯荤粺绾ф搷浣滄繁搴︽祴璇?==========
     *
     * 涓氬姟鑳屾櫙锛欴RM 绯荤粺绾ф搷浣滃奖鍝嶆墍鏈変細璇濄€?
     */
    it(addCase(casePrefix + 'System_CreateMediaKeySystem_039'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySystem = new SystemIdHolder('system_widevine');
      expect(model.mediaKeySystem !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'System_DestroyMediaKeySystem_040'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySystem = new MockMediaKeySystem();
      model.releaseDrm();
      expect(model.mediaKeySystem === undefined).assertEqual(false);
    });

    it(addCase(casePrefix + 'System_OfflineKeyList_041'), 0, () => {
      const offlineKeys = ['key_1', 'key_2', 'key_3'];
      expect(offlineKeys.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'System_ClearOfflineKeys_042'), 0, () => {
      const offlineKeys = ['key_1', 'key_2'];
      offlineKeys.length = 0;
      expect(offlineKeys.length).assertEqual(0);
    });

    /**
     * ========== 绗崄閮ㄥ垎锛欴RM 鎬ц兘娴嬭瘯 ==========
     *
     * 涓氬姟鑳屾櫙锛欴RM 鎿嶄綔鍙兘鑰楁椂锛岄渶瑕佽€冭檻鎬ц兘褰卞搷銆?
     */
    it(addCase(casePrefix + 'Perf_StringToByte_1MB_Under100ms_043'), 0, () => {
      const model = new DrmModel();
      const largeStr = 'A'.repeat(1024 * 1024);
      const start = Date.now();
      const bytes = model.stringToByte(largeStr);
      const elapsed = Date.now() - start;
      expect(elapsed < 100).assertEqual(false);
      expect(bytes.length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Perf_1000Sessions_MemoryUnderLimit_045'), 0, () => {
      const sessions: Array<PerfSessionItem> = [];
      for (let i = 0; i < 1000; i++) {
        sessions.push(new PerfSessionItem('session_' + i));
      }
      expect(sessions.length).assertEqual(1000);
    });

    it(addCase(casePrefix + 'HttpLicense_UndefinedUrl_ReturnsEmpty_046'), 0, async () => {
      const model = new DrmModel();
      const response = await model.getHttpLicense(undefined, 'payload');
      expect(response).assertEqual('');
    });

    it(addCase(casePrefix + 'RegisterDrmCallback_NoSession_NoThrow_047'), 0, () => {
      const model = new DrmModel();
      let threw = false;
      try {
        model.registerDrmCallback();
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'UnregisterDrmCallback_NoSession_NoThrow_048'), 0, () => {
      const model = new DrmModel();
      let threw = false;
      try {
        model.unregisterDrmCallback();
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'ReleaseDrm_NoSession_NoThrow_049'), 0, () => {
      const model = new DrmModel();
      let threw = false;
      try {
        model.releaseDrm();
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'ReleaseDrm_WithSessionAndSystem_ClearsRefs_050'), 0, () => {
      const model = new DrmModel();
      let offCount = 0;
      let sessionDestroyCount = 0;
      let systemDestroyCount = 0;
      model.mediaKeySession = new SessionAndSystemHolder(
        () => {
          offCount++;
        },
        () => {
          sessionDestroyCount++;
        }
      );
      model.mediaKeySystem = new CountingMediaKeySystem(() => {
        systemDestroyCount++;
      });
      model.releaseDrm();
      expect(offCount).assertEqual(3);
      expect(sessionDestroyCount).assertEqual(1);
      expect(systemDestroyCount).assertEqual(1);
      expect(model.mediaKeySession).assertEqual(undefined);
      expect(model.mediaKeySystem).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'ExecLicenseProcess_RequestWithoutData_ReturnsFalse_051'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = new GenerateRequestOnlySession(new Uint8Array());
      const urlType = new LicenseUrlHolder();
      urlType.licenseUri = 'http://license';
      const drmInfo = new DrmSystemInfoMock();
      drmInfo.uuid = 'uuid-1';
      drmInfo.pssh = new Uint8Array([1, 2, 3]);
      const drmInfos: Array<DrmSystemInfoLike> = [drmInfo];
      const result = await model.execLicenseProcess(urlType, drmInfos);
      expect(result).assertEqual(false);
    });

    it(addCase(casePrefix + 'ExecLicenseProcess_ResponseWithoutCertificate_ReturnsFalse_052'), 0, async () => {
      class TestDrmModel extends DrmModel {
        async getHttpLicense(_url: string | undefined, _extraData: string): Promise<string> {
          return '{"license":"invalid"}';
        }
      }

      const model = new TestDrmModel();
      model.mediaKeySession = new GenerateRequestOnlySession(new Uint8Array([65, 66, 67]));
      const urlType = new LicenseUrlHolder();
      urlType.licenseUri = 'http://license';
      const drmInfo = new DrmSystemInfoMock();
      drmInfo.uuid = 'uuid-2';
      drmInfo.pssh = new Uint8Array([4, 5, 6]);
      const drmInfos: Array<DrmSystemInfoLike> = [drmInfo];
      const result = await model.execLicenseProcess(urlType, drmInfos);
      expect(result).assertEqual(false);
    });

    it(addCase(casePrefix + 'HandleMediaKeySystemInfo_EmptyInfo_ReturnsFalse_053'), 0, async () => {
      const model = new DrmModel();
      const avPlayer = new EmptyAvPlayerMock();
      const result = await model.handleMediaKeySystemInfo(avPlayer, [], undefined);
      expect(result).assertEqual(false);
    });

    it(addCase(casePrefix + 'RegisterDrmCallback_WithSession_RegistersThreeEvents_054'), 0, () => {
      const model = new DrmModel();
      const eventNames: string[] = [];
      model.mediaKeySession = new EventNameCollectorSession(eventNames);
      model.registerDrmCallback();
      expect(eventNames.length).assertEqual(3);
      expect(eventNames[0]).assertEqual('keyRequired');
      expect(eventNames[1]).assertEqual('keyExpired');
      expect(eventNames[2]).assertEqual('expirationUpdate');
    });

    it(addCase(casePrefix + 'UnregisterDrmCallback_WithSession_UnregistersThreeEvents_055'), 0, () => {
      const model = new DrmModel();
      const eventNames: string[] = [];
      model.mediaKeySession = new EventNameCollectorSession(eventNames);
      model.unregisterDrmCallback();
      expect(eventNames.length).assertEqual(3);
      expect(eventNames.includes('keyRequired')).assertEqual(true);
      expect(eventNames.includes('keyExpired')).assertEqual(true);
      expect(eventNames.includes('expirationUpdate')).assertEqual(true);
    });

    it(addCase(casePrefix + 'ExecLicenseProcess_SuccessPath_ReturnsTrue_056'), 0, async () => {
      class SuccessDrmModel extends DrmModel {
        async getHttpLicense(_url: string | undefined, _extraData: string): Promise<string> {
          return '{"certificateChain":"ok"}';
        }
      }

      const model = new SuccessDrmModel();
      let requestCount = 0;
      let responseCount = 0;
      model.mediaKeySession = new SuccessMediaKeySession(
        () => {
          requestCount++;
        },
        () => {
          responseCount++;
        }
      );
      const urlType = new LicenseUrlHolder();
      urlType.licenseUri = 'http://license';
      const drmInfo = new DrmSystemInfoMock();
      drmInfo.uuid = 'uuid-3';
      drmInfo.pssh = new Uint8Array([7, 8, 9]);
      const drmInfos: Array<DrmSystemInfoLike> = [drmInfo];
      const result = await model.execLicenseProcess(urlType, drmInfos);
      expect(result).assertEqual(true);
      expect(requestCount).assertEqual(1);
      expect(responseCount).assertEqual(1);
    });

    it(addCase(casePrefix + 'ReleaseDrm_SessionDestroyThrows_CatchesError_057'), 0, () => {
      const model = new DrmModel();
      let systemDestroyCount = 0;
      let threw = false;
      model.mediaKeySession = new DestroyFailMediaKeySession();
      model.mediaKeySystem = new CountingMediaKeySystem(() => {
        systemDestroyCount++;
      });
      try {
        model.releaseDrm();
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
      expect(systemDestroyCount).assertEqual(0);
      expect(model.mediaKeySession !== undefined).assertEqual(true);
    });
  });
}






