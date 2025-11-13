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
// [Start GrandParent2_start]
const GRANDPARENT_REVIEW_VOTES_INITIAL = 40;
const PARENT_REVIEW_VOTES_INITIAL = 20;
const CHILD_REVIEW_VOTES_INITIAL = 0;

@Entry
@ComponentV2
struct GrandParent {
  @Provider('reviewVotes') reviewVotes: number = GRANDPARENT_REVIEW_VOTES_INITIAL;

  build() {
    Column() {
      Parent()
    }
  }
}

@ComponentV2
struct Parent {
  // @Provider默认支持重载，@Consumer向上查找最近的@Provider
  @Provider() reviewVotes: number = PARENT_REVIEW_VOTES_INITIAL;

  build() {
    Child()
  }
}

@ComponentV2
struct Child {
  @Consumer() reviewVotes: number = CHILD_REVIEW_VOTES_INITIAL;

  build() {
    Text(this.reviewVotes.toString()) // Text显示20
  }
}
// [End GrandParent2_start]
const grandParent2 = GrandParent;
export default grandParent2;