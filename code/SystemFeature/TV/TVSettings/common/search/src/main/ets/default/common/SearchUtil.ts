/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

/**
 * Search util
 */
export class SearchUtil {

  /**
   * Convert json to instance
   */
  @Log
  convertJsonToInstance<T> (json: any, t: {new(): T}): T {
    var instance = new t();

    for (var key in json) {
      if (instance.hasOwnProperty(key)) {
        instance[key] = json[key];
      }
    }

    return instance;
  }

  /**
   * Convert json to SearchData instance
   */
  @Log
  async convertToSearchData(rawData): Promise<SearchData[]> {
    let result: Array<SearchData> = [];

    for (let jsonData of rawData.data) {
      let searchData: SearchData = new SearchData();
      searchData.title = await ResourceUtil.getString(rawData.title);
      searchData.keyword = await ResourceUtil.getString(jsonData.keyword);
      searchData.summary = jsonData.summary ? await ResourceUtil.getString(jsonData.summary) : jsonData.summary;
      searchData.synonym = jsonData.synonym ? await ResourceUtil.getString(jsonData.synonym) : jsonData.synonym;

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
    var pattern = new RegExp("[`~!@#$%^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]")
    var rs = "";
    for (var i = 0; i < text.length; i++) {
      rs = rs + text.substr(i, 1).replace(pattern, '');
    }
    return rs;
  }

}

let searchUtil = new SearchUtil();
export default searchUtil as SearchUtil;
