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
export default class KeyConstant {
  // 控制loading显隐
  public static IS_SHOW_LOADING = 'isShowLoading';
  // 沙箱映射log保存路径
  public static SANDBOX_MAP = '/data/log';
  // 控制列表刷新
  public static IS_NEED_REFRESH = 'isNeedRefresh';
  // 提单日志文件夹名
  public static UPLOAD_LOG_PATH_FOLDER = 'logs';
  public static CACHE_LOG_PATH_FOLDER = 'cache_logs/allLogs';
  // 提单附件文件夹名
  public static UPLOAD_ATTACHMENT_PATH_FOLDER = 'attachment';
  public static KV_STORE_ID = 'betaClubStore';
  public static KV_ISSUE_KEY = 'kv_issue_key';
  public static KV_ISSUE_UPDATE_TIME_KEY = 'kv_issue_update_time_key';
};