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

import SearchData from '../model/SearchData';
import Log from '../../../../../../utils/src/main/ets/default/baseUtil/LogDecorator';
import ResourceUtil from './ResourceUtil';

export interface SearchTextResource {
  id: number;
}

export interface SearchRawItem {
  keyword: SearchTextResource;
  summary?: SearchTextResource;
  synonym?: SearchTextResource;
}

export interface SearchRawData {
  title: SearchTextResource;
  data: Array<SearchRawItem>;
}

export interface SearchResourceReader {
  getString(resource: SearchTextResource): Promise<string>;
}

/**
 * Search util
 */
export class SearchUtil {

  /**
   * Convert json to instance
   */
  @Log
  convertJsonToInstance<T extends Object>(json: Object, instance: T): T {
    let keys: Array<string> = Object.keys(json as Object);
    for (let i = 0; i < keys.length; i++) {
      let key: string = keys[i];
      if (Reflect.has(instance as Object, key)) {
        let value: Object = Reflect.get(json as Object, key) as Object;
        Reflect.set(instance as Object, key, value);
      }
    }
    return instance;
  }

  /**
   * Convert json to SearchData instance
   */
  @Log
  async convertToSearchData(rawData: SearchRawData, resourceReader: SearchResourceReader = ResourceUtil): Promise<SearchData[]> {
    let result: Array<SearchData> = [];

    for (let jsonData of rawData.data) {
      let searchData: SearchData = new SearchData();
      searchData.title = await resourceReader.getString(rawData.title);
      searchData.keyword = await resourceReader.getString(jsonData.keyword);
      searchData.summary = jsonData.summary ? await resourceReader.getString(jsonData.summary) : '';
      searchData.synonym = jsonData.synonym ? await resourceReader.getString(jsonData.synonym) : '';

      result.push(searchData);
    };

    return result;
  }

  /**
   * Delete illegal characters from search keyword
   *
   * @param text
   */
  stripKeyword(text: string): string  {
    let pattern = new RegExp("[`~!@#$%^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]")
    let rs = "";
    for (let i = 0; i < text.length; i++) {
      rs = rs + text.substr(i, 1).replace(pattern, '');
    }
    return rs;
  }

}

let searchUtil = new SearchUtil();
export default searchUtil as SearchUtil;
