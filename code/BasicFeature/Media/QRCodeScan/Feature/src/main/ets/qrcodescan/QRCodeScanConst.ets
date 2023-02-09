/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

/**
 * 二维码扫描解析常量
 */
export class QRCodeScanConst {
  // 扫描框距离头部高度
  static readonly SCAN_TO_TOP_HEIGHT: number = 120
  // 相机是否已开启标记
  static readonly HAS_CAMERA_PERMISSION: string = 'hasCameraPermission'

  // 二维码扫描解析结果
  static readonly QR_CODE_PARSE_RESULT: string = 'qrCodeParseResult'

  // 二维码图片自定义文件前缀
  static readonly IMG_FILE_PREFIX = 'IMG_QR_CODE_'

  // 二维码图片自定义文件后缀--当前支持jpg
  static readonly IMG_SUFFIX_JPG = '.jpg'

  // 二维码的大小
  static readonly QR_CODE_SIZE: number = px2vp(300)

  // 图片默认大小
  static readonly IMG_DEFAULT_SIZE = {
    WIDTH: 1920,
    HEIGHT: 1080
  }

  // 同时访问的最大图像数
  static readonly MAX_IMAGE_CAPACITY = 8
}