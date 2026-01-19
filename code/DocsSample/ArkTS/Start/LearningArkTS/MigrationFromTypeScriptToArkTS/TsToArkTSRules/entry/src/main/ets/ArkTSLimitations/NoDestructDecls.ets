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
// [Start no_destructDecls]
class Point {
  public x: number = 0.0;
  public y: number = 0.0;
}

function returnZeroPoint(): Point {
  return new Point();
}

// 创建一个局部变量来处理每个字段。
let zp = returnZeroPoint();
let x = zp.x;
let y = zp.y;
// [End no_destructDecls]
