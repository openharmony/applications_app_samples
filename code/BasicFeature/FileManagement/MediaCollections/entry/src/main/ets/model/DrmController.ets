/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import drm from '@ohos.multimedia.drm'
import media from '@ohos.multimedia.media'
import DrmConstants, { KeySessionEvents } from '../common/constants/DrmConstants'
import Logger from './Logger'
import TypeConversion from './TypeConversion'
import HttpUtil from './HttpUtil'
import KVManagerUtil from './KVManagerUtil'

/**
 * drmInfo 接口类型
 */
export interface drmInfo {
  uuid: string,
  pssh: Uint8Array,
}

export default class DrmController {
  private TAG: string = 'DrmController'
  private mediaKeySystem: drm.MediaKeySystem = {} as drm.MediaKeySystem
  private mediaKeySession: drm.MediaKeySession = {} as drm.MediaKeySession
  private uuid: string = ''
  private svp: boolean = false

  /**
   * 判断系统是否支持 drm 能力
   */
  isDrmSupported(): boolean {
    if (drm.isMediaKeySystemSupported(DrmConstants.WISEPLAY_DRM_UUID)) {
      this.uuid = DrmConstants.WISEPLAY_DRM_UUID
      return true
    } else if (drm.isMediaKeySystemSupported(DrmConstants.CLEAR_PLAY_DRM_UUID)) {
      this.uuid = DrmConstants.CLEAR_PLAY_DRM_UUID
      return true
    }
    return false
  }

  /**
   * 创建 MediaKeySystem、KeySession 实例
   */
  createDrmSystem() {
    this.mediaKeySystem = drm.createMediaKeySystem(this.uuid)
    if (!this.mediaKeySystem) {
      Logger.error(this.TAG, 'getMediaKeySystem fail!')
      return
    }
    Logger.info(this.TAG, 'MediaKeySystem has been created.')

    // 若无证书，此接口会返回失败
    this.mediaKeySession = this.mediaKeySystem.createMediaKeySession(drm.SecurityLevel.SECURITY_LEVEL_SW_CRYPTO)
    if (this.mediaKeySession) {
      Logger.info(this.TAG, 'mediaKeySession has been created.')
      this.svp = this.mediaKeySession.requireSecureDecoderModule('video/avc')
      this.setDrmCallback()
    } else {
      Logger.error(this.TAG, 'createKeySession fail!')
      this.getProvision()
    }
  }

  /**
   * 注册 drm 相关回调函数
   */
  setDrmCallback() {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'setDrmCallback: this.mediaKeySession is undefined!')
      return
    }
    Logger.info(this.TAG, 'Start to set callback')
    // renew上报 重新获取license
    this.mediaKeySession.on(KeySessionEvents.KEY_NEEDED, (eventInfo: drm.EventInfo) => {
      Logger.info(this.TAG, 'keyNeeded callback success.' + JSON.stringify(eventInfo))
    })
    // 密钥过期上报 播放失败
    this.mediaKeySession.on(KeySessionEvents.KEY_EXPIRED, (eventInfo: drm.EventInfo) => {
      Logger.info(this.TAG, 'keyExpired callback success.' + JSON.stringify(eventInfo))
    })
    // license过期时长上报 license响应交给底层时触发
    this.mediaKeySession.on(KeySessionEvents.EXPIRATION_UPDATED, (eventInfo: drm.EventInfo) => {
      Logger.info(this.TAG, 'expirationUpdated callback success.' + JSON.stringify(eventInfo))
    })

    this.mediaKeySession.on(KeySessionEvents.VENDOR_DEFINED, (eventInfo: drm.EventInfo) => {
      Logger.info(this.TAG, 'vendorDefined callback success.' + JSON.stringify(eventInfo))
    })
    // keyId
    this.mediaKeySession.on(KeySessionEvents.KEYS_CHANGED, (eventInfo: drm.EventInfo) => {
      Logger.info(this.TAG, 'keyChanged callback success.' + JSON.stringify(eventInfo))
    })
  }

  /**
   * todo 注销 drm 相关回调函数
   */
  destroyDrmCallback() {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'destroyDrmCallback: this.mediaKeySession is undefined!')
      return
    }
    this.mediaKeySession.off(KeySessionEvents.KEY_NEEDED)
    this.mediaKeySession.off(KeySessionEvents.KEY_EXPIRED)
    this.mediaKeySession.off(KeySessionEvents.EXPIRATION_UPDATED)
  }

  /**
   * 获取 Provision
   */
  async getProvision() {
    if (!this.mediaKeySystem) {
      Logger.error(this.TAG, 'getProvision: this.mediaKeySystem is undefined!')
      return
    }
    // Provision Request
    let provisionRequestData: drm.ProvisionRequest = this.mediaKeySystem.generateKeySystemRequest()
    let provisionRequestStr: string = TypeConversion.byteToString(provisionRequestData.mData)
    Logger.info(this.TAG, 'ProvisionRequest[' + provisionRequestStr.length + ']:' + provisionRequestStr)

    // Provision Response
    try {
      let provisionResponseStr: string = await HttpUtil.getDrmResponse("https://drmkit.hwcloudtest.cn:8080/provision/v1/wiseplay", provisionRequestStr)
      Logger.info(this.TAG, 'provisionResponse[' + provisionResponseStr.length + ']:' + provisionResponseStr)
      let provisionRequestByte: Uint8Array = TypeConversion.stringToByte(provisionResponseStr)
      this.mediaKeySystem.processKeySystemResponse(provisionRequestByte)
    } catch (e) {
      Logger.info(this.TAG, 'error [' + JSON.stringify(e) + ']')
    }
  }

  /**
   * 获取license
   * @param drmInfoArr drm信息参数
   * @param drmUrl 片源地址
   * @param drmLicenseUrl license请求地址
   * @param licenseType license类型， 0 在线, 1 离线
   * @returns
   */
  async getLicense(drmInfoArr: drmInfo[], drmUrl: string, drmLicenseUrl: string, licenseType: number): Promise<boolean> {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'generateLicenseRequest: this.mediaKeySession is undefined!')
      return false
    }

    let isSuccess: boolean = false
    for (let i = 0; i < drmInfoArr.length; i++) {
      // license Request
      const optionalData: drm.OptionalData[] = [{
        name: "optionalDataName",
        value: "optionalDataValue"
      }]
      Logger.info(this.TAG, 'drmInfoArr - uuid: ' + drmInfoArr[i].uuid)
      Logger.info(this.TAG, 'drmInfoArr - pssh: ' + drmInfoArr[i].pssh)
      const uint8pssh: Uint8Array = new Uint8Array(drmInfoArr[i].pssh)
      const licenseRequestData: drm.LicenseRequest = this.mediaKeySession.generateLicenseRequest('video/mp4', uint8pssh, licenseType, optionalData)
      let licenseRequestStr: string = TypeConversion.byteToString(licenseRequestData.mData)
      Logger.info(this.TAG, 'licenseRequestStr[' + licenseRequestStr.length + ']:' + licenseRequestStr)

      // license Response
      let licenseResponseStr: string = await HttpUtil.getDrmResponse(drmLicenseUrl, licenseRequestStr)
      Logger.info(this.TAG, 'licenseResponseStr[' + licenseResponseStr.length + ']:' + licenseResponseStr)
      // 请求地址或传参错误时返回的result不是正确的license response
      const licenseResponseObj: Record<string, Object> = JSON.parse(licenseResponseStr)
      if (!licenseResponseObj.certificateChain) {
        Logger.error(this.TAG, 'licenseResponse msg: ' + licenseResponseObj?.msg)
        isSuccess = false
        break
      }
      let licenseResponseData: Uint8Array = TypeConversion.stringToByte(licenseResponseStr)
      // 将响应交给底层（在线license返回空字符串，离线license返回keySetId）
      let KeySetId: Uint8Array = this.mediaKeySession.processLicenseResponse(licenseResponseData)
      isSuccess = true
      // 若为离线license则存储起来
      if (licenseType === 1 && KeySetId) {
        Logger.info(this.TAG, 'KeySetId is: ' + TypeConversion.byteToString(KeySetId))
        KVManagerUtil.put(drmUrl, TypeConversion.byteToString(KeySetId))
      }
    }
    return isSuccess
  }

  /**
   * 执行license流程
   * @param drmUrl
   * @param drmLicenseUrl
   * @param drmInfoArr
   * @param licenseType
   * @returns
   */
  async executeLicenseProcess(drmUrl: string, drmLicenseUrl: string, drmInfoArr: drmInfo[], licenseType: number): Promise<boolean> {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'executeLicenseProcess: this.mediaKeySession is undefined!')
      return false
    }
    Logger.info(this.TAG, `Start to execute license process`)

    if (licenseType === 0) {
      Logger.info(this.TAG, `Get onlineLicense`)
      return await this.getLicense(drmInfoArr, drmUrl, drmLicenseUrl, licenseType)
    } else if (licenseType === 1) {
      let keyId: string = await KVManagerUtil.get(drmUrl)
      if (keyId) { // 已存储过，直接使用离线license进行播放
        Logger.info(this.TAG, `Offlinelicense exist, keyId is ${keyId}`)
        this.mediaKeySession.restoreOfflineLicense(TypeConversion.stringToByte(keyId))
        return true
      } else { // 若没有存储过，则需要请求license
        Logger.info(this.TAG, `Get offlineLicense`)
        return await this.getLicense(drmInfoArr, drmUrl, drmLicenseUrl, licenseType)
      }
    }

    Logger.error(this.TAG, `LicenseType error`)
    return false
  }

  /**
   * 删除离线license
   * @param drmUrl
   */
  async deleteOfflineLicense(drmUrl: string) {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'deleteOfflineLicense: this.mediaKeySession is undefined!')
      return
    }

    let keyId: string = await KVManagerUtil.get(drmUrl)
    Logger.info(this.TAG, 'KeyId to be delete is: ' + keyId);
    if (keyId) {
      let offlineLicenseId = new Uint8Array(TypeConversion.stringToByte(keyId));
      let offlineLicenseStatus: drm.OfflineLicenseStatus = this.mediaKeySystem.getOfflineLicenseStatus(offlineLicenseId);
      Logger.info(this.TAG, 'Get offlineLicense Status is: ' + offlineLicenseStatus);

      this.mediaKeySystem.removeOfflineLicense(offlineLicenseId);
      KVManagerUtil.delete(drmUrl)
      Logger.info(this.TAG, 'Succeeded in deleting offline license.');
    }
  }

  /**
   * 将KeySession与AVPlayer实例绑定
   * @param avPlayer
   * @param svp 是否需要安全视频通路
   */
  bindInstance(avPlayer: media.AVPlayer) {
    avPlayer.setDecryptConfig(this.mediaKeySession, this.svp)
    Logger.info(this.TAG, 'DecryptConfig has been set.')
  }

  /**
   * 释放资源
   */
  releaseDrm() {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'releaseDrm: this.mediaKeySession is undefined!')
      return
    }
    try {
      this.destroyDrmCallback()
      this.mediaKeySession.destroy()
      this.mediaKeySystem.destroy()
      Logger.info(this.TAG, 'mediaKeySession release success.')
    } catch (err) {
      Logger.error(this.TAG, `Failed to destroy Drm mediaKey. Error: [${err}]`)
    }
  }
}