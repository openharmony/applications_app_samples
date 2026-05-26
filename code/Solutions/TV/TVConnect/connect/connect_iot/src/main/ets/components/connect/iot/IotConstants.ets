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
export default class IotConstants {
  public static readonly IOT_TAG = 'IOT_LOG';
  public static readonly IOT_NAME = 'IOT';
  public static readonly RETRY_COUNT = 1;
  public static readonly SCAN_DURATION = 20 * 1000;
  public static readonly CONNECT_TIMERS = 20 * 1000;
  public static readonly RESPONSE_TIMERS = 10 * 1000;
  public static readonly IOT_NOT_INIT = 1000;
  public static readonly IOT_TYPE_ERROR = 1001;
  public static readonly IOT_CONNECT_ERROR = 1002;
  public static readonly IOT_NOT_CONNECT = 1003;
  public static readonly IOT_CALL_TIME_OUT = 1004;
  public static readonly IOT_PARAMS_ERROR = 1005;
  public static readonly IOT_NOT_INIT_MSG = 'iot-kit not init';
  public static readonly IOT_TYPE_ERROR_MSG = 'iot-kit type error';
  public static readonly IOT_CONNECT_ERROR_MSG = 'iot-kit not connect';
  public static readonly IOT_NOT_CONNECT_MSG = 'iot-kit connect error';
  public static readonly IOT_CALL_TIME_OUT_MSG = 'iot-kit time out';
  public static readonly IOT_PARAMS_ERROR_MSG = 'parameter verification failed';
};