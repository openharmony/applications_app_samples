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
import { log } from '../utils/log';
import { drm } from '@kit.DrmKit';
import { JSON } from '@kit.ArkTS';
import { media } from '@kit.MediaKit';
import { UrlType } from '../const/Type';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

export abstract class DrmSystemInfoLike {
  abstract uuid: string;
  abstract pssh: Uint8Array;
}

export abstract class MediaKeyRequestResultLike {
  abstract data: Uint8Array;
}

export abstract class MediaKeySessionLike {
  abstract on(name: string, cb: (eventInfo: drm.EventInfo) => void): void;
  abstract off(name: string): void;
  abstract destroy(): void;
  abstract generateMediaKeyRequest(mime: string, pssh: Uint8Array, type: number,
    opt: drm.OptionsData[]): Promise<drm.MediaKeyRequest | MediaKeyRequestResultLike>;
  abstract processMediaKeyResponse(data: Uint8Array): Promise<Uint8Array>;
  abstract requireSecureDecoderModule(mimeType: string): boolean;
}

export abstract class MediaKeySystemLike {
  abstract createMediaKeySession(level: drm.ContentProtectionLevel): drm.MediaKeySession | MediaKeySessionLike;
  abstract destroy(): void;
}

export abstract class DecryptionAvPlayerLike {
  abstract setDecryptionConfig(session: drm.MediaKeySession | MediaKeySessionLike, svp: boolean): void;
}

const DRM_SOLUTION_NAME = 'com.wiseplay.drm';
const DRM_EVENT_KEY_REQUIRED: 'keyRequired' = 'keyRequired';
const DRM_EVENT_KEY_EXPIRED: 'keyExpired' = 'keyExpired';
const DRM_EVENT_KEY_EXPIRATION_UPDATE: 'expirationUpdate' = 'expirationUpdate';

export class DrmModel {
  public mediaKeySystem: drm.MediaKeySystem | MediaKeySystemLike | undefined = undefined;
  public mediaKeySession: drm.MediaKeySession | MediaKeySessionLike | undefined = undefined;

  static isMediaKeySystemSupport(): boolean {
    if (!drm.isMediaKeySystemSupported(DRM_SOLUTION_NAME)) {
      log('isMediaKeySystemSupported, not support ' + DRM_SOLUTION_NAME);
      return false;
    }
    let mediaKeySystem: drm.MediaKeySystem | undefined = undefined;
    try {
      mediaKeySystem = drm.createMediaKeySystem(DRM_SOLUTION_NAME);
      let mediaKeySession = mediaKeySystem.createMediaKeySession(
        drm.ContentProtectionLevel.CONTENT_PROTECTION_LEVEL_SW_CRYPTO);
      mediaKeySession.destroy();
      mediaKeySystem.destroy();
      log(`isMediaKeySystemSupport true`);
      return true;
    } catch (err) {
      mediaKeySystem?.destroy();
      let error = err as BusinessError;
      log(`isMediaKeySystemSupport ERROR: ${error}`);
      return false;
    }
  }

  async handleMediaKeySystemInfo(avPlayer: media.AVPlayer | DecryptionAvPlayerLike,
    mediaKeySystemInfo: Array<drm.MediaKeySystemInfo | DrmSystemInfoLike>, urlType: UrlType | undefined): Promise<boolean> {
    if (mediaKeySystemInfo.length < 1) {
      log('handleDrmMediaInfo failed, mediaKeySystemInfo is empty');
      return false;
    }
    let drmInfoArr: Array<drm.MediaKeySystemInfo | DrmSystemInfoLike> = mediaKeySystemInfo;
    if (!drm.isMediaKeySystemSupported(DRM_SOLUTION_NAME)) {
      log('handleDrmMediaInfo failed, not support ' + DRM_SOLUTION_NAME);
      return false;
    }
    try {
      this.mediaKeySystem = drm.createMediaKeySystem(DRM_SOLUTION_NAME);
      this.mediaKeySession = (this.mediaKeySystem as drm.MediaKeySystem | MediaKeySystemLike).createMediaKeySession(
        drm.ContentProtectionLevel.CONTENT_PROTECTION_LEVEL_SW_CRYPTO);
    } catch (err) {
      let error = err as BusinessError;
      log(`createMediaKeySystem or createMediaKeySession ERROR: ${error}`);
      return false;
    }
    this.registerDrmCallback();
    if (!await this.execLicenseProcess(urlType, drmInfoArr)) {
      log('drm execLicenseProcess failed');
      return false;
    }
    let mediaKeySession = this.mediaKeySession;
    if (!mediaKeySession) {
      log('setDecryptionConfig failed, mediaKeySession is undefined');
      return false;
    }
    let svp: boolean = mediaKeySession.requireSecureDecoderModule('video/avc');
    log('setDecryptionConfig svp:' + svp);
    avPlayer.setDecryptionConfig(mediaKeySession as drm.MediaKeySession, svp);
    return true;
  }

  async execLicenseProcess(urlType: UrlType | undefined,
    drmInfoArr: Array<drm.MediaKeySystemInfo | DrmSystemInfoLike>): Promise<boolean> {
    if (!this.mediaKeySession) {
      log('execLicenseProcess return, no mediaKeySession');
      return false;
    }
    for (let i = 0; i < drmInfoArr.length; i++) {
      try {
        log('drmInfoArr - uuid: ' + drmInfoArr[i].uuid);
        log('drmInfoArr - pssh: ' + drmInfoArr[i].pssh);
        const optionsData: drm.OptionsData[] = [{
          name: 'optionalDataName',
          value: 'optionalDataValue'
        }];
        const uint8pssh: Uint8Array = new Uint8Array(drmInfoArr[i].pssh);
        const licenseRequest = await this.mediaKeySession.generateMediaKeyRequest('video/mp4', uint8pssh,
          drm.MediaKeyType.MEDIA_KEY_TYPE_ONLINE, optionsData);
        if (!licenseRequest.data) {
          log('generateMediaKeyRequest failed, licenseRequest data empty');
          return false;
        }
        let licenseRequestStr: string = this.byteToString(licenseRequest.data);
        let licenseResponseStr: string = await this.getHttpLicense(urlType?.licenseUri, licenseRequestStr);
        if (!licenseResponseStr.match('certificateChain')) {
          log('getHttpLicense failed, no certificateChain');
          return false;
        }
        let licenseResponseData: Uint8Array = this.stringToByte(licenseResponseStr);
        let mediaKeyId: Uint8Array = await this.mediaKeySession.processMediaKeyResponse(licenseResponseData);
        log('processMediaKeyResponse success, mediaKeyId:' + mediaKeyId);
      } catch (err) {
        let error = err as BusinessError;
        log(`execLicenseProcess: ERROR: ${error}`);
        return false;
      }
    }
    return true;
  }

  byteToString(arr: Uint8Array): string {
    let str: string = '';
    let _arr: Uint8Array = arr;
    for (let i = 0; i < _arr.length; i++) {
      let binaryStr: string = _arr[i].toString(2);
      let matchArray = binaryStr.match(new RegExp('/^1+?(?=0)/'));
      if (matchArray && binaryStr.length == 8) {
        let bytesLength: number = matchArray[0].length;
        let store: string = _arr[i].toString(2).slice(7 - bytesLength);
        for (let j = 1; j < bytesLength; j++) {
          store += _arr[j + i].toString(2).slice(2);
        }
        str += String.fromCharCode(Number.parseInt(store, 2));
        i += bytesLength - 1;
      } else {
        str += String.fromCharCode(_arr[i]);
      }
    }
    return str;
  }

  stringToByte(str: string): Uint8Array {
    let bytes: number[] = [];
    let unicode: number;
    for (let i = 0; i < str.length; i++) {
      unicode = str.charCodeAt(i);
      if (unicode >= 0x010000 && unicode <= 0x10FFFF) {
        bytes.push(((unicode >> 18) & 0x07) | 0xf0);
        bytes.push(((unicode >> 12) & 0x3F) | 0x80);
        bytes.push(((unicode >> 6) & 0x3f) | 0x80);
        bytes.push((unicode & 0x3F) | 0x80);
      } else if (unicode >= 0x000800 && unicode <= 0x00FFF) {
        bytes.push(((unicode >> 12) & 0x07) | 0xf0);
        bytes.push(((unicode >> 6) & 0x3F) | 0x80);
        bytes.push((unicode & 0x3F) | 0x80);
      } else if (unicode >= 0x000800 && unicode <= 0x0007F) {
        bytes.push(((unicode >> 6) & 0x3F) | 0x80);
        bytes.push((unicode & 0x3F) | 0x80);
      } else {
        bytes.push(unicode & 0xFF);
      }
    }
    return new Uint8Array(bytes);
  }

  async getHttpLicense(url: string | undefined, _extraData: string): Promise<string> {
    if (!url) {
      log('url is undefined');
      return '';
    }
    log('get license:' + url);
    let responseData: string = '';
    let httpRequest = http.createHttp();
    try {
      let response = await httpRequest.request(url, {
        method: http.RequestMethod.POST,
        header: {
          'Content-type': 'application/json',
          'Accept-Encoding': 'gzip, deflate',
        },
        extraData: _extraData,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 2000,
        readTimeout: 2000,
      });

      if (response?.responseCode == http.ResponseCode.OK) {
        if (typeof response.result == 'string') {
          responseData = response.result;
          log('httpRequest success');
        } else {
          log('httpRequest failed, result:' + typeof response.result);
        }
        httpRequest.destroy();
      } else {
        log('httpRequest failed, responseCode:' + response?.responseCode);
      }
    } catch (e) {
      log('httpRequest failed, e:' + JSON.stringify(e));
    }
    return responseData;
  }

  registerDrmCallback(): void {
    if (!this.mediaKeySession) {
      log('registerDrmCallback return, no mediaKeySession');
      return;
    }
    this.mediaKeySession.on(DRM_EVENT_KEY_REQUIRED, (eventInfo: drm.EventInfo) => {
      log('keyRequired info:' + eventInfo.info + ' extraInfo:' + eventInfo.extraInfo);
    });

    this.mediaKeySession.on(DRM_EVENT_KEY_EXPIRED, (eventInfo: drm.EventInfo) => {
      log('keyExpired info:' + eventInfo.info + ' extraInfo:' + eventInfo.extraInfo);
    });

    this.mediaKeySession.on(DRM_EVENT_KEY_EXPIRATION_UPDATE, (eventInfo: drm.EventInfo) => {
      log('expirationUpdate info:' + eventInfo.info + ' extraInfo:' + eventInfo.extraInfo);
    });
  }

  unregisterDrmCallback(): void {
    if (!this.mediaKeySession) {
      log('unregisterDrmCallback return, no mediaKeySession');
      return;
    }
    this.mediaKeySession.off(DRM_EVENT_KEY_REQUIRED);
    this.mediaKeySession.off(DRM_EVENT_KEY_EXPIRED);
    this.mediaKeySession.off(DRM_EVENT_KEY_EXPIRATION_UPDATE);
  }

  releaseDrm(): void {
    if (!this.mediaKeySession) {
      log('releaseDrm return, no mediaKeySession');
      return;
    }
    try {
      log('releaseDrm');
      this.unregisterDrmCallback();
      this.mediaKeySession.destroy();
      this.mediaKeySystem?.destroy();
      this.mediaKeySession = undefined;
      this.mediaKeySystem = undefined;
    } catch (err) {
      let error = err as BusinessError;
      console.error(`mediaKeySession destroy ERROR: ${error}`);
    }
  }
}
