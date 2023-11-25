/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

export default class CommonUtils {
  public static millSecond2Minutes(time: number) {
    const min = Math.floor(time / 1000 / 60);
    const sec = Math.ceil(time / 1000 % 60);
    return `${CommonUtils.paddingString(min)}:${CommonUtils.paddingString(sec)}`;
  }

  static paddingString(value: number) {
    if (value < 10) {
      return `0${value}`;
    } else {
      return value;
    }
  }
}