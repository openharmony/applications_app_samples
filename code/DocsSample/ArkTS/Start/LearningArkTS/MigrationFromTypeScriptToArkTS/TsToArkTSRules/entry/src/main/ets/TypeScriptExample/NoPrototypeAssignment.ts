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
// [Start no_prototypeAssign_ts]
let C = function (p) {
  this.p = p; // 只有在开启noImplicitThis选项时会产生编译时错误。
}

C.prototype = {
  m() {
    console.info(this.p);
  }
}

C.prototype.q = function (r: string) {
  return this.p == r;
}
// [End no_prototypeAssign_ts]
