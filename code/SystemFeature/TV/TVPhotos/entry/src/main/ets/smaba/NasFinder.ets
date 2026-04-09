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
import { connection } from '@kit.NetworkKit';
import Client from './client/Client';

const TAG = 'SMB_clientFinder'
const POOL_SIZE = 5

class NasFinder {
  async find(exceptHosts: string[]): Promise<Client[]> {
    console.info(TAG, `NasFinder start =`)
    const localAddress = this.getNetAddress(connection.getDefaultNetSync())
    console.info(TAG, `localAddress =` + localAddress)
    if (localAddress) {
      let ipParts = localAddress.split('.').map(Number);
      if (ipParts.length === 4) {
        let netId = `${ipParts[0]}.${ipParts[1]}.${ipParts[2]}`
        let localHostId = ipParts[3]
        console.info(TAG, `netId =` + netId + ' localHostId=' + localHostId)
        const splitPromises: Promise<Client[]>[] = []
        for (let index = 0; index < POOL_SIZE; index++) {
          splitPromises.push(getAvailableDevice(netId, localHostId, index + 1, POOL_SIZE, exceptHosts))
        }
        const splitResults = await Promise.all(splitPromises)
        const clients: Client[] = []
        splitResults.forEach((splitResult) => {
          clients.push(...splitResult)
        })
        return clients
      } else {
        throw new Error('wrong local ip')
      }
    } else {
      throw new Error('no network')
    }
  }

  getNetAddress(netHandler: connection.NetHandle): string | undefined {
    let address: string | undefined = undefined
    if (netHandler) {
      let prop = connection.getConnectionPropertiesSync(netHandler)
      if (prop && prop.linkAddresses && prop.linkAddresses.length > 0) {
        address = prop.linkAddresses[0].address.address
      }
    }
    return address
  }
}

@Concurrent
async function getAvailableDevice(netId: string, localHostId: number, startHostId: number,
  space: number, exceptHosts: string[]): Promise<Client[]> {
  const TAG = 'SMB_NAS_FINDER_TASK'
  let remoteHostId = startHostId
  const clients: Client[] = []
  while (remoteHostId < 255) {
    if (remoteHostId !== localHostId && !exceptHosts.includes(`${netId}.${remoteHostId}`)) {
      const startTime = new Date().getTime()
      let client: Client = new Client(`${netId}.${remoteHostId}`, {
        port: 445,
        connectTimeout: 100,
        requestTimeout: 5000
      })
      try {
        await client.connect()
        console.warn(TAG, `connect success to ${netId}.${remoteHostId}  cost +${new Date().getTime() - startTime}`)
        clients.push(client)
        await client.close()
      } catch (e) {
        console.warn(TAG, `connect fail to ${netId}.${remoteHostId}  cost +${new Date().getTime() -
          startTime}  error = ${JSON.stringify(e)}`)
      }
    }
    remoteHostId += space
  }
  return clients
}

let nasFinder = new NasFinder()

export default nasFinder