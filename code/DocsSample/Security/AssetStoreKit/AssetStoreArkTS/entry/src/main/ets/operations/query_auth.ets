/*
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

// [Start import]
import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import { userAuth } from '@kit.UserAuthenticationKit';
import { BusinessError } from '@kit.BasicServicesKit';

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

function arrayToString(arr: Uint8Array): string {
  let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
  let str = textDecoder.decodeToString(arr, { stream: false });
  return str;
}
// [End import]

// [Start query_user_auth_asset]
async function userAuthenticate(challenge: Uint8Array): Promise<Uint8Array> {
  return new Promise((resolve, reject) => {
    const authParam: userAuth.AuthParam = {
      challenge: challenge,
      authType: [userAuth.UserAuthType.PIN],
      authTrustLevel: userAuth.AuthTrustLevel.ATL1,
    };
    const widgetParam: userAuth.WidgetParam = { title: '请输入锁屏密码' };
    try {
      let userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
      userAuthInstance.on('result', {
        onResult(result) {
          if (result.result == userAuth.UserAuthResultCode.SUCCESS) {
            console.info(`User identity authentication succeeded.`);
            resolve(result.token);
          } else {
            console.error(`User identity authentication failed.`);
            reject();
          }
        }
      });
      userAuthInstance.start();
    } catch (error) {
      let err = error as BusinessError;
      console.error(`User identity authentication failed. Code is ${err.code}, message is ${err.message}`);
      reject();
    }
  })
}

function preQueryAsset(): Promise<Uint8Array> {
  return new Promise((resolve, reject) => {
    try {
      let query: asset.AssetMap = new Map();
      query.set(asset.Tag.ALIAS, stringToArray('user_auth_asset'));
      asset.preQuery(query).then((challenge: Uint8Array) => {
        resolve(challenge);
      }).catch(() => {
        reject();
      })
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to pre-query Asset. Code is ${err.code}, message is ${err.message}`);
      reject();
    }
  });
}

async function postQueryAsset(challenge: Uint8Array) {
  let handle: asset.AssetMap = new Map();
  handle.set(asset.Tag.AUTH_CHALLENGE, challenge);
  try {
    await asset.postQuery(handle);
    console.info(`Succeeded in post-querying Asset.`);
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to post-query Asset. Code is ${err.code}, message is ${err.message}`);
  }
}

export async function queryUserAuthAsset(): Promise<string> {
  let result: string = '';
  // step1. 调用asset.preQuery获取挑战值。
  await preQueryAsset().then(async (challenge: Uint8Array) => {
    try {
      // step2. 传入挑战值，拉起用户认证框。
      let authToken: Uint8Array = await userAuthenticate(challenge);
      // step3 用户认证通过后，传入挑战值和授权令牌，查询关键资产明文。
      let query: asset.AssetMap = new Map();
      query.set(asset.Tag.ALIAS, stringToArray('user_auth_asset'));
      query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
      query.set(asset.Tag.AUTH_CHALLENGE, challenge);
      query.set(asset.Tag.AUTH_TOKEN, authToken);
      let res: asset.AssetMap[] = await asset.query(query);
      for (let i = 0; i < res.length; i++) {
        // 解析secret。
        let secret: Uint8Array = res[i].get(asset.Tag.SECRET) as Uint8Array;
        // 将Uint8Array转换为string类型。
        let secretStr: string = arrayToString(secret);
      }
      // step4. 关键资产明文查询成功后，需要调用asset.postQuery进行查询的后置处理。
      postQueryAsset(challenge);
      result = 'Succeeded in querying user-auth Asset';
    } catch (error) {
      // step5. preQuery成功，后续操作失败，也需要调用asset.postQuery进行查询的后置处理。
      postQueryAsset(challenge);
      result = 'Failed to query user-auth Asset';
    }
  }).catch((err: BusinessError) => {
    console.error(`Failed to pre-query Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Failed to query user-auth Asset';
  })
  return result;
}
// [End query_user_auth_asset]