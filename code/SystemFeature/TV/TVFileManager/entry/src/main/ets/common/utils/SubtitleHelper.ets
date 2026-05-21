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

import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 字幕文件帮助类
 * 功能：根据视频文件路径，查找同级目录下同名的字幕文件的后缀名
 */
const TAG: string = 'SubtitleHelper';

export class SubtitleHelper {
  // 常见的字幕文件扩展名
  private readonly SUBTITLE_EXTENSIONS: string[] = [
    '.srt', '.ass', '.ssa', '.vtt', '.sub', '.sbv', '.ttml', '.txt', '.lrc', '.smi'
  ];

  /**
   * 根据视频文件路径查找同名字幕文件的后缀名
   * @param videoPath 视频文件路径
   * @returns 字幕文件后缀名数组（如 ['.srt', '.ass']），如果没有找到返回空数组
   */
  public async findSubtitleExtensionsForVideo(videoPath: string): Promise<string[]> {
    try {
      // 获取视频文件所在目录
      let videoDir: string = fs.openSync(videoPath)?.path;
      videoDir = this.getDirectoryFromPath(videoDir);
      if (!videoDir) {
        console.error(TAG, '无法获取视频所在目录');
        return [];
      }

      // 获取视频文件名（不含扩展名）
      const videoName: string = this.getFileNameWithoutExtension(videoPath);
      if (!videoName) {
        console.error(TAG, '无法获取视频文件名');
        return [];
      }

      console.log(TAG, `查找字幕扩展名: 视频目录=${videoDir}, 视频名=${videoName}`);

      // 查找精确匹配的字幕文件后缀名
      const extensions: string[] = await this.findSubtitlesByExtensions(videoDir, videoName);

      if (extensions.length > 0) {
        console.log(TAG, `找到精确匹配的字幕扩展名: ${extensions}`);
        return extensions;
      }

      console.log(TAG, '未找到任何字幕文件');
      return [];

    } catch (error) {
      console.error(TAG, '查找字幕文件后缀名失败:', error);
      return [];
    }
  }

  /**
   * 精确匹配：查找与视频文件完全同名的字幕文件后缀名
   */
  public async findSubtitlesByExtensions(directory: string, videoName: string): Promise<string[]> {
    const foundExtensions: string[] = [];

    for (const ext of this.SUBTITLE_EXTENSIONS) {
      const subtitlePath: string = `${directory}/${videoName}${ext}`;
      console.log(TAG, `检查路径: ${subtitlePath}`);

      try {
        const exists: boolean = await this.checkFileExists(subtitlePath);
        if (exists) {
          foundExtensions.push(ext);
          console.log(TAG, `找到文件: ${subtitlePath}`);
        } else {
          console.log(TAG, `文件不存在: ${subtitlePath}`);
        }
      } catch (error) {
        console.error(TAG, `检查文件 ${subtitlePath} 时出错:`, error);
      }
    }

    return foundExtensions;
  }

  /**
   * 获取文件所在目录路径
   */
  public getDirectoryFromPath(filePath: string): string {
    const lastSlash: number = filePath.lastIndexOf('/');
    return lastSlash > 0 ? filePath.substring(0, lastSlash) : '';
  }

  /**
   * 获取文件名（不含扩展名）
   */
  public getFileNameWithoutExtension(filePath: string): string {
    const lastSlash: number = filePath.lastIndexOf('/');
    const lastDot: number = filePath.lastIndexOf('.');

    // 提取文件名
    let fileName: string = '';
    if (lastSlash >= 0) {
      fileName = filePath.substring(lastSlash + 1);
    } else {
      fileName = filePath;
    }

    // 去除扩展名
    if (lastDot > lastSlash) {
      let lastDot1: number = fileName.lastIndexOf('.');
      fileName = fileName.substring(0, lastDot1);
    }

    return fileName;
  }

  /**
   * 检查文件是否存在
   */
  public async checkFileExists(filePath: string): Promise<boolean> {
    try {
      let isHave: boolean = await fs.access(filePath);
      return isHave;
    } catch (accessError) {
      return false;
    }
  }

  /**
   * 获取文件扩展名
   */
  public getFileExtension(filePath: string): string {
    const lastDot: number = filePath.lastIndexOf('.');
    if (lastDot === -1) {
      return '';
    }
    return filePath.substring(lastDot).toLowerCase();
  }
}

let subtitleHelper: SubtitleHelper = new SubtitleHelper();

export default subtitleHelper;
