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
import { NasDevice } from '../workers/NasSessionWorker'
import { DirectoryEntry } from 'smbProtocol'
import Client from './client/Client'
import Logger from '../common/Logger'
import Session from './client/Session'
import { getNetAddress } from './client/utils/NetworkUtil'
import { image } from '@kit.ImageKit'

@Concurrent
export async function loadNasImage(nasDevice: NasDevice, imageFile: DirectoryEntry): Promise<image.PixelMap> {
  const TAG = 'NAS_load_image'

  Logger.info(TAG, 'start')
  const client: Client = new Client(nasDevice.host, {
    port: 445,
    connectTimeout: 500,
    requestTimeout: 5000
  })
  await client.connect()
  Logger.info(TAG, 'connect success ' + imageFile.filename)
  if (client.connected) {
    let nasSession = new Session(client)
    await nasSession.authenticate({
      domain: '?',
      username: nasDevice.userName,
      password: nasDevice.password,
      workStation: 'session_' + getNetAddress()
    })
    Logger.info(TAG, `auth success ` + imageFile.filename)
    const buffer = await nasSession?.readFile(imageFile)
    Logger.info(TAG, `buffer success ` + imageFile.filename)
    if (buffer) {
      const imageSource = image.createImageSource(buffer.buffer);
      const imageInfo = imageSource.getImageInfoSync()

      const scale = Math.max(imageInfo.size.width / 1920, 1)
      const thumbWidth = imageInfo.size.width / scale
      const thumbHeight = imageInfo.size.height / scale

      const decodingOptions: image.DecodingOptions = {
        desiredSize: { width: thumbWidth, height: thumbHeight },
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      };
      const thumbnail = await imageSource.createPixelMap(decodingOptions);

      Logger.info(TAG, `pixelmap create success ` + imageFile.filename)
      return thumbnail
    } else {
      throw new Error('buffer undefined')
    }
  } else {
    throw new Error('connect fail')
  }
}


@Concurrent
export async function deleteNasImage(nasDevice: NasDevice, imageFiles: DirectoryEntry[]): Promise<void> {
  const TAG = 'NAS_delete_image'

  Logger.info(TAG, 'start')
  const client: Client = new Client(nasDevice.host, {
    port: 445,
    connectTimeout: 500,
    requestTimeout: 5000
  })
  await client.connect()
  Logger.info(TAG, 'connect success ')
  if (client.connected) {
    let nasSession = new Session(client)
    await nasSession.authenticate({
      domain: '?',
      username: nasDevice.userName,
      password: nasDevice.password,
      workStation: 'session_' + getNetAddress()
    })
    Logger.info(TAG, `auth success `)
    for (let i = 0; i < imageFiles.length; i++) {
      await nasSession.deleteFile(imageFiles[i])
    }
  } else {
    throw new Error('connect fail')
  }
}