/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Contact } from './Contact';
import { util } from '@kit.ArkTS';

/*
 * 从rawfile中addressbook.json文件中json数据解析成json字符串
 * @param { string } jsonFileDir - json文件路径
 */
export function getJsonData(jsonFileDir: string): Contact[] {
  // 从本地文件中获取数据
  const value = getContext().resourceManager.getRawFileContentSync(jsonFileDir);
  // 解码为utf-8格式
  const textDecoder = util.TextDecoder.create('utf-8', {
    ignoreBOM: true
  });
  const textDecoderResult:string = textDecoder.decodeToString(new Uint8Array(value.buffer));
  const jsonObj: Contact[] = JSON.parse(textDecoderResult) as Contact[];
  let contactModelBuckets: Contact[] = [];
  for (let i = 0; i < jsonObj.length; i++) {
    contactModelBuckets.push(new Contact(
      jsonObj[i].id,
      jsonObj[i].name,
      jsonObj[i].phone,
      jsonObj[i].email,
      jsonObj[i].address,
      jsonObj[i].avatar,
      jsonObj[i].category
    ));
  }
  return contactModelBuckets;
}
