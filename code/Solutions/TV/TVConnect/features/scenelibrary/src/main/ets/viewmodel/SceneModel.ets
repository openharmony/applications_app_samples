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

import dataPreferences from '@ohos.data.preferences';
import promptAction from '@ohos.promptAction';
import { Logger, Scene } from '@ohos/common';
import { SceneBean } from '../common/bean/SceneBean';
import { actions, triggerCondition } from '../model/SceneCondition';
import { formProvider } from '@kit.FormKit';

let context = getContext(this);
let preference: dataPreferences.Preferences;
let maxLength = 7000;

export default class SceneModel {
  private static instance: SceneModel = new SceneModel();

  private constructor() {
  }

  public static getInstance(): SceneModel {
    return SceneModel.instance;
  }

  // 创建用户首选项实例preference
  async getPreferencesFromStorage() {
    Logger.info('初始化');
    try {
      preference = await dataPreferences.getPreferences(context, 'SceneData');
    } catch (err) {
      Logger.error('[PreferenceModel]', `Failed to get preferences, Cause: ${err}`);
    }
  }

  // 保存数据
  async putPreference(scene: Array<Scene>) {
    if (preference == undefined) {
      await this.getPreferencesFromStorage();
    }
    // 将用户输入的亮度数据保存到preference，调用用户首选项实例的put接口
    try {
      let lengthSum: number = JSON.stringify(scene).length;
      let length: number = parseInt((lengthSum / maxLength).toString()) + 1;
      let sceneLibrary: string = JSON.stringify(scene);
      for (let index = 1; index <= length; index++) {
        if (index == 1) {
          await preference.put('mySceneList', sceneLibrary.slice(0, maxLength));
        } else {
          let preferenceName: string = `mySceneList${index}`;
          await preference.put(preferenceName, sceneLibrary.slice(maxLength * (index - 1), maxLength * index));
        }
        this.putCustomKey('sceneLength', index);
      }
    } catch (err) {
      Logger.error('[PreferenceModel]', `Failed to put value, Cause: ${err}`);
    }
    // 使用flush方法将preferences实例的数据存储到持久化文件，调用用户首选项实例的flush接口
    await preference.flush();
  }

  // 检测是否存在数据
  hasPreference(): boolean {
    if (preference == undefined) {
      this.getPreferencesFromStorage();
    }
    // 检查缓存的Preferences实例中是否包含名为给定Key的存储键值对，调用用户首选项实例的has接口
    let isExit: boolean = preference.hasSync('mySceneList');
    return isExit;
  }

  // 获取数据，调用用户首选项实例的get接口
  getPreference(): Array<Scene> {
    if (preference == undefined) {
      this.getPreferencesFromStorage();
    }
    let result: Scene[] = [];
    let mySceneList: string = '';
    let length: number = Number(this.getDefaultKey('sceneLength'));
    for (let index = 1; index <= length; index++) {
      if (index == 1) {
        mySceneList = preference.getSync(`mySceneList`, 'default') as string;
      } else {
        mySceneList = mySceneList + preference.getSync(`mySceneList${index}`, 'default') as string;
      }
    }
    result = JSON.parse(mySceneList);
    return result;
  }

  // 校验用户输入是否为空
  checkData(scene: SceneBean) {
    if (scene.triggers.length === 0 || scene.actions.length == 0) {
      return true;
    }
    return false;
  }

  // 点击保存按钮保存数据
  writeData(scene: SceneBean) {
    // Check whether the data is null.
    let isDataNull = this.checkData(scene);
    if (isDataNull) {
      return;
    }
    // The data is inserted into the preferences database if it is not empty.
    this.putPreference([]);
  }

  // 删除数据，调用dataPreferences的deletePreferences接口
  async deletePreferences() {
    try {
      await dataPreferences.deletePreferences(context, 'SceneData');
    } catch (err) {
      Logger.error('[PreferenceModel]', `Failed to delete preferences, Cause: ${err}`);
    }
    ;
  }

  // 存储自定义场景key
  async putCustomKey(keyName: string, key: number) {
    if (preference == undefined) {
      await this.getPreferencesFromStorage();
    }
    try {
      await preference.put(keyName, key);
    } catch (err) {
      Logger.error('[PreferenceModel]', `Failed to put value, Cause: ${err}`);
    }
    await preference.flush();
  }

  // 获取默认名称的key
  getDefaultKey(keyName: string): string {
    if (preference == undefined) {
      this.getPreferencesFromStorage();
    }
    let value: dataPreferences.ValueType = preference.getSync(keyName, 'default');
    if (value == 'default') {
      return '1';
    }
    return JSON.stringify(value);
  }
};