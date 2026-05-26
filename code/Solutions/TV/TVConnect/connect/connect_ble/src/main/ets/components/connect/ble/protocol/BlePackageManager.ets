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
import BlePackage from './BlePackage';
import { Callback } from '@kit.BasicServicesKit';
import BlePackageWrapper from './BlePackageWrapper';
import { HashMap } from '@kit.ArkTS';

/**
 * 对ble的数据包，进行分包或者拆包处理
 */
export default class BlePackageManager {
  public onPackageCallback: Callback<BlePackage> | undefined;
  public map: HashMap<number, SubPackages> = new HashMap();

  setPackageCallback(callback: Callback<BlePackage>) {
    this.onPackageCallback = callback;
  }

  /**
   * 当接收到数据时，添加进来，如果组成完整的blePackage，触发回调
   * @param ab
   */
  addData(ab: ArrayBuffer) {
    const wrapper: BlePackageWrapper = BlePackageWrapper.parser(ab);
    if (wrapper.header.messageId == 0) {
      this.invokeCallBack(BlePackage.parser(wrapper));
    } else {
      this.addSubPackage(wrapper);
    }
  }

  addSubPackage(wrapper: BlePackageWrapper) {
    const messageId = wrapper.header.messageId;
    if (this.map.hasKey(messageId)) {
      //添加分包
      const subPackages: SubPackages = this.map.get(messageId);
      subPackages.addBlePackageWrapper(wrapper);
      //如果合包完成，回调
      if (subPackages.isSubPackageEnough()) {
        this.onSubPackageEnough(messageId);
      }
    } else {
      //新增分包
      const subPackages: SubPackages = new SubPackages(messageId, wrapper.header.totalFrame);
      subPackages.addBlePackageWrapper(wrapper);
      this.map.set(messageId, subPackages);
    }
  }

  //当某个分包凑齐
  onSubPackageEnough(tokenId: number) {
    const subPackages: SubPackages = this.map.get(tokenId);
    this.map.remove(tokenId);
    this.invokeCallBack(BlePackage.parserSubPackage(subPackages.getData()));
  }

  //数据包整合完成
  invokeCallBack(blePackage: BlePackage) {
    if (this.onPackageCallback) {
      this.onPackageCallback(blePackage);
    }
  }

  sendPackage(blePackage: BlePackage) {
    //判断是否需要分包；
    //1、不需要分包，直接write
    //2、body分包数量
    //分开发送
  }
};

/**
 * 如果某个包失败，需要请求重新发某个单独sub
 *
 */
class SubPackages {
  //消息id
  public messageId: number;
  //总包数
  public totalFrame: number;
  //数据
  public data: BackFillArray<BlePackageWrapper>;

  constructor(messageId: number, totalFrame: number) {
    this.messageId = messageId;
    this.totalFrame = totalFrame;
    this.data = new BackFillArray<BlePackageWrapper>(totalFrame);
  }

  isSubPackageEnough(): boolean {
    return this.data.isFull();
  }

  addBlePackageWrapper(wrapper: BlePackageWrapper) {
    const index = wrapper.header.frameSeq;
    this.data.insertAt(index, wrapper);
  }

  getData(): Array<BlePackageWrapper> {
    return this.data.getData();
  }
}

/**
 * 装填数组，初始化数组，未补充的位置为默认null
 */
class BackFillArray<T> {
  public data: Array<T | null>;

  constructor(length: number) {
    this.data = new Array<T | null>(length);
  }

  isFull() {
    return this.data.indexOf(null) == -1;
  }

  length() {
    return this.data.filter((data) => data != null).length;
  }

  getData(): Array<T> {
    return this.data.filter((data) => data != null).map((data) => data as T);
  }

  insertAt(position: number, data: T) {
    this.data[position] = data;
  }
}