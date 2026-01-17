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
// [Start no_destructParams_ts]
function drawText({ text = '', location: [x, y] = [0, 0], bold = false }) {
  text;
  x;
  y;
  bold;
}

drawText({ text: 'Hello, world!', location: [100, 50], bold: true });
// [End no_destructParams_ts]
