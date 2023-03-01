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

import storageStatistics from '@ohos.file.storageStatistics'
import fileio from '@ohos.fileio'
import Logger from '../../utils/Logger'
import { FileType, SubDirectoryType } from '../../mock/local/FileData'
import prompt from '@ohos.promptAction'

// 大小和单位
const GB_MAGNITUDE: number = 1024 * 1024 * 1024
const MB_MAGNITUDE: number = 1024 * 1024
const KB_MAGNITUDE: number = 1024
const GB_SYMBOL: string = 'GB'
const MB_SYMBOL: string = 'MB'
const KB_SYMBOL: string = 'KB'
const BYTE_SYMBOL: string = 'B'

class FileSystem {
  // 总空间---默认GB
  async getTotalSize(): Promise<string> {
    let totalSize: number = await storageStatistics.getTotalSize()
    // 处理大小
    return `${(totalSize / GB_MAGNITUDE).toFixed(2)}${GB_SYMBOL}`
  }

  // 剩余空间
  async getFreeSize(): Promise<string> {
    let freeSize = await storageStatistics.getFreeSize()
    if (freeSize / GB_MAGNITUDE > 1) {
      return `${(freeSize / GB_MAGNITUDE).toFixed(2)}${GB_SYMBOL}`
    } else if (freeSize / MB_MAGNITUDE > 1) {
      return `${(freeSize / MB_MAGNITUDE).toFixed(2)}${MB_SYMBOL}`
    } else if (freeSize / KB_MAGNITUDE > 1) {
      return `${(freeSize / KB_MAGNITUDE).toFixed(2)}${KB_SYMBOL}`
    } else {
      return `${freeSize}${BYTE_SYMBOL}`
    }
  }

  // 根据沙箱路径打开目录
  getSubdirectory(filePath: string): Array<SubDirectoryType> {
    // 获取目录
    let dir = fileio.opendirSync(filePath)
    // 读取的结果
    let dirent
    // 结果数组
    let subdirectory = []
    do {
      dirent = dir.readSync()
      if (dirent) {
        let subdirectoryNum = 0
        let fileSize = ''
        let time = new Date()
        // 如果是文件夹，就读取文件夹中文件的数量
        if (dirent.isDirectory()) {
          subdirectoryNum = this.getSubdirectoryNum(filePath + `${dirent.name}`)
        } else {
          // 如果不是问价夹，就读取文件大小和时间
          fileSize = this.getFileSize(filePath + `${dirent.name}`)
          time = this.getFileTime(filePath + `${dirent.name}`)
        }
        subdirectory.push({
          name: dirent.name,
          type: dirent.isDirectory() ? 1 : 2,
          time,
          childrenNum: subdirectoryNum,
          fileSize
        })
      }
    } while (dirent)
    return subdirectory
  }

  // 获取目录中的子目录个数
  getSubdirectoryNum(filePath: string): number {
    let dir = fileio.opendirSync(filePath)
    // 读取的结果
    let dirent
    // 记录子目录的个数
    let subdirectoryNum = 0
    do {
      dirent = dir.readSync()
      if (dirent) {
        subdirectoryNum++
      }
    } while (dirent)
    return subdirectoryNum
  }

  // 获取文件大小
  getFileSize(filePath: string): string {
    try {
      let fileSize = fileio.statSync(filePath).size
      if (fileSize / GB_MAGNITUDE > 1) {
        return `${(fileSize / GB_MAGNITUDE).toFixed(2)}${GB_SYMBOL}`
      } else if (fileSize / MB_MAGNITUDE > 1) {
        return `${(fileSize / MB_MAGNITUDE).toFixed(2)}${MB_SYMBOL}`
      } else if (fileSize / KB_MAGNITUDE > 1) {
        return `${(fileSize / KB_MAGNITUDE).toFixed(2)}${KB_SYMBOL}`
      } else {
        return `${fileSize}${BYTE_SYMBOL}`
      }
    } catch (err) {
      Logger.error(`getFileSize failed，code is ${err.code}, message is ${err.message}`)
    }
  }

  // 获取文件修改时间
  getFileTime(filePath: string): Date {
    try {
      let fileTime = fileio.statSync(filePath).ctime
      return new Date(fileTime * 1000)
    } catch (err) {
      Logger.error(`getFileTime failed，code is ${err.code}, message is ${err.message}`)
    }
  }

  // 创建目录
  createDirectory(filePath: string): void {
    try {
      fileio.mkdirSync(filePath)
    } catch (err) {
      Logger.error(`create directory failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  // 创建文件
  createFile(filePath: string): void {
    try {
      fileio.openSync(filePath, 0o100, 0o666)
    } catch (err) {
      Logger.error(`create file failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  // 删除目录和文件---选中项
  deleteSelected(dataArray: Map<string, number>): void {
    try {
      // 遍历数据，分别调用对应的api删除数据
      for (let data of dataArray) {
        if (data[1] === 1) {
          fileio.rmdirSync(data[0])
        } else {
          fileio.unlinkSync(data[0])
        }
      }
      prompt.showToast({ message: $r('app.string.label_delete_success') })
    } catch (err) {
      Logger.error(`delete failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  // 复制文件
  copyFile(filePath: string, newFilePath: string): void {
    try {
      // 遍历数据直接copy所有项目
      fileio.copyFileSync(filePath, newFilePath)
    } catch (err) {
      Logger.error(`copy file failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  // 重命名文件
  renameFile(filePath: string, newFilePath: string): void {
    try {
      fileio.renameSync(filePath, newFilePath)
    } catch (err) {
      Logger.error(`rename file failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  // 开始移动文件
  startMoveFile(needMoveFiles: Array<FileType>, newFilePath: string): void {
    // 遍历数据
    needMoveFiles.forEach((file: FileType): void => {
      // 如果是目录
      if (file.type === 1) {
        // 先创建这个目录
        this.createDirectory(`${newFilePath}/${file.fileName}`)
        // 获取当前文件夹下的所有文件目录
        let subdirectory = this.getSubdirectory(`${file.filePath}/`)
        // 处理为我们想要的格式
        let needMoveFiles: Array<FileType> = []
        // 遍历子目录数据
        subdirectory.forEach((subdirectoryData: SubDirectoryType) => {
          let data = {
            filePath: `${file.filePath}/${subdirectoryData.name}`,
            fileName: subdirectoryData.name,
            type: subdirectoryData.type
          }
          // 逐一添加进去
          needMoveFiles.push(data)
        })
        // 使用我们的数据递归
        this.startMoveFile(needMoveFiles, `${newFilePath}/${file.fileName}`)
      } else {
        this.copyFile(file.filePath, `${newFilePath}/${file.fileName}`)
      }
    })
  }
}

export default new FileSystem()