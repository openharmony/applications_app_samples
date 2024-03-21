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

import { asset } from '@kit.AssetStoreKit';
import { promptAction } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import { logger } from '../common/Logger';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

function removeDuplicateAndSort(arr: string[]): string[] {
  let newArr = new Array<string>();
  for (let i = 0; i < arr.length; i++) {
    if (newArr.indexOf(arr[i]) === -1 && arr[i] != '') {
      newArr.push(arr[i]);
    }
  }
  return newArr.sort();
}

export function log(resource: Resource) {
  promptAction.showToast({ message: resource })
  logger.info(getContext().resourceManager.getStringSync(resource));
}

export function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

function newNullArray(): Uint8Array {
  return new Uint8Array([0]);
}

function arrayToString(arr: Uint8Array): string {
  let textDecoder = util.TextDecoder.create("utf-8", {
    ignoreBOM: true
  });
  let str = textDecoder.decodeWithStream(arr, {
    stream: false
  })
  return str;
}

export async function addAssetPromise(account: string, password: string, label: string) {
  let labelList: Array<string> = label.split(';');
  labelList = removeDuplicateAndSort(labelList);
  if (labelList.length > 4) {
    log($r('app.string.save_failed_for_label'))
    return;
  }
  let attr: asset.AssetMap = new Map();
  attr.set(asset.Tag.ALIAS, stringToArray(account))
  attr.set(asset.Tag.SECRET, stringToArray(password))
  if (labelList[0]) {
    attr.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray(labelList[0]))
  }
  if (labelList[1]) {
    attr.set(asset.Tag.DATA_LABEL_NORMAL_2, stringToArray(labelList[1]))
  }
  if (labelList[2]) {
    attr.set(asset.Tag.DATA_LABEL_NORMAL_3, stringToArray(labelList[2]))
  }
  if (labelList[3]) {
    attr.set(asset.Tag.DATA_LABEL_NORMAL_4, stringToArray(labelList[3]))
  }
  attr.set(asset.Tag.AUTH_TYPE, asset.AuthType.ANY)
  attr.set(asset.Tag.IS_PERSISTENT, true)
  try {
    await asset.add(attr);
    log($r('app.string.save_success'))
  } catch (error)  {
    if (error.code === 24000003) {
      log($r('app.string.save_failed_for_account_exist'));
    } else {
      log($r('app.string.save_failed'))
    }
  }
}

export async function removeAssetPromise(deleteAccount: string, deleteLabel: string) {
  let attr: asset.AssetMap = new Map();
  if (deleteAccount.length > 0) {
    attr.set(asset.Tag.ALIAS, stringToArray(deleteAccount))
  }
  if (deleteLabel.length == 0) {
    try {
      await asset.remove(attr);
      log($r('app.string.remove_success'))
    } catch (error) {
      if (error.code === 24000002) {
        log($r('app.string.remove_failed_for_account_not_exist'));
      } else {
        log($r('app.string.remove_failed'))
      }
    }
  } else {
    let labelList = deleteLabel.split(';');
    labelList = removeDuplicateAndSort(labelList);
    let assetList: asset.AssetMap[] = await getArrangedMap(deleteAccount, labelList)
    if (assetList.length == 0) {
      log($r('app.string.remove_failed_for_account_not_exist'));
      return;
    }
    let map: Map<asset.Tag, asset.Value> = new Map();
    for (let i = 0; i < assetList.length; i++) {
      map.set(asset.Tag.ALIAS, assetList[i].get(asset.Tag.ALIAS) as Uint8Array);
      try {
        await asset.remove(map)
      } catch (error) {
        log($r('app.string.remove_failed'))
        return;
      }
    }
    log($r('app.string.remove_success'))
  }
}

function compareArray(array1: Uint8Array, array2: Uint8Array): boolean {
  return JSON.stringify(array1) == JSON.stringify(array2);
}

function addLabelInfo(label: string, tag: asset.Tag, account: asset.AssetMap, emptyArray: Uint8Array): string {
  if (account.has(tag) && !compareArray(account.get(tag) as Uint8Array, emptyArray)) {
    label += arrayToString(account.get(tag) as Uint8Array) + ';'
  }
  return label;
}

function addElement(attr: asset.AssetMap, label: string, key: asset.Tag) {
  if (label){
    attr.set(key, stringToArray(label))
  } else {
    attr.set(key, newNullArray())
  }
}

let normalLabelList: Array<asset.Tag>  = new Array<asset.Tag>(asset.Tag.DATA_LABEL_NORMAL_1,
  asset.Tag.DATA_LABEL_NORMAL_2, asset.Tag.DATA_LABEL_NORMAL_3, asset.Tag.DATA_LABEL_NORMAL_4);

// asset获取的map转换为显示map
function convertAssetList(assetList: asset.AssetMap[], accountList: Map<string, string>[]): Array<Map<string, string>> {
  for (let account of assetList) {
    let map: Map<string, string> = new Map<string, string>();
    let alias = arrayToString(account.get(asset.Tag.ALIAS) as Uint8Array);
    if (account.has(asset.Tag.SECRET)) {
      let secret = arrayToString(account.get(asset.Tag.SECRET) as Uint8Array);
      map.set('secret', secret);
    }
    let label = ''
    let emptyArray = newNullArray();
    for (let currentLabel of normalLabelList) {
      label = addLabelInfo(label, currentLabel, account, emptyArray);
    }
    label = label.slice(0, label.length - 1)
    map.set('alias', alias);
    map.set('label', label)
    accountList.push(map);
  }
  return accountList;
}

export async function updateAssetPromise(reserveAccount: string, reservePassword: string, reserveLabel: string) {
  let labelList = reserveLabel.split(';');
  labelList = removeDuplicateAndSort(labelList);
  if (labelList.length > 4) {
    log($r('app.string.update_failed_for_label_over_4'))
    return;
  }

  let attr: asset.AssetMap = new Map();
  attr.set(asset.Tag.SECRET, stringToArray(reservePassword))
  normalLabelList.forEach((element: asset.Tag, index: number) => {
    addElement(attr, labelList[index], element);
  });

  let attr2: asset.AssetMap = new Map();
  attr2.set(asset.Tag.ALIAS, stringToArray(reserveAccount))

  try {
    await asset.update(attr2, attr)
    log($r('app.string.update_success'))
  } catch (error) {
    log($r('app.string.update_failed'));
  }
}

async function getFirstQuery(alias: string, label: string): Promise<asset.AssetMap[]>
{
  let res: Array<asset.AssetMap> = new Array<asset.AssetMap>();
  let options: asset.Tag[] = [ asset.Tag.DATA_LABEL_NORMAL_1, asset.Tag.DATA_LABEL_NORMAL_2,
    asset.Tag.DATA_LABEL_NORMAL_3, asset.Tag.DATA_LABEL_NORMAL_4 ];
  for (let i = 0; i < options.length; i++) {
    let map: asset.AssetMap = new Map();
    if (alias.length > 0) {
      map.set(asset.Tag.ALIAS, stringToArray(alias));
      map.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL)
    }
    map.set(options[i], stringToArray(label));
    try {
      let temp: Array<asset.AssetMap> = await asset.query(map)
      res = res.concat(temp);
    } catch(e) {
      // skip the error: not found
    }
  }
  return res;
}

function getLabelList(input: asset.AssetMap): Array<string>
{
  let tmp = new Array<string>();
  if (input.has(asset.Tag.DATA_LABEL_NORMAL_1)) {
    tmp.push(arrayToString(input.get(asset.Tag.DATA_LABEL_NORMAL_1) as Uint8Array));
  }
  if (input.has(asset.Tag.DATA_LABEL_NORMAL_2)) {
    tmp.push(arrayToString(input.get(asset.Tag.DATA_LABEL_NORMAL_2) as Uint8Array));
  }
  if (input.has(asset.Tag.DATA_LABEL_NORMAL_3)) {
    tmp.push(arrayToString(input.get(asset.Tag.DATA_LABEL_NORMAL_3) as Uint8Array));
  }
  if (input.has(asset.Tag.DATA_LABEL_NORMAL_4)) {
    tmp.push(arrayToString(input.get(asset.Tag.DATA_LABEL_NORMAL_4) as Uint8Array));
  }
  return tmp;
}

async function getArrangedMap(alias: string, labels: string[]): Promise<asset.AssetMap[]>
{
  let first_query: asset.AssetMap[] = await getFirstQuery(alias, labels[0]);
  let res: asset.AssetMap[] = first_query.filter((map: asset.AssetMap) => {
    let list: Array<string> = getLabelList(map);
    for (let i = 1; i < labels.length; i++) {
      if (list.indexOf(labels[i]) < 0) {
        return false;
      }
    }
    return true;
  });
  return res;
}

export async function queryAssetPromise(checkAccount: string, checkLabel: string): Promise<Array<Map<string, string>>> {
  let accountList: Map<string, string>[] = new Array<Map<string, string>>();
  let assetMap: asset.AssetMap = new Map();
  if (checkAccount.length > 0) {
    assetMap.set(asset.Tag.ALIAS, stringToArray(checkAccount))
    assetMap.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL)
  }
  if (checkLabel.length == 0) { // query condition do not contain label.
    try {
      let assetList: Array<asset.AssetMap> = await asset.query(assetMap);
      return convertAssetList(assetList, accountList);
    } catch (error) {
      if (error.code === 24000002) {
        log($r('app.string.query_no_result'));
      } else {
        log($r('app.string.query_failed'));
      }
      return new Array<Map<string, string>>();
    }
  } else {
    let labelList: Array<string> = checkLabel.split(';');
    labelList = removeDuplicateAndSort(labelList);
    let assetList: asset.AssetMap[] = await getArrangedMap(checkAccount, labelList)
    if (assetList.length == 0) {
      log($r('app.string.query_no_result'));
      return new Array<Map<string, string>>();
    }
    return convertAssetList(assetList, accountList);
  }
}

export async function preQueryAssetPromise(checkAccount: string): Promise<Uint8Array> {
  let assetMap: asset.AssetMap = new Map();
  assetMap.set(asset.Tag.AUTH_VALIDITY_PERIOD, 10 * 60)
  assetMap.set(asset.Tag.AUTH_TYPE, asset.AuthType.ANY)
  if (checkAccount.length > 0) {
    assetMap.set(asset.Tag.ALIAS, stringToArray(checkAccount))
  }
  try {
    return await asset.preQuery(assetMap)
  } catch (error) {
    return new Uint8Array(0)
  }
}

export async function queryAuthAssetPromise(checkAccount: string, challenge: Uint8Array, 
  authToken: Uint8Array): Promise<Map<string, string>> {
  let attr: asset.AssetMap = new Map();
  let account: Map<string, string> = new Map<string, string>();
  if (checkAccount.length > 0) {
    attr.set(asset.Tag.ALIAS, stringToArray(checkAccount));
    attr.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
    attr.set(asset.Tag.AUTH_CHALLENGE, challenge);
    attr.set(asset.Tag.AUTH_TOKEN, authToken)
  }
  try {
    let data: Array<asset.AssetMap> = await asset.query(attr);
    let accountList: Map<string, string>[] = new Array<Map<string, string>>();
    accountList = convertAssetList(data, accountList);
    return accountList[0]
  } catch (error) {
    if (error.code === 24000002) {
      log($r('app.string.query_no_result'));
    } else {
      log($r('app.string.query_failed'));
    }
    return account;
  }
}

export async function postQueryAssetPromise(challenge: Uint8Array) {
  let attr: asset.AssetMap = new Map();
  attr.set(asset.Tag.AUTH_CHALLENGE, challenge);
  try {
    await asset.postQuery(attr);
  } catch (error) {
  }
}
