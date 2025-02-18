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

import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import userAuth from '@ohos.userIAM.userAuth';
import { BusinessError } from '@kit.BasicServicesKit';

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

function arrayToString(arr: Uint8Array): string {
  let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
  let str = textDecoder.decodeToString(arr, { stream: false });
  return str;
}

async function userAuthenticate(challenge: Uint8Array): Promise<Uint8Array> {
  return new Promise((resolve, reject) => {
    const authParam: userAuth.AuthParam = {
      challenge: challenge,
      authType: [userAuth.UserAuthType.PIN],
      authTrustLevel: userAuth.AuthTrustLevel.ATL1,
    };
    const widgetParam: userAuth.WidgetParam = { title: resourceToString($r('app.string.pass_word')) };
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
      query.set(asset.Tag.ALIAS, stringToArray('demo_alias2'));
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

async function queryAsset(): Promise<string> {
  let result: string = '';
  // step1. 调用asset.preQuery获取挑战值
  await preQueryAsset().then(async (challenge: Uint8Array) => {
    try {
      // step2. 传入挑战值，拉起用户认证框
      let authToken: Uint8Array = await userAuthenticate(challenge);
      // step3 用户认证通过后，传入挑战值和授权令牌，查询关键资产明文
      let query: asset.AssetMap = new Map();
      query.set(asset.Tag.ALIAS, stringToArray('demo_alias2'));
      query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
      query.set(asset.Tag.AUTH_CHALLENGE, challenge);
      query.set(asset.Tag.AUTH_TOKEN, authToken);
      let res: asset.AssetMap[] = await asset.query(query);
      for (let i = 0; i < res.length; i++) {
        // parse the secret.
        let secret: Uint8Array = res[i].get(asset.Tag.SECRET) as Uint8Array;
        // parse uint8array to string
        let secretStr: string = arrayToString(secret);
      }
      // step4. 关键资产明文查询成功后，需要调用asset.postQuery进行查询的后置处理。
      postQueryAsset(challenge);
      result = 'QueryUser Critical Asset Success';
    } catch (error) {
      // step5. preQuery成功，后续操作失败，也需要调用asset.postQuery进行查询的后置处理。
      postQueryAsset(challenge);
      result = 'QueryUser Critical Asset Failed';
    }
  }).catch((err: BusinessError) => {
    console.error(`Failed to pre-query Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'QueryUser Critical Asset Failed';
  })
  return result;
}

async function addCriticalAsset(): Promise<string> {
  let result: string = '';
  let attr: asset.AssetMap = new Map();
  attr.set(asset.Tag.SECRET, stringToArray('demo_pwd'));
  attr.set(asset.Tag.ALIAS, stringToArray('demo_alias'));
  attr.set(asset.Tag.ACCESSIBILITY, asset.Accessibility.DEVICE_FIRST_UNLOCKED);
  attr.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label'));
  try {
    await asset.add(attr).then(() => {
      console.info(`Asset added successfully.`);
      result = 'Add Critical Asset Success';
    }).catch((err: BusinessError) => {
      console.error(`Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'Add Critical Asset Failed';
    })
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Add Critical Asset Failed';
  }
  return result;
}

async function addCriticalAssetAuth(): Promise<string> {
  let result: string = '';
  let attr: asset.AssetMap = new Map();
  attr.set(asset.Tag.SECRET, stringToArray('demo_pwd'));
  attr.set(asset.Tag.ALIAS, stringToArray('demo_alias2'));
  attr.set(asset.Tag.ACCESSIBILITY, asset.Accessibility.DEVICE_FIRST_UNLOCKED);
  attr.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label'));
  attr.set(asset.Tag.AUTH_TYPE, asset.AuthType.ANY);
  try {
    await asset.add(attr).then(() => {
      console.info(`Asset added successfully.`);
      result = 'Add Critical Asset Auth Success';
    }).catch((err: BusinessError) => {
      console.error(`Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'Add Critical Asset Auth Failed';
    })
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Add Critical Asset Auth Failed';
  }
  return result;
}

async function removeCriticalAsset(): Promise<string> {
  let result: string = '';
  let attr: asset.AssetMap = new Map();
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias')); // 此处指定别名删除单条数据，也可不指定别名删除多条数据
  try {
    await asset.remove(query).then(() => {
      console.info(`Asset removed successfully.`);
      result = 'Remove Critical Asset Success';
    }).catch((err: BusinessError) => {
      console.error(`Failed to remove Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'Remove Critical Asset Failed';
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to remove Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Remove Critical Asset Failed';
  }
  return result;
}

async function removeCriticalAssetSecond(): Promise<string> {
  let result: string = '';
  let attr: asset.AssetMap = new Map();
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias2')); // 此处指定别名删除单条数据，也可不指定别名删除多条数据
  try {
    await asset.remove(query).then(() => {
      console.info(`Asset removed successfully.`);
      result = 'Remove Critical Asset Second Success';
    }).catch((err: BusinessError) => {
      console.error(`Failed to remove Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'Remove Critical Asset Second Failed';
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to remove Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Remove Critical Asset Second Failed';
  }
  return result;
}

async function updateCriticalAsset(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias'));
  let attrsToUpdate: asset.AssetMap = new Map();
  attrsToUpdate.set(asset.Tag.SECRET, stringToArray('demo_pwd_new'));
  attrsToUpdate.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label_new'));
  try {
    await asset.update(query, attrsToUpdate).then(() => {
      console.info(`Asset updated successfully.`);
      result = 'Update Critical Asset Success';
    }).catch((err: BusinessError) => {
      console.error(`Failed to update Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'Update Critical Asset Failed';
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to update Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Update Critical Asset Failed';
  }
  return result;
}

async function queryAllCriticalAsset(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias')); // 指定了关键资产别名，最多查询到一条满足条件的关键资产
  query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL); // 此处表示需要返回关键资产的所有信息，即属性+明文
  try {
    await asset.query(query).then((res: Array<asset.AssetMap>) => {
      for (let i = 0; i < res.length; i++) {
        // parse the secret.
        let secret: Uint8Array = res[i].get(asset.Tag.SECRET) as Uint8Array;
        // parse uint8array to string
        let secretStr: string = arrayToString(secret);
      }
      result = 'QueryAll Critical Asset Success';
    }).catch((err: BusinessError) => {
      console.error(`Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'QueryAll Critical Asset Failed';
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'QueryAll Critical Asset Failed';
  }
  return result;
}

async function queryAttributesCriticalAsset(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias')); // 指定了关键资产别名，最多查询到一条满足条件的关键资产
  query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ATTRIBUTES); // 此处表示仅返回关键资产属性，不包含关键资产明文
  try {
    await asset.query(query).then((res: Array<asset.AssetMap>) => {
      for (let i = 0; i < res.length; i++) {
        // parse the attribute.
        let accessibility: number = res[i].get(asset.Tag.ACCESSIBILITY) as number;
      }
      result = 'QueryAttributes Critical Asset Success';
    }).catch((err: BusinessError) => {
      console.error(`Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'QueryAttributes Critical Asset Failed';
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'QueryAttributes Critical Asset Failed';
  }
  return result;
}

async function queryListCriticalAsset(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ATTRIBUTES); // 此处表示仅返回关键资产属性，不包含关键资产明文
  query.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label'));
  query.set(asset.Tag.RETURN_OFFSET, 0); // 此处表示查询结果的偏移量，即从满足条件的第5条关键资产开始返回
  query.set(asset.Tag.RETURN_LIMIT, 1); // 此处表示查询10条满足条件的关键资产
  query.set(asset.Tag.RETURN_ORDERED_BY, asset.Tag.DATA_LABEL_NORMAL_1); // 此处查询结果以DATA_LABEL_NORMAL_1属性内容排序
  try {
    await asset.query(query).then((res: Array<asset.AssetMap>) => {
      for (let i = 0; i < res.length; i++) {
        // parse the attribute.
        let accessibility: number = res[i].get(asset.Tag.ACCESSIBILITY) as number;
      }
      result = 'QueryList Critical Asset Success';
    }).catch((err: BusinessError) => {
      console.error(`Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'QueryList Critical Asset Failed';
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to query Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'QueryList Critical Asset Failed';
  }
  return result;
}

@Entry
@Component
struct Index {
  @State message1: string = 'Add Critical Asset';
  @State message2: string = 'Remove Critical Asset';
  @State message9: string = 'Remove Critical Asset Second';
  @State message8: string = 'Add Critical Asset Auth';
  @State message3: string = 'Update Critical Asset';
  @State message4: string = 'QueryAll Critical Asset';
  @State message5: string = 'QueryAttributes Critical Asset';
  @State message6: string = 'QueryList Critical Asset';
  @State message7: string = 'QueryUser Critical Asset';

  build() {
    Column() {
      Button(this.message1).width('70%').margin(20)
        .onClick(async () => {
          addCriticalAsset().then(str => this.message1 = str);
        })
      Button(this.message2).width('70%').margin(20)
        .onClick(async () => {
          removeCriticalAsset().then(str => this.message2 = str);
        })
      Button(this.message9).width('70%').margin(20)
        .onClick(async () => {
          removeCriticalAssetSecond().then(str => this.message9 = str);
        })
      Button(this.message8).width('70%').margin(20)
        .onClick(async () => {
          addCriticalAssetAuth().then(str => this.message8 = str);
        })
      Button(this.message3).width('70%').margin(20)
        .onClick(async () => {
          updateCriticalAsset().then(str => this.message3 = str);
        })
      Button(this.message4).width('70%').margin(20)
        .onClick(async () => {
          queryAllCriticalAsset().then(str => this.message4 = str);
        })
      Button(this.message5).width('70%').margin(20)
        .onClick(async () => {
          queryAttributesCriticalAsset().then(str => this.message5 = str);
        })
      Button(this.message6).width('70%').margin(20)
        .onClick(async () => {
          queryListCriticalAsset().then(str => this.message6 = str);
        })
      Button(this.message7).width('70%').margin(20)
        .onClick(async () => {
          queryAsset().then(str => this.message7 = str.toString()) // 需设置设备锁屏密码
        })
    }
    .height('100%')
    .width('100%')
  }
}