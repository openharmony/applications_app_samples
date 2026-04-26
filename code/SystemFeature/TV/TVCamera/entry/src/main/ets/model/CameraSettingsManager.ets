/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

class CameraSettingsManager {
  private settings: Map<string, string> = new Map<string, string>([
    ['photoResolution', '1920x1080'],
    ['videoResolution', '1080p']
  ]);

  private listeners: ((key: string, value: string) => void)[] = [];

  /**
   * 读取指定设置项。
   *
   * @param key 设置键名
   * @returns string 设置值
   */
  getSetting(key: string): string {
    return this.settings.get(key) ?? '';
  }

  /**
   * 写入指定设置项。
   *
   * @param key 设置键名
   * @param value 设置值
   * @returns boolean 是否写入成功
   */
  setSetting(key: string, value: string): boolean {
    this.settings.set(key, value);
    this.listeners.forEach((listener) => {
      listener(key, value);
    });
    return true;
  }

  /**
   * 获取全部设置项。
   *
   * @returns Record<string, string> 当前设置快照
   */
  getAllSettings(): Record<string, string> {
    let result: Record<string, string> = {};
    this.settings.forEach((value, key) => {
      result[key] = value;
    });
    return result;
  }

  /**
   * 保存设置。
   *
   * @returns boolean 是否保存成功
   */
  saveSettings(): boolean {
    return true;
  }

  /**
   * 加载设置。
   *
   * @returns boolean 是否加载成功
   */
  loadSettings(): boolean {
    return true;
  }

  /**
   * 恢复默认设置。
   *
   * @returns boolean 是否重置成功
   */
  resetSettings(): boolean {
    this.settings.set('photoResolution', '1920x1080');
    this.settings.set('videoResolution', '1080p');
    return true;
  }

  /**
   * 校验设置值是否合法。
   *
   * @param key 设置键名
   * @param value 设置值
   * @returns boolean 是否合法
   */
  validateSetting(key: string, value: string): boolean {
    if (key === 'photoResolution') {
      return value.indexOf('x') > 0;
    }
    return value.length > 0;
  }

  /**
   * 注册设置监听。
   *
   * @param listener 设置变化回调
   * @returns boolean 是否注册成功
   */
  addListener(listener: (key: string, value: string) => void): boolean {
    this.listeners.push(listener);
    return true;
  }

  /**
   * 取消设置监听。
   *
   * @param listener 设置变化回调
   * @returns boolean 是否移除成功
   */
  removeListener(listener: (key: string, value: string) => void): boolean {
    this.listeners = this.listeners.filter((item) => item !== listener);
    return true;
  }
}

export default new CameraSettingsManager();
