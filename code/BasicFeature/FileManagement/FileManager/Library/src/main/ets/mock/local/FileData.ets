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

// 文件价\文件结构
export class FileStructure {
  // 名字
  public name: string
  // 时间
  public time: string
  // 子文件数量
  public childrenNum: number
  // 数据类型 1：文件夹、2：文件
  public type: number
  // 文件大小
  public size: string
  // 处理日期格式
  private dateFormat(time: Date): string {
    let date = time
    let year = date.getFullYear()
    let month: string | number = date.getMonth() + 1
    month = month >= 10 ? month : ('0' + month)
    let day: string | number = date.getDate()
    day = day >= 10 ? day : ('0' + day)
    let hours: string | number = date.getHours()
    hours = hours >= 10 ? hours : ('0' + hours)
    let minutes: string | number = date.getMinutes()
    minutes = minutes >= 10 ? minutes : ('0' + minutes)
    return `${year}/${month}/${day} ${hours}:${minutes}`
  }

  constructor(name: string, type: number, time: Date, childrenNum?: number, size?: string) {
    this.name = name
    this.type = type
    // 如果是文件就给出子目录文件数量，如果不是就给出文件大小
    if (type === 1) {
      this.childrenNum = childrenNum
    } else {
      this.size = size
    }
    // 创建时间，没有的话给当前时间
    this.time = this.dateFormat(time)
  }
}

// 待删除的目录结构
export type DeletedData = {
  path: string
  type: number
}

// 移动文件的结构
export type FileType = {
  // 路径---完整路径，用于打开或者直接创建copy
  filePath: string
  // 名字---拼接到目标路径下
  fileName: string
  // 类型---判断是否进入递归
  type: number
}

// 子目录结构
export type SubDirectoryType = {
  name: string,
  type: number,
  time: Date,
  childrenNum: number,
  fileSize: string
}