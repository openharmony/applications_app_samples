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

export class RelativeRules {
  public static centerRule: AlignRuleOption = {
    center: {
      'anchor': '__container__', 'align': VerticalAlign.Center
    },
    middle: {
      'anchor': '__container__', 'align': HorizontalAlign.Center
    },
  };
  public static startTopRule: AlignRuleOption = {
    top: {
      'anchor': '__container__', 'align': VerticalAlign.Top
    },
    left: {
      'anchor': '__container__', 'align': HorizontalAlign.Start
    },
  };
}