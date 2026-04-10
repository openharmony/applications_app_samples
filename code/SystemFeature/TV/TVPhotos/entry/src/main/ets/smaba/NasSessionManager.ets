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
 
import { common } from '@kit.AbilityKit';
import Logger from '../common/Logger';
import { MessageData, NasDevice, RequestEventType, ResponseEventType } from '../workers/NasSessionWorker';
import { preferences } from '@kit.ArkData';
import { MessageEvents, taskpool, worker } from '@kit.ArkTS';
import { DirectoryEntry } from 'smbProtocol';
import nasFinder from './NasFinder';
import fileUtil from '../manager/utils/FileUtils';
import { image } from '@kit.ImageKit';
import { deleteNasImage, loadNasImage } from './NasImageLoader';

const TAG = 'NAS_session_manager'

export interface ThumbResult {
  index: number,
  localPath: string
}

export interface ImageResult {
  index: number,
  pixelMap: image.PixelMap
}

@Observed
export class SessionModel {
  public host: string = '';
  public fileSize: number = 0;
  public isPlaceHolder: boolean = false;
  public thumbFile?: DirectoryEntry
}

class NasSessionManager {
  private context?: common.UIAbilityContext
  private sessionMap: Map<string, worker.ThreadWorker> = new Map()
  private fileMap: Map<string, DirectoryEntry[]> = new Map()
  private sessionCallbacks: Array<(hosts: SessionModel[]) => void> = []
  private fileChangeCallbacks: Map<string, Array<(files: DirectoryEntry[]) => void>> = new Map()
  private loadImageTask?: taskpool.Task

  init(context: common.UIAbilityContext) {
    Logger.info(TAG, `init`)
    this.context = context
    this.getLocalDevices().forEach((device) => {
      this.authNasSession(device)
    })
  }

  findNas() {
    return nasFinder.find(Array.from(this.sessionMap.keys()))
  }

  disconnectSession(host: string) {
    this.sessionMap.get(host)?.postMessage({
      type: RequestEventType.closeSession
    } as MessageData)
    this.sessionMap.get(host)?.terminate()
    this.sessionMap.delete(host)
    this.fileMap.delete(host)
    const localDevices = this.getLocalDevices().filter((value) => {
      return value.host !== host
    })
    this.saveLocalDevices(localDevices)
    this.sessionCallbacks.forEach(callback => {
      callback(this.getSessionModels())
    })
  }

  authNasSession(nasDevice: NasDevice): Promise<boolean> {
    return new Promise((resolve, reject) => {
      let sessionWorker: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/NasSessionWorker.ets');
      sessionWorker.onmessage = (e: MessageEvents) => {
        const messageData = e.data as MessageData
        if (messageData.type === ResponseEventType.authSuccess) {
          this.sessionMap.set(nasDevice.host, sessionWorker)
          this.fileMap.set(nasDevice.host, messageData.data as DirectoryEntry[])
          this.addLocalDevice(nasDevice)
          this.sessionCallbacks.forEach(callback => {
            callback(this.getSessionModels())
          })
          this.fileChangeCallbacks.get(nasDevice.host)?.forEach(callback => {
            callback([...this.fileMap.get(nasDevice.host) ?? []])
          })
          resolve(true)
        } else if (messageData.type === ResponseEventType.authFail) {
          Logger.error(TAG, `auth fail = ` + JSON.stringify(messageData.data))
          sessionWorker.terminate()
          resolve(false)
        } else if (messageData.type === ResponseEventType.localFileChange) {
          let localFile = messageData.data as DirectoryEntry[]
          localFile.forEach(value => {
            const resolve = this.waitingResolve.get(value.fileId)
            if (resolve) {
              resolve()
              this.waitingResolve.delete(value.fileId)
            }
          })
        }
      }
      Logger.info(TAG, 'post message to worker')
      this.context && fileUtil.getNasCacheDir(this.context).then((cacheDir) => {
        sessionWorker.postMessage({
          type: RequestEventType.setCacheDir,
          data: cacheDir
        })
        sessionWorker.postMessage({
          type: RequestEventType.connectAndAuth,
          data: nasDevice
        })
      })
    })
  }

  async deleteImage(host: string, imageFile: DirectoryEntry[]) {
    const device = this.getLocalDevices().find(d => d.host === host)
    if (device) {
      const deleteTask = new taskpool.Task(deleteNasImage, device, imageFile)
      await taskpool.execute(deleteTask)
      let newFiles = this.fileMap.get(host)?.filter((file) => {
        return !imageFile.includes(file)
      })
      this.fileMap.set(host, newFiles ?? [])

      this.fileChangeCallbacks.get(host)?.forEach(callback => {
        callback([...this.fileMap.get(host) ?? []])
      })
    } else {
      throw new Error('device not found ' + host)
    }
  }

  async readImage(host: string, imageFile: DirectoryEntry, index: number): Promise<ImageResult> {
    const device = this.getLocalDevices().find(d => d.host === host)
    if (device) {
      this.loadImageTask && taskpool.cancel(this.loadImageTask)
      this.loadImageTask = new taskpool.Task(loadNasImage, device, imageFile)
      const pixelMap = await taskpool.execute(this.loadImageTask) as image.PixelMap
      this.loadImageTask = undefined
      return {
        index: index,
        pixelMap: pixelMap
      }
    } else {
      throw new Error('device not found ' + host)
    }
  }

  async readThumb(host: string, imageFile: DirectoryEntry, index: number): Promise<ThumbResult> {
    Logger.info(TAG, 'read thumb 1')
    let cacheDir = await fileUtil.getNasCacheDir(this.context!!)
    let imageName = fileUtil.getNasLocalFile(host, imageFile)
    let localPath = cacheDir + imageName
    let thumbExist = await fileUtil.fileExist(localPath)
    Logger.info(TAG, 'read thumb 2 ' + thumbExist)
    if (!thumbExist) {
      await this.waitForThumbLoaded(host, imageFile)
    }
    Logger.info(TAG, 'read thumb 3' + localPath)
    return {
      index: index,
      localPath: 'file://' + localPath
    }
  }

  getImageFiles(host: string): DirectoryEntry[] {
    return this.fileMap.get(host) ?? []
  }

  private waitingResolve: Map<string, (value: void | PromiseLike<void>) => void> = new Map()

  waitForThumbLoaded(host: string, imageFile: DirectoryEntry): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this.sessionMap.get(host)) {
        this.sessionMap.get(host)?.postMessage({
          type: RequestEventType.readThumb,
          data: imageFile
        } as MessageData)
        this.waitingResolve.set(imageFile.fileId, resolve)
      } else {
        reject('session worker not found')
      }
    })
  }

  registerSessionCallback(callback: (sessionModel: SessionModel[]) => void): void {
    Logger.info(TAG, 'registerChangeCallback ');
    this.sessionCallbacks.push(callback)
    setTimeout(() => {
      callback(this.getSessionModels())
    }, 200)
  };

  private getSessionModels(): SessionModel[] {
    let models: SessionModel[] = []
    this.fileMap.forEach((value, key) => {
      models.push({
        host: key,
        fileSize: value.length,
        isPlaceHolder: false,
        thumbFile: value.length > 0 ? value[0] : undefined
      })
    })
    return models
  }

  unRegisterSessionCallback(callback: (sessionModel: SessionModel[]) => void): void {
    Logger.info(TAG, 'unRegisterChangeCallback ');
    this.sessionCallbacks = this.sessionCallbacks.filter((cb) => {
      return (cb !== callback)
    })
  };

  registerFileChangeCallback(host: string, callback: (files: DirectoryEntry[]) => void): void {
    let hostCallbacks = this.fileChangeCallbacks.get(host) ?? []
    hostCallbacks.push(callback)
    this.fileChangeCallbacks.set(host, hostCallbacks)
    setTimeout(() => {
      callback([...this.fileMap.get(host) ?? []])
    }, 200)
  };

  unRegisterFileChangeCallback(host: string, callback: (files: DirectoryEntry[]) => void): void {
    let hostCallbacks = this.fileChangeCallbacks.get(host)
    let newHostCallbacks = hostCallbacks?.filter((cb) => {
      return cb === callback
    })
    if (newHostCallbacks === undefined || newHostCallbacks.length === 0) {
      this.fileChangeCallbacks.delete(host)
    } else {
      this.fileChangeCallbacks.set(host, newHostCallbacks)
    }
  };

  addLocalDevice(device: NasDevice) {
    let localDevices = this.getLocalDevices()
    let index = localDevices.findIndex(d => d.host === device.host)
    if (index === -1) {
      localDevices.push(device)
    } else {
      localDevices[index] = device
    }
    this.saveLocalDevices(localDevices)
  }

  saveLocalDevices(nasDevices: NasDevice[]) {
    let preference = preferences.getPreferencesSync(this.context, { name: 'nas' })
    preference.putSync('nasDevices', JSON.stringify(nasDevices))
    preference.flush()
    Logger.info(TAG, 'save ConnectedNas = ' + JSON.stringify(nasDevices))
  }

  getLocalDevices(): NasDevice[] {
    let devices: NasDevice[] = []
    try {
      let deviceString =
        preferences.getPreferencesSync(this.context, { name: 'nas' })
          .getSync('nasDevices', []) as string
      if (deviceString) {
        devices = JSON.parse(deviceString) as NasDevice[]
      }
    } catch (e) {
      Logger.error(TAG, 'get nasDevices from preference fail= ' + JSON.stringify(e))
    }
    Logger.info(TAG, 'get nasDevices = ' + JSON.stringify(devices))
    return devices
  }
}

let nasSessionManager: NasSessionManager = new NasSessionManager()

export default nasSessionManager
