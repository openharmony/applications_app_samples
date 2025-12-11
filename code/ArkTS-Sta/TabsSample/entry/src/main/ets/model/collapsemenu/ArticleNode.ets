'use static';
/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
 * 数据类型(开发者可以自行扩展数据属性)
 *
 * @param {number} type - 数据类型
 * @param {string} title - 数据标题
 * @param {string} url - 文章地址
 * @param {ArticleNode[]} children - 子数据列表
 */

export class ArticleNode  {
  public type: number = 0
  public title: string = ''
  public url?: string = ''
  public children?:ArticleNode[] = []
}
