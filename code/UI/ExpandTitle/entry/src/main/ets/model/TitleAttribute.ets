/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * 标题属性
 *
 */
export class TitleAttribute {
  // 标题内容
  private textTmp: string | Resource;
  // 标题样式
  private attributeTmp: AttributeModifier<TextAttribute>;

  constructor(text: string | Resource, attribute: AttributeModifier<TextAttribute>) {
    this.textTmp = text;
    this.attributeTmp = attribute;
  }

  get text(): string | Resource{
    return this.textTmp;
  }

  get attribute(): AttributeModifier<TextAttribute> {
    return this.attributeTmp;
  }
}