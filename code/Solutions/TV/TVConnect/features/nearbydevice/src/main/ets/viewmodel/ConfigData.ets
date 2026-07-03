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

import settings from '@ohos.settings';

export class ConfigData {
  public WH_100_100 = '100%';
  public WH_25_100 = '25%';
  public WH_30_100 = '30%';
  public WH_33_100 = '33%';
  public WH_35_100 = '35%';
  public WH_40_100 = '40%';
  public WH_45_100 = '45%';
  public WH_50_100 = '50%';
  public WH_55_100 = '55%';
  public WH_83_100 = '83%';
  public WH_90_100 = '90%';
  public WH_95_100 = '95%';
  public GRID_CONTAINER_GUTTER_24 = 24;
  public GRID_CONTAINER_MARGIN_24 = 24;
}

let configData = new ConfigData();

export default configData as ConfigData;