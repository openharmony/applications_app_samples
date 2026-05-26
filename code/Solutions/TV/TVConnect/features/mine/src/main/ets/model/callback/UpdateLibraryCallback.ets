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
 * 更新库calllback
 * */
export interface UpdateLibraryCallback {
  onSuccess: () => void;
  onFailure: (code?: number, data?: object, msg?: string) => void;
  onStart: () => void;

  //①获取信息失败②需要更新数据库。继续往下走③不需要更新的话展示当前版本号，提示不需要更新
  onCheckVersionEnd: (code?: number, data?: object, msg?: string) => void;
  onDownLoading: (receivedSize: number, totalSize: number) => void;

  //①下载成功进入下一个环节的提示②下载失败提示下载失败
  onDownLoadEnd: (code?: number, data?: object, msg?: string) => void;
  onVerifyEnd: (code?: number, data?: object, msg?: string) => void;

  //①解析成功提示导入中②解析失败提示回滚中
  onParseEnd: (code?: number, data?: object, msg?: string) => void;
  onRevertEnd: (code?: number, data?: object, msg?: string) => void;
}