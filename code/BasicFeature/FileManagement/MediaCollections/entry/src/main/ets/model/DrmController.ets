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

export default class DrmController {
  private TAG: string = 'DrmController'
  private mediaKeySystem: drm.MediaKeySystem = {} as drm.MediaKeySystem
  private mediaKeySession: drm.MediaKeySession = {} as drm.MediaKeySession
  private drmInfoArr: drm.MediaKeySystemInfo[] = []
  private solutionName: string = ''
  private licenseInfo: string = ''
  private drmUrl: string = ''
  private licenseType: number = 1
  private svp: boolean = false
  private releaseCallback: () => void = () => {
  }
  private licenseInfoCallback: () => void = () => {
  }

  /**
   * 判断系统是否支持 drm 能力
   */
  isDrmSupported(): boolean {
    if (drm.isMediaKeySystemSupported(DrmConstants.WISEPLAY_DRM_NAME)) {
      this.solutionName = DrmConstants.WISEPLAY_DRM_NAME
      return true
    } else if (drm.isMediaKeySystemSupported(DrmConstants.CLEAR_PLAY_DRM_NAME)) {
      this.solutionName = DrmConstants.CLEAR_PLAY_DRM_NAME
      return true
    }
    return false
  }

  /**
   * 创建 MediaKeySystem、KeySession 实例
   */
  createDrmSystem() {
    this.mediaKeySystem = drm.createMediaKeySystem(this.solutionName)
    if (!this.mediaKeySystem) {
      Logger.error(this.TAG, 'getMediaKeySystem fail!')
      return
    }
    Logger.info(this.TAG, 'MediaKeySystem has been created.')

    // 若无证书，此接口会返回失败
    this.mediaKeySession = this.mediaKeySystem
        .createMediaKeySession(drm.ContentProtectionLevel.CONTENT_PROTECTION_LEVEL_HW_CRYPTO)
    if (this.mediaKeySession) {
      Logger.info(this.TAG, 'mediaKeySession has been created.')
      this.svp = this.mediaKeySession.requireSecureDecoderModule('video/avc')
      Logger.info(this.TAG, ' this.svp: ' + this.svp)
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
      Logger.error(this.TAG, 'this.mediaKeySession is undefined!')
      return
    }
    Logger.info(this.TAG, 'Start to set callback')
    // renew上报 重新获取license
    this.mediaKeySession.on(KeySessionEvents.KEY_REQUIRED, async (eventInfo: drm.EventInfo) => {
      Logger.info(this.TAG, 'keyRequired callback success.')
      Logger.info(this.TAG, `info: ${TypeConversion.byteToString(eventInfo.info)}, extraInfo: ${eventInfo.extraInfo}`)

      this.renew()
      this.getLicenseInfo()
    })
    // 密钥过期上报 播放失败
    this.mediaKeySession.on(KeySessionEvents.KEY_EXPIRED, (eventInfo: drm.EventInfo) => {
      Logger.info(this.TAG, 'keyExpired callback success.')
      Logger.info(this.TAG, `info: ${TypeConversion.byteToString(eventInfo.info)}, extraInfo: ${eventInfo.extraInfo}`)

      this.getLicenseInfo()
      this.releaseCallback()
    })
    // license过期时长上报 license响应交给底层时触发
    this.mediaKeySession.on(KeySessionEvents.EXPIRATION_UPDATE, (eventInfo: drm.EventInfo) => {
      Logger.info(this.TAG, 'expirationUpdate callback success.')
      Logger.info(this.TAG, `info: ${TypeConversion.byteToString(eventInfo.info)}, extraInfo: ${eventInfo.extraInfo}`)
    })
  }

  /**
   * 注销 drm 相关回调函数
   */
  destroyDrmCallback() {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'this.mediaKeySession is undefined!')
      return
    }
    this.mediaKeySession.off(KeySessionEvents.KEY_REQUIRED)
    this.mediaKeySession.off(KeySessionEvents.KEY_EXPIRED)
    this.mediaKeySession.off(KeySessionEvents.EXPIRATION_UPDATE)
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
    let provisionRequestData: drm.ProvisionRequest = await this.mediaKeySystem.generateKeySystemRequest()
    let provisionRequestStr: string = TypeConversion.byteToString(provisionRequestData.data)
    Logger.info(this.TAG, 'ProvisionRequest[' + provisionRequestStr.length + ']:' + provisionRequestStr)

    // Provision Response
    try {
      let provisionResponseStr: string = await HttpUtil.getDrmResponse('https://drmkit.hwcloudtest.cn:8080/provision/v1/wiseplay', provisionRequestStr)
      Logger.info(this.TAG, 'provisionResponse[' + provisionResponseStr.length + ']:' + provisionResponseStr)
      let provisionRequestByte: Uint8Array = TypeConversion.stringToByte(provisionResponseStr)
      await this.mediaKeySystem.processKeySystemResponse(provisionRequestByte)
      Logger.info(this.TAG, 'get provision success.')
    } catch (e) {
      Logger.info(this.TAG, 'error [' + JSON.stringify(e) + ']')
    }
  }

  /**
   * 获取license
   * @param drmInfoArr drm信息参数
   * @param drmUrl 片源地址
   * @param drmLicenseUrl license请求地址
   * @param licenseType license类型， 1 在线, 0 离线
   * @returns
   */
  async getLicense(drmInfoArr: drm.MediaKeySystemInfo[], drmUrl: string, drmLicenseUrl: string, licenseType: number): Promise<boolean> {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'this.mediaKeySession is undefined!')
      return false
    }

    let isSuccess: boolean = true
    for (let i = 0; i < drmInfoArr.length; i++) {
      Logger.info(this.TAG, 'drmInfoArr - uuid: ' + drmInfoArr[i].uuid)
      Logger.info(this.TAG, 'drmInfoArr - pssh: ' + drmInfoArr[i].pssh)

      // license Request
      const optionsData: drm.OptionsData[] = [{
        name: 'optionalDataName',
        value: 'optionalDataValue'
      }]
      const uint8pssh: Uint8Array = new Uint8Array(drmInfoArr[i].pssh)
      const licenseRequestData: drm.MediaKeyRequest = await this.mediaKeySession.generateMediaKeyRequest('video/mp4', uint8pssh, licenseType, optionsData)
      let licenseRequestStr: string = TypeConversion.byteToString(licenseRequestData.data)
      Logger.info(this.TAG, 'licenseRequestStr[' + licenseRequestStr.length + ']:' + licenseRequestStr)

      // license Response
      let licenseResponseStr: string = await HttpUtil.getDrmResponse(drmLicenseUrl, licenseRequestStr)
      Logger.info(this.TAG, 'licenseResponseStr[' + licenseResponseStr.length + ']:' + licenseResponseStr)

      // 请求异常
      if (licenseResponseStr === 'defaultStr') {
        isSuccess = false
      } else {
        // 请求地址或传参错误时返回的result不是正确的license response
        const licenseResponseObj: Record<string, Object> = JSON.parse(licenseResponseStr)
        if (!licenseResponseObj.certificateChain) {
          Logger.error(this.TAG, 'licenseResponse msg: ' + licenseResponseObj?.msg)
          isSuccess = false
        }
      }

      let licenseResponseData: Uint8Array = TypeConversion.stringToByte(licenseResponseStr)
      // 将响应交给底层（在线license返回空字符串，离线license返回keySetId）
      try {
        let KeySetId: Uint8Array = await this.mediaKeySession.processMediaKeyResponse(licenseResponseData)
        // 若为离线license则存储起来
        if (licenseType === 0 && KeySetId) {
          Logger.info(this.TAG, 'KeySetId is: ' + TypeConversion.byteToString(KeySetId))
          KVManagerUtil.put(drmUrl, TypeConversion.byteToString(KeySetId))
          // 查看已下载的离线Id
          const keyIds: Uint8Array[] = this.mediaKeySystem.getOfflineMediaKeyIds()
          keyIds.forEach((item: Uint8Array) => {
            Logger.info(this.TAG, 'Downloaded offline id: ' + TypeConversion.byteToString(item))
          })
        }
      } catch (e) {
        isSuccess = false
        Logger.error(this.TAG, `get KeySetId error, message is ${(e as Error).message}`)
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
  async executeLicenseProcess(drmUrl: string, drmLicenseUrl: string, drmInfoArr: drm.MediaKeySystemInfo[], licenseType: number): Promise<boolean> {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'this.mediaKeySession is undefined!')
      return false
    }
    Logger.info(this.TAG, 'Start to execute license process')

    this.drmUrl = drmUrl
    this.drmInfoArr = drmInfoArr
    this.licenseType = licenseType

    if (licenseType === 1) {
      Logger.info(this.TAG, 'Get onlineLicense')
      return await this.getLicense(drmInfoArr, drmUrl, drmLicenseUrl, licenseType)
    } else if (licenseType === 0) {
      let keyId: string = await KVManagerUtil.get(drmUrl)
      if (keyId) { // 已存储过，直接使用离线license进行播放
        Logger.info(this.TAG, `Offlinelicense exist, keyId is ${keyId}`)
        this.mediaKeySession.restoreOfflineMediaKeys(TypeConversion.stringToByte(keyId))
        return true
      } else { // 若没有存储过，则需要请求license
        Logger.info(this.TAG, 'Get offlineLicense')
        return await this.getLicense(drmInfoArr, drmUrl, drmLicenseUrl, licenseType)
      }
    } else {
      Logger.error(this.TAG, 'LicenseType error')
      return false
    }
  }

  /**
   * 删除离线license
   * @param drmUrl
   */
  async deleteOfflineLicense(drmUrl: string) {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'this.mediaKeySession is undefined!')
      return
    }

    let keyId: string = await KVManagerUtil.get(drmUrl)
    Logger.info(this.TAG, 'KeyId to be delete is: ' + keyId)
    if (keyId) {
      let offlineLicenseId = new Uint8Array(TypeConversion.stringToByte(keyId))
      let offlineLicenseStatus: drm.OfflineMediaKeyStatus = this.mediaKeySystem.getOfflineMediaKeyStatus(offlineLicenseId)
      Logger.info(this.TAG, 'getOfflineMediaKeyStatus: ' + offlineLicenseStatus)

      this.mediaKeySystem.clearOfflineMediaKeys(offlineLicenseId)
      KVManagerUtil.delete(drmUrl)
      Logger.info(this.TAG, 'Delete offline license success.')
    }
  }

  /**
   * renew 重新获取license
   */
  async renew() {
    // 获取license信息
    const mediaKeyStatus: drm.MediaKeyStatus[] = this.mediaKeySession.checkMediaKeyStatus()
    const licenseInfoMap: Map<string, string> = new Map<string, string>()
    mediaKeyStatus.forEach((item: drm.MediaKeyStatus) => {
      licenseInfoMap.set(item.name, item.value)
    })
    Logger.info(this.TAG, `checkMediaKeyStatus: ${JSON.stringify(Array.from(licenseInfoMap.entries()))}`)

    // 获取新url请求license
    let renewAllowed: boolean = licenseInfoMap.has('RenewAllowed') && (licenseInfoMap.get('RenewAllowed') as string) === 'True'
    if (renewAllowed) {
      let oldKeyId: string = await KVManagerUtil.get(this.drmUrl)
      let renewalServerUrl: string = licenseInfoMap.has('RenewalServerUrl') ? (licenseInfoMap.get('RenewalServerUrl') as string) : ''
      Logger.info(this.TAG, `RenewalServerUrl: ${renewalServerUrl}`)

      await this.getLicense(this.drmInfoArr, this.drmUrl, renewalServerUrl, this.licenseType)
      // 离线renew需要删除旧id
      if (this.licenseType === 0 && oldKeyId) {
        let offlineLicenseId = new Uint8Array(TypeConversion.stringToByte(oldKeyId))
        this.mediaKeySystem.clearOfflineMediaKeys(offlineLicenseId)
        Logger.info(this.TAG, 'Renew - delete old offline license success.')
      }
    } else {
      Logger.error(this.TAG, 'renewAllowed: ' + renewAllowed)
    }
  }

  /**
   * 将KeySession与AVPlayer实例绑定
   * @param avPlayer
   * @param svp 是否需要安全视频通路
   */
  bindInstance(avPlayer: media.AVPlayer) {
    avPlayer.setDecryptionConfig(this.mediaKeySession, this.svp)
    Logger.info(this.TAG, 'DecryptConfig has been set.')
  }

  /**
   * 获取license信息
   * @returns
   */
  getLicenseInfo(): string {
    const mediaKeyStatus: drm.MediaKeyStatus[] = this.mediaKeySession.checkMediaKeyStatus()
    const licenseInfo: string = JSON.stringify(mediaKeyStatus)
    let licenseInfoText: string = ''

    if (licenseInfo) {
      Logger.info(this.TAG, `licenseInfo: ${licenseInfo}`)
      const licenseInfoArr: drm.MediaKeyStatus[] = JSON.parse(licenseInfo)

      licenseInfoText = 'License Info \n \n'
      licenseInfoArr.forEach((item: drm.MediaKeyStatus) => {
        licenseInfoText = licenseInfoText + item.name + ': ' + item.value + '\n'
      })

      let licenseType: string = (AppStorage.get('licenseType') as number) === 0 ? 'offline' : 'online'
      licenseInfoText = licenseInfoText + 'LicenseType: ' + licenseType + '\n'
    }

    this.licenseInfo = licenseInfo
    return licenseInfoText
  }

  /**
   * 释放资源
   */
  releaseDrm() {
    if (!this.mediaKeySession) {
      Logger.error(this.TAG, 'this.mediaKeySession is undefined!')
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

  /**
   * 释放avplayer播放资源
   * @param func
   */
  getReleaseCallback(func: () => void) {
    this.releaseCallback = func
  }
}