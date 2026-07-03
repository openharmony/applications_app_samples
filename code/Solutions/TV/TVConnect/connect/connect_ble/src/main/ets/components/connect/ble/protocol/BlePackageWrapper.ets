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

/**
 * 初步解析的package包，包含分包信息
 *
 * 把arrayBuffer按照协议规范，解析成容易分析的属性字段
 *
 * 如果未分包，BlePackageWrapper == BlePackage，
 * 分包情况下，多个BlePackageWrapper组成一个BlePackage
 */
export default class BlePackageWrapper implements ArrayBufferTransformer {
  toArrayBuffer(): ArrayBuffer {
    throw new Error('Method not implemented.');
  }

  public static parser(ab: ArrayBuffer): BlePackageWrapper {
    // return new BlePackageWrapper(new BleHeader(), new PayLoad());
    throw Error('not implement');
  }

  public header: BleHeader;
  public payLoad: PayLoad;

  constructor(header: BleHeader, payLoad: PayLoad) {
    this.header = header;
    this.payLoad = payLoad;
  }
};


export class BleHeader implements ArrayBufferTransformer {
  //以下number都是十进制
  //版本号 （0.5字节）
  public version: number;
  //消息类型，0，请求消息，1，响应消息，10，主动上报消息 （0.5字节）
  public cmdType: number;
  //0代表不分包，01-255,代表package token （1字节）
  public messageId: number;
  //总包数，0~2048，0代表不分包 （1字节）
  public totalFrame: number;
  //包序号，不分包时为0，分包时，取值从1开始递增， （1字节）
  public frameSeq: number;
  //保留字段，当前为0，（1字节）
  public rev: number;
  //数据加密方式，0不加密，1 配网speke加密，2 控制speke加密 3、session key加密 4、基于authCode派生密钥加密；（1字节）
  public encry: number;
  //消息的执行结果，主动上报消息、请求消息，响应消息成功都是0， 响应失败1，（1字节）
  public return: number;

  constructor(ab: ArrayBuffer) {
    this.version = 0;
    this.cmdType = 0;
    this.messageId = 0;
    this.totalFrame = 0;
    this.frameSeq = 0;
    this.rev = 0;
    this.encry = 0;
    this.return = 0;
  }

  toArrayBuffer(): ArrayBuffer {
    throw new Error('Method not implemented.');
  }
}

export class PayLoad implements ArrayBufferTransformer {
  //目前固定取值0b01，（0.5字节）
  public dataFormat: number;
  // 00:put 01:get 02:report 操作类型 （0.5字节）
  public optType: number;
  //服务名长度 （1字节）
  public serviceLength: number;
  // ascii码，
  public serviceName: string;
  //数据长度（2字节）
  public bodyLength: number;
  //json
  public body: string;

  constructor(ab: ArrayBuffer) {
    this.dataFormat = 0;
    this.optType = 0;
    this.serviceLength = 0;
    this.serviceName = '';
    this.bodyLength = 0;
    this.body = '';
  }

  toArrayBuffer(): ArrayBuffer {
    throw new Error('Method not implemented.');
  }
}


interface ArrayBufferTransformer {
  toArrayBuffer(): ArrayBuffer;
}