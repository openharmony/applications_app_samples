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

export const SUFFIX_AUDIO: string[] =
  IgnoreCase(['.mp3', '.aac', '.flac', '.m4a', '.wav', '.vorbis', '.opus', '.pcm', '.wave', '.ac3', '.dts', '.midi',
    '.amr-nb', '.amr-wb', '.amr', '.ogg', '.ape', '.g711', '.l2hc-ai', '.adts', '.imelody', '.rtttl', '.ota', '.cook']);

export const SUFFIX_IMAGE: string[] = IgnoreCase(['.jpg', '.jpeg', '.png', '.heif', '.webp', 'bmp', 'gif', '.svg']);

export const SUFFIX_VIDEO: string[] =
  IgnoreCase(['.ts', '.mpg', '.mp4', '.mov', '.m3u8', '.mkv', '.avi', '.webm', '.avc', '.hevc', '.mpeg-4', '.vp9',
    '.vp8', '.av1', '.wmv', '.3gpp', '.3gp', '.matroska', '.m2ts', '.mts', '.ogg', '.rm', '.rmvb', '.m4v', '.trp',
    '.vob', '.mpeg']);

export const SUFFIX_TEXT: string[] = IgnoreCase(['.doc', '.docx', '.ppt', '.pptx', '.xls', '.xlsx', '.pdf', '.txt']);

function IgnoreCase(arr: string[]): string[] {
  let list: string[] = arr.map(it => it.toUpperCase());
  list.push(...arr);
  return list;
}

export function checkSuffix(name: string, arr: string[]): boolean {
  if (name && arr.find(it => name.endsWith(it))) {
    return true;
  } else {
    return false;
  }
}
