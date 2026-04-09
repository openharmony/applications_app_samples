/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { ErrorEvent, JSON, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import Logger from '../common/Logger';
import Client from '../smaba/client/Client';
import Session from '../smaba/client/Session';
import { getNetAddress } from '../smaba/client/utils/NetworkUtil';
import { DirectoryEntry, smbUtil } from 'smbProtocol';
import { image } from '@kit.ImageKit';
import fileUtil from '../manager/utils/FileUtils';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

export const enum RequestEventType {
  setCacheDir = 'setCacheDir',
  connectAndAuth = 'nas_session_auth',
  readThumb = 'nas_read_thumb',
  readImage = 'nas_read_image',
  closeSession = 'nas_session_close',
}

export const enum ResponseEventType {
  authSuccess = 'auth_success',
  authFail = 'auth_fail',
  localFileChange = 'localFileChange'
}

export interface MessageData {
  type: string,
  data: Object
}

const TAG = 'NAS_sessionWorker'
const DEFAULT_THUMB_WIDTH = 640
let nasSession: Session | undefined = undefined
let fileQueue: DirectoryEntry[] = []
let localFiles: DirectoryEntry[] = []
let cacheDir: string | undefined = undefined

export interface NasDevice {
  host: string,
  userName: string,
  password: string
}

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param event message data
 */
workerPort.onmessage = (event: MessageEvents) => {
  const messageData = event.data as MessageData
  Logger.info(TAG, 'workerPort on message ' + JSON.stringify(event, smbUtil.bigIntReplacer))
  if (messageData.type === RequestEventType.setCacheDir) {
    cacheDir = messageData.data as string
  } else if (messageData.type === RequestEventType.connectAndAuth) {
    Logger.info(TAG, 'worker start 1')
    sessionAuth(messageData.data as NasDevice)
  } else if (messageData.type === RequestEventType.readThumb) {
    const imageFile = messageData.data as DirectoryEntry
    const file = localFiles.find((value) => value.fileId === imageFile.fileId)
    if (!file) {
      fileQueue.push(imageFile)
    }
  } else if (messageData.type === RequestEventType.closeSession) {
    nasSession?.logoff()
  }
};

async function sessionAuth(nasDevice: NasDevice) {
  Logger.info(TAG, 'worker start 2')
  try {
    const client: Client = new Client(nasDevice.host, {
      port: 445,
      connectTimeout: 500,
      requestTimeout: 5000
    })
    await client.connect()
    Logger.info(TAG, 'worker start 3')
    if (client.connected) {
      Logger.info(TAG, `connectNas client connected `)
      nasSession = new Session(client)
      await nasSession.authenticate({
        domain: '?',
        username: nasDevice.userName,
        password: nasDevice.password,
        workStation: 'session_' + getNetAddress()
      })
      Logger.info(TAG, `connectNas auth success`)
      await nasSession?.connectRootTree()
      Logger.info(TAG, `connectNas create root tree success`)
      await nasSession?.listAllImage()
      Logger.info(TAG, `connectNas listallimage success`)
      workerPort.postMessage({
        type: ResponseEventType.authSuccess,
        data: nasSession.allImages
      })
      loadFiles(nasSession.allImages ?? [])
    }
  } catch (e) {
    workerPort.postMessage({
      type: ResponseEventType.authFail,
      data: e
    })
  }
}

async function loadFiles(imageFiles: DirectoryEntry[]) {
  Logger.info(TAG, 'loaf files cacheDir = ' + cacheDir)
  if (imageFiles.length === 0 || nasSession === undefined || cacheDir === undefined) {
    return
  }
  let offset = 0
  fileQueue.push(imageFiles[offset])
  while (fileQueue.length > 0) {
    let file = fileQueue.shift()
    if (file && localFiles.find((value) => value.fileId === file!!.fileId)) {
      offset++
      continue
    }
    if (nasSession && file) {
      try { //判断是否已保存
        Logger.info(TAG, 'loaf file 1')
        // let cacheDir = await fileUtil.getNasCacheDir(globalThis.abilityContext)
        Logger.info(TAG, 'loaf file 2')
        let imageName = fileUtil.getNasLocalFile(nasSession.client.host, file)
        Logger.info(TAG, 'loaf file 3')
        let localPath = cacheDir + imageName
        let thumbExist = await fileUtil.fileExist(localPath)
        Logger.info(TAG, `path = ${localPath} exist = ${thumbExist}`)
        if (!thumbExist) {
          //未保存则保存图片
          let buffer = await nasSession?.readFile(file)
          if (buffer) {
            const imageSource = image.createImageSource(buffer.buffer);
            const imageInfo = imageSource.getImageInfoSync()

            const scale = Math.max(imageInfo.size.width / DEFAULT_THUMB_WIDTH, 1)
            const thumbWidth = imageInfo.size.width / scale
            const thumbHeight = imageInfo.size.height / scale

            const decodingOptions: image.DecodingOptions = {
              desiredSize: { width: thumbWidth, height: thumbHeight },
              desiredPixelFormat: image.PixelMapFormat.RGBA_8888
            };
            const thumbnail = await imageSource.createPixelMap(decodingOptions);
            if (thumbnail) {
              Logger.info(TAG, `do save`)
              await fileUtil.savePixelMap(thumbnail, localPath)
              thumbExist = true
            } else {
            }
          }
        }
        if (thumbExist) {
          //将图片加入已下载列表
          localFiles.push(file)
          workerPort.postMessage({
            type: ResponseEventType.localFileChange,
            data: localFiles
          })
        }
      } catch (e) {
        Logger.warn(TAG, `load file ${JSON.stringify(file, smbUtil.bigIntReplacer)} fail error = ${JSON.stringify(e)}`)
      }
    }
    offset++
    if (offset < imageFiles.length) {
      fileQueue.push(imageFiles[offset])
    }
  }

}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param event message data
 */
workerPort.onmessageerror = (event: MessageEvents) => {
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param event error message
 */
workerPort.onerror = (event: ErrorEvent) => {
};
