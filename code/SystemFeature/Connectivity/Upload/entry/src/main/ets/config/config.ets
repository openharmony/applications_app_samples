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
export default class config {
  //默认service配置
  static HOST_DEFAULT: string = "http://192.168.18.165"
  //该路径为你用hfs服务器创建的上传路径
  static PATH_DEFAULT: string = "/upload/"
  //此值固定，hfs服务器的文件列表接口
  static QUERY_FILE_PATH: string = "?tpl=list&folders-filter=\&recursive"
  //preference配置
  static PREFERENCES_NAME = "CONFIG_PREFERENCES"
  static HOST_KEY: string = "HOST_KEY"
  static PATH_KEY: string = "PATH_KEY"
}