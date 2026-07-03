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

/*
 * 通用响应
 * */
export class CommonResponse {
  public code: number = 0;
  public msg: string = '';
  public data: CommonResponseData | null = null;
}

/*
 * 通用响应体的data
 * */
export class CommonResponseData {
}

/*
 * 通用失败http响应
 * */
export class FailData extends CommonResponseData {
  public errorCode: number = 0;
  public errorDesc: string = '';
}

/*
 * 获取设备库版本信息成功http响应
 * */
export class UpgradeDeviceLibrarySuccData extends CommonResponseData {
  public devlibVersion: string = '';
  public url: string = '';
  public fileSize: number = 0;
  public description: string = '';
}

/*
 * 获取场景库版本信息成功http响应
 * */
export class UpgradeSceneLibrarySuccData extends CommonResponseData {
  public scenelibVersion: string = '';
  public url: string = '';
  public fileSize: number = 0;
  public description: string = '';
}