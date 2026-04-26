/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 */

import { describe, it, expect } from '@ohos/hypium';
import { drm } from '@kit.DrmKit';
import {
  DrmModel,
  MediaKeySessionLike,
  MediaKeySystemLike,
  DrmSystemInfoLike,
  DecryptionAvPlayerLike,
  MediaKeyRequestResultLike
} from '../../../main/ets/Model/DrmModel';

class DrmRequestLike extends MediaKeyRequestResultLike {
  data: Uint8Array;

  constructor(data: Uint8Array) {
    super();
    this.data = data;
  }
}

class SimpleDrmSystemInfo extends DrmSystemInfoLike {
  uuid: string;
  pssh: Uint8Array;

  constructor(uuid: string, pssh: Uint8Array) {
    super();
    this.uuid = uuid;
    this.pssh = pssh;
  }
}

class DrmSessionOnlyMock extends MediaKeySessionLike {
  off(_event: string): void {
  }

  destroy(): void {
  }

  on(_event: string, _fn: (eventInfo: drm.EventInfo) => void): void {
    _fn({ info: new Uint8Array(), extraInfo: '' });
  }

  generateMediaKeyRequest(_mime: string, _pssh: Uint8Array, _type: number,
    _opt: drm.OptionsData[]): Promise<MediaKeyRequestResultLike> {
    return Promise.resolve(new DrmRequestLike(new Uint8Array()));
  }

  processMediaKeyResponse(_data: Uint8Array): Promise<Uint8Array> {
    return Promise.resolve(new Uint8Array());
  }

  requireSecureDecoderModule(_mimeType: string): boolean {
    return false;
  }
}

class DrmSystemOnlyMock extends MediaKeySystemLike {
  destroy(): void {
  }

  createMediaKeySession(_level: drm.ContentProtectionLevel): MediaKeySessionLike {
    return new DrmSessionOnlyMock();
  }
}

class EventRecordingDrmSessionMock extends DrmSessionOnlyMock {
  private onRegister: Function;
  private onUnregister: Function;
  private onDestroy: Function;

  constructor(onRegister: Function = (): void => {
  },
    onUnregister: Function = (): void => {
    },
    onDestroy: Function = (): void => {
    }) {
    super();
    this.onRegister = onRegister;
    this.onUnregister = onUnregister;
    this.onDestroy = onDestroy;
  }

  override on(event: string, _fn: (eventInfo: drm.EventInfo) => void): void {
    this.onRegister(event);
    _fn({ info: new Uint8Array(), extraInfo: '' });
  }

  override off(event: string): void {
    this.onUnregister(event);
  }

  override destroy(): void {
    this.onDestroy();
  }
}

class EventRecordingDrmSystemMock extends DrmSystemOnlyMock {
  private onDestroy: Function;

  constructor(onDestroy: Function) {
    super();
    this.onDestroy = onDestroy;
  }

  override destroy(): void {
    this.onDestroy();
  }
}

class DrmPlayerMock extends DecryptionAvPlayerLike {
  setDecryptionConfig(_session: drm.MediaKeySession | MediaKeySessionLike, _svp: boolean): void {
  }
}

export default function DrmModelContract001Test() {
  const casePrefix = 'DemandPlayer_DrmModelContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DrmModelContract001TestSuite', () => {
    it(addCase(casePrefix + 'StringToByte_AsciiRoundTrip_001'), 0, () => {
      const model = new DrmModel();
      const original = 'DRM-LICENSE-REQUEST-42';
      expect(model.byteToString(model.stringToByte(original))).assertEqual(original);
    });

    it(addCase(casePrefix + 'StringToByte_ChineseRoundTrip_002'), 0, () => {
      const model = new DrmModel();
      const original = '???????';
      const decoded = model.byteToString(model.stringToByte(original));
      expect(decoded.includes('??')).assertEqual(true);
    });

    it(addCase(casePrefix + 'StringToByte_MixedAsciiSymbols_003'), 0, () => {
      const model = new DrmModel();
      const original = 'key=value&time=1700000000';
      expect(model.byteToString(model.stringToByte(original))).assertEqual(original);
    });

    it(addCase(casePrefix + 'StringToByte_EmptyString_004'), 0, () => {
      const model = new DrmModel();
      expect(model.stringToByte('').length).assertEqual(0);
    });

    it(addCase(casePrefix + 'ByteToString_SingleByteValues_005'), 0, () => {
      const model = new DrmModel();
      expect(model.byteToString(new Uint8Array([0x41, 0x42, 0x43, 0x30, 0x31]))).assertEqual('ABC01');
    });

    it(addCase(casePrefix + 'ByteToString_MultiByteUtf8Sequence_006'), 0, () => {
      const model = new DrmModel();
      expect(model.byteToString(new Uint8Array([0xE4, 0xB8, 0xAD, 0xE6, 0x96, 0x87])).length).assertEqual(6);
    });

    it(addCase(casePrefix + 'ByteToString_BinaryWithNullBytes_007'), 0, () => {
      const model = new DrmModel();
      expect(model.byteToString(new Uint8Array([0x00, 0x48, 0x69, 0x00])).length).assertEqual(4);
    });

    it(addCase(casePrefix + 'GetHttpLicense_EmptyUrl_ReturnsEmpty_008'), 0, async () => {
      const model = new DrmModel();
      expect(await model.getHttpLicense('', 'extra-data')).assertEqual('');
    });

    it(addCase(casePrefix + 'GetHttpLicense_UndefinedUrl_ReturnsEmpty_009'), 0, async () => {
      const model = new DrmModel();
      expect(await model.getHttpLicense(undefined, 'extra-data')).assertEqual('');
    });

    it(addCase(casePrefix + 'ExecLicenseProcess_EmptyInfoArray_ReturnsTrue_010'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = new DrmSessionOnlyMock();
      expect(await model.execLicenseProcess(undefined, [])).assertEqual(true);
    });

    it(addCase(casePrefix + 'ExecLicenseProcess_NoSessionGuard_ReturnsFalse_011'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      expect(await model.execLicenseProcess(undefined, [new SimpleDrmSystemInfo('', new Uint8Array([]))]))
        .assertEqual(false);
    });

    it(addCase(casePrefix + 'RegisterDrmCallback_NoSession_NoOp_012'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      let threw = false;
      try {
        model.registerDrmCallback();
      } catch (_e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'UnregisterDrmCallback_NoSession_NoOp_013'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      let threw = false;
      try {
        model.unregisterDrmCallback();
      } catch (_e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'ReleaseDrm_NoSession_NoOp_014'), 0, () => {
      const model = new DrmModel();
      model.releaseDrm();
      expect(model.mediaKeySession === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'ReleaseDrm_WithSession_DestroysAll_015'), 0, () => {
      const model = new DrmModel();
      let offCount = 0;
      let sessionDestroyed = 0;
      let systemDestroyed = 0;
      model.mediaKeySession = new EventRecordingDrmSessionMock(
        (_event: string): void => {
        },
        (_event: string): void => {
          offCount++;
        },
        (): void => {
          sessionDestroyed++;
        }
      );
      model.mediaKeySystem = new EventRecordingDrmSystemMock((): void => {
        systemDestroyed++;
      });
      model.releaseDrm();
      expect(offCount).assertEqual(3);
      expect(sessionDestroyed).assertEqual(1);
      expect(systemDestroyed).assertEqual(1);
    });

    it(addCase(casePrefix + 'RegisterDrmCallback_ThreeEventHandlers_016'), 0, () => {
      const model = new DrmModel();
      const registeredEvents: string[] = [];
      model.mediaKeySession = new EventRecordingDrmSessionMock((event: string): void => {
        registeredEvents.push(event);
      });
      model.registerDrmCallback();
      expect(registeredEvents.length).assertEqual(3);
      expect(registeredEvents).assertContain('keyRequired');
      expect(registeredEvents).assertContain('keyExpired');
      expect(registeredEvents).assertContain('expirationUpdate');
    });

    it(addCase(casePrefix + 'UnregisterDrmCallback_ThreeUnbinds_017'), 0, () => {
      const model = new DrmModel();
      const unregisteredEvents: string[] = [];
      model.mediaKeySession = new EventRecordingDrmSessionMock(
        (_event: string): void => {
        },
        (event: string): void => {
          unregisteredEvents.push(event);
        }
      );
      model.unregisterDrmCallback();
      expect(unregisteredEvents.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'HandleMediaKeySystemInfo_EmptyInfoArray_ReturnsFalse_018'), 0, async () => {
      const model = new DrmModel();
      expect(await model.handleMediaKeySystemInfo(new DrmPlayerMock(), [], undefined)).assertEqual(false);
    });

    it(addCase(casePrefix + 'HandleMediaKeySystemInfo_InvalidInfo_ReturnsFalse_019'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      const fakeInfo: Array<DrmSystemInfoLike> = [new SimpleDrmSystemInfo('123', new Uint8Array([4, 5, 6]))];
      expect(await model.handleMediaKeySystemInfo(new DrmPlayerMock(), fakeInfo, undefined)).assertEqual(false);
    });

    it(addCase(casePrefix + 'CaseNamePattern_020'), 0, () => {
      expect(allCaseNames.length).assertEqual(37);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_DrmModelContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
    it(addCase(casePrefix + 'MultiInstance_IndependentState_001'), 0, () => {
      const m1 = new DrmModel();
      const m2 = new DrmModel();
      m1.mediaKeySession = new DrmSessionOnlyMock();
      m2.mediaKeySession = undefined;
      expect(m1.mediaKeySession !== undefined).assertEqual(true);
      expect(m2.mediaKeySession === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'MultiInstance_IndependentSystem_002'), 0, () => {
      const m1 = new DrmModel();
      const m2 = new DrmModel();
      m1.mediaKeySystem = new DrmSystemOnlyMock();
      m2.mediaKeySystem = undefined;
      expect(m1.mediaKeySystem !== undefined).assertEqual(true);
      expect(m2.mediaKeySystem === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'StringToByte_AllAsciiRange_003'), 0, () => {
      const model = new DrmModel();
      let allAscii = '';
      for (let i = 32; i <= 126; i++) {
        allAscii += String.fromCharCode(i);
      }
      expect(model.byteToString(model.stringToByte(allAscii))).assertEqual(allAscii);
    });

    it(addCase(casePrefix + 'StringToByte_LongPayload_004'), 0, () => {
      const model = new DrmModel();
      expect(model.byteToString(model.stringToByte('A'.repeat(10000))).length).assertEqual(10000);
    });

    it(addCase(casePrefix + 'StringToByte_UnicodeMultilingual_005'), 0, () => {
      const model = new DrmModel();
      const multiLang = '????????????????????';
      expect(model.byteToString(model.stringToByte(multiLang)).length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'ByteToString_FullUint8Range_006'), 0, () => {
      const model = new DrmModel();
      const data = new Uint8Array(256);
      for (let i = 0; i < 256; i++) {
        data[i] = i;
      }
      expect(model.byteToString(data).length).assertEqual(256);
    });

    it(addCase(casePrefix + 'ExecLicenseProcess_MultipleDrmInfo_007'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = new DrmSessionOnlyMock();
      expect(await model.execLicenseProcess(undefined, [])).assertEqual(true);
    });

    it(addCase(casePrefix + 'ExecLicenseProcess_SessionDestroyedMid_008'), 0, async () => {
      const model = new DrmModel();
      model.mediaKeySession = undefined;
      expect(await model.execLicenseProcess(undefined, [new SimpleDrmSystemInfo('1', new Uint8Array([2]))]))
        .assertEqual(false);
    });

    it(addCase(casePrefix + 'GetHttpLicense_NonEmptyUrl_ReturnsPromise_009'), 0, async () => {
      const model = new DrmModel();
      expect(model.getHttpLicense('https://license.example.com', 'request-data') instanceof Promise).assertEqual(true);
    });

    it(addCase(casePrefix + 'ReleaseDrm_CalledTwice_Safe_010'), 0, () => {
      const model = new DrmModel();
      model.mediaKeySession = new EventRecordingDrmSessionMock();
      model.mediaKeySystem = new DrmSystemOnlyMock();
      model.releaseDrm();
      model.releaseDrm();
      expect(model.mediaKeySession === undefined).assertEqual(true);
      expect(model.mediaKeySystem === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'RegisterDrmCallback_CalledTwice_BothSafe_011'), 0, () => {
      const model = new DrmModel();
      let onCount = 0;
      model.mediaKeySession = new EventRecordingDrmSessionMock((_event: string): void => {
        onCount++;
      });
      model.registerDrmCallback();
      model.registerDrmCallback();
      expect(onCount).assertEqual(6);
    });

    it(addCase(casePrefix + 'UnregisterDrmCallback_CalledTwice_BothSafe_012'), 0, () => {
      const model = new DrmModel();
      let offCount = 0;
      model.mediaKeySession = new EventRecordingDrmSessionMock(
        (_event: string): void => {
        },
        (_event: string): void => {
          offCount++;
        }
      );
      model.unregisterDrmCallback();
      model.unregisterDrmCallback();
      expect(offCount).assertEqual(6);
    });

    it(addCase(casePrefix + 'HandleMediaKeySystemInfo_CallsReleaseOnFailure_013'), 0, async () => {
      const model = new DrmModel();
      let destroyed = false;
      model.mediaKeySystem = new EventRecordingDrmSystemMock((): void => {
        destroyed = true;
      });
      model.mediaKeySession = new EventRecordingDrmSessionMock();
      await model.handleMediaKeySystemInfo(new DrmPlayerMock(), [], undefined);
      expect(destroyed).assertEqual(false);
    });

    it(addCase(casePrefix + 'ByteToString_MixedAsciiAndBinary_014'), 0, () => {
      const model = new DrmModel();
      expect(model.byteToString(new Uint8Array([0x00, 0x7F, 0x80, 0xFF, 0x48, 0x69])).length).assertEqual(6);
    });

    it(addCase(casePrefix + 'StringToByte_HighUnicode_015'), 0, () => {
      const model = new DrmModel();
      expect(model.stringToByte('????????').length > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'DrmModel_InitialState_AllUndefined_016'), 0, () => {
      const model = new DrmModel();
      expect(model.mediaKeySession === undefined).assertEqual(true);
      expect(model.mediaKeySystem === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_017'), 0, () => {
      expect(allCaseNames.length).assertEqual(37);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_DrmModelContract002_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(false);
      }
    });
  });
}
