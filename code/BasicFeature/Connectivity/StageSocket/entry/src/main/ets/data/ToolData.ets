/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
 * 更多功能 中组件信息对象
 */
export default class ToolData {
  private imgResource: Resource;
  private bundleName: string;
  private abilityName: string;
  private parameters?: Record<string, Object>;

  constructor(imgResource: Resource, bundleName: string, abilityName: string, parameters?: Record<string, Object>) {
    this.imgResource = imgResource;
    this.bundleName = bundleName;
    this.abilityName = abilityName;
    if (parameters) {
      this.parameters = parameters;
    }
  }

  public setImgResource(imgResource: Resource): void {
    this.imgResource = imgResource;
  }

  public getImgResource(): Resource {
    return this.imgResource;
  }

  public setBundleName(bundleName: string): void {
    this.bundleName = bundleName;
  }

  public getBundleName(): string {
    return this.bundleName;
  }

  public setAbilityName(abilityName: string): void {
    this.abilityName = abilityName;
  }

  public getAbilityName(): string {
    return this.abilityName;
  }

  public setParameters(parameters: Record<string, Object>): void {
    this.parameters = parameters;
  }

  public getParameters(): Record<string, Object> {
    return this.parameters as Record<string, Object>;
  }
}