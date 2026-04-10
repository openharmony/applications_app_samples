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
 
import { connection } from '@kit.NetworkKit';

export function getNetAddress(): string | undefined {
  const netHandler: connection.NetHandle = connection.getDefaultNetSync()
  let address: string | undefined = undefined
  if (netHandler) {
    let prop = connection.getConnectionPropertiesSync(netHandler)
    if (prop && prop.linkAddresses && prop.linkAddresses.length > 0) {
      address = prop.linkAddresses[0].address.address
    }
  }
  return address
}