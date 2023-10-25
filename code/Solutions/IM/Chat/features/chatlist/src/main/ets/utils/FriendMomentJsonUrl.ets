/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export default class FriendMomentJsonUrl {
  public static readonly FRIEND_MOMENT_JSON_URL: Array<string> = [
    'https://gitee.com/openharmony/applications_app_samples/raw/master/code/Solutions' +
      '/IM/Chat/features/chatlist/src/main/resources/rawfile/mockFriendMomentOneModelData.json',
    'https://gitee.com/openharmony/applications_app_samples/raw/master/code/Solutions' +
      '/IM/Chat/features/chatlist/src/main/resources/rawfile/mockFriendMomentTwoModelData.json',
    'https://gitee.com/openharmony/applications_app_samples/raw/master/code/Solutions' +
      '/IM/Chat/features/chatlist/src/main/resources/rawfile/mockFriendMomentThreeModelData.json'
  ]
  // getWebData 中使用的连接时间
  public static CONNECT_TIME: number = 60000;
  // getWebData 中使用的读取时间
  public static READ_TIME: number = 60000;
}