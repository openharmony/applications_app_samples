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

import { Options } from '../model/OptionsData'

export const OPTIONS: Array<Options> = [
  {
    category: 'Veggie',
    subcategory: ['potato', 'cabbage', 'eggplant']
  },
  {
    category: 'Fruit',
    subcategory: ['apple', 'banana', 'peach']
  },
  {
    category: 'Meat',
    subcategory: ['beef', 'pork', 'chicken']
  },
  {
    category: 'Snacks',
    subcategory: ['biscuits', 'chips', 'candy']
  }
]

export const PRICE_LIST: Map<string, number> = new Map([
  ['potato', 4],
  ['cabbage', 2],
  ['eggplant', 6],
  ['apple', 8],
  ['banana', 6],
  ['peach', 12],
  ['beef', 25],
  ['chicken', 8],
  ['pork', 12],
  ['biscuits', 15],
  ['candy', 20],
  ['chips', 12]
])