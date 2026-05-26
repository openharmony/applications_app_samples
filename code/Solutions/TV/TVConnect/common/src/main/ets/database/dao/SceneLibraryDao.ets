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

import { Scene } from '../entity/Scene';
import { ConnectDatabaseHelperImpl } from '../ConnectDatabaseHelperImpl';
import { SceneLibraryField, TableType, } from '../TableConfig';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import relationalStore from '@ohos.data.relationalStore';
import I18n from '@ohos.i18n';


/*
 * 场景库持久化接口
 * */
export class SceneLibraryDao {
  private databaseHelper: ConnectDatabaseHelperImpl | undefined = undefined;

  constructor(databaseHelper: ConnectDatabaseHelperImpl) {
    this.databaseHelper = databaseHelper;
  }

  /*
   * 添加一个场景
   * */
  async addScene(lang: string, value: string): Promise<boolean> {
    const regStr = '\'scenarioCardId\'\: \'\(\.\*\?\)\'';
    let idMatch = value?.match(regStr);
    if (idMatch != null) {
      let id = idMatch[1];
      if (id != null) {
        let vb = { 'scenario_card_id': id, 'language': lang, 'value': value } as ValuesBucket;
        if (this.databaseHelper != undefined) {
          return await this.databaseHelper.insert(TableType.SCENE_LIBRARY, vb);
        }
      }
    }
    return false;
  }

  /*
   * 添加场景列表
   * */
  async addSceneList(scenes: Map<string, Array<string>>): Promise<boolean> {
    const regStr = '\'scenarioCardId\'\: \'\(\.\*\?\)\'';
    let vbs: ValuesBucket[] = [];
    for (let i of scenes) {
      for (let s of i[1]) {
        let idMatch = s?.match(regStr);
        if (idMatch != null) {
          let id = idMatch[1];
          if (id != null) {
            let vb = { 'scenario_card_id': id, 'language': i[0], 'value': s } as ValuesBucket;
            vbs.push(vb);
          }
        }
      }
    }
    if (this.databaseHelper != undefined) {
      return await this.databaseHelper.batchInsert(TableType.SCENE_LIBRARY, vbs);
    }
    return false;
  }

  /*
   * 删除场景库全部场景
   * */
  async deleteAllScene(): Promise<boolean> {
    if (this.databaseHelper != undefined) {
      await this.databaseHelper.delete(new relationalStore.RdbPredicates(TableType.SCENE_LIBRARY));
    }
    return false;
  }

  /*
   * 查询全部场景
   * */
  async queryAllScene(): Promise<Scene[]> {
    let res: Scene[] = [];
    let predicates = new relationalStore.RdbPredicates(TableType.SCENE_LIBRARY);
    predicates.equalTo(SceneLibraryField.LANGUAGE, this.getLanguage());
    if (this.databaseHelper != undefined) {
      let scenes = await this.databaseHelper.queryByCondition(TableType.SCENE_LIBRARY, predicates);
      for (let s of scenes) {
        let lang = s.get(SceneLibraryField.LANGUAGE);
        let i = s.get(SceneLibraryField.VALUE);
        if (i != undefined) {
          let scene: Scene = JSON.parse(i);
          res.push(scene);
        }
      }
    }
    return res;
  }

  /*
   * 根据id查询场景
   * */
  async querySceneById(id: string): Promise<Scene | null> {
    let predicates = new relationalStore.RdbPredicates(TableType.SCENE_LIBRARY);
    predicates.equalTo(SceneLibraryField.SCENE_ID, id);
    predicates.equalTo(SceneLibraryField.LANGUAGE, this.getLanguage());
    if (this.databaseHelper != undefined) {
      let scenes = await this.databaseHelper.queryByCondition(TableType.SCENE_LIBRARY, predicates);
      for (let s of scenes) {
        let i = s.get(SceneLibraryField.VALUE);
        if (i != undefined) {
          return JSON.parse(i) as Scene;
        }
      }
    }
    return null;
  }

  private getLanguage(): string {
    let appPreferredLanguage: string = I18n.System.getAppPreferredLanguage();
    const zhReg = '\^zh\(\-\[\\w\]\+\)\*\$';
    let isZhMatch = appPreferredLanguage.toLowerCase().match(zhReg);
    let isZh: boolean = isZhMatch != null;
    if (isZh) {
      return 'zh-cn';
    }
    let isEnUsMatch = appPreferredLanguage.toLowerCase().match('uk');
    if (isEnUsMatch) {
      return 'en-uk';
    } else {
      return 'en-us';
    }
  }
}