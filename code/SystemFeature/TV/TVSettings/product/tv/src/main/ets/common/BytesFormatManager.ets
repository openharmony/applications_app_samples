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

export default (val: number):string => {
  let result = '';
  if (val < 1024) {
    result = `${val} B`;
  } else if (val < 1024 * 1024) {
    result = `${(val / 1024).toFixed(2)} KB`;
  } else if (val < 1024 * 1024 * 1024) {
    result = `${(val / (1024 * 1024)).toFixed(2)} MB`;
  } else if (val < 1024 * 1024 * 1024 * 1024) {
    result = `${(val / (1024 * 1024 * 1024)).toFixed(2)} GB`;
  }
  return result;
}
