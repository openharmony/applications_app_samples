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
 * 广播数据类
 */
export declare interface InfBroadcastData {

  /**
   * 获取mac地址
   * @returns
   */
  getMac(): string;

  /**
   * 获取产品id，五位
   * @returns
   */
  getProductId(): string;

  /**
   * 产品子型号
   * @returns
   */
  getSubProductId(): string;

  /**
   * 获取sn号，后两位
   * @returns
   */
  getSN(): string;
}