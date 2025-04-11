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

import { CommentData, FriendMoment } from './BasicDataSource';


// 模拟评论数据
export function mockData(): CommentData {
  const commentList: CommentData = new CommentData();
  commentList.pushData(new FriendMoment('0', 'Zoologist', $r('app.media.Zoologist'), '好可爱的小鸟啊',
    $r('app.media.publish_photo_bird')));
  commentList.pushData(new FriendMoment('1', 'Scientist', $r('app.media.Scientist'), '今天研究个大火箭',
    $r('app.media.rocket')));
  commentList.pushData(new FriendMoment('2', 'Engineer', $r('app.media.Engineer'), '又要熬夜画图纸了', '',
    $r('app.media.Engineer_video')));
  commentList.pushData(new FriendMoment('3', 'Architect', $r('app.media.Architect'), '看看我新设计的大楼',
    $r('app.media.Building')));
  commentList.pushData(new FriendMoment('4', 'IT Engineer', $r('app.media.IT_Engineer'), '电脑怎么又死机了',
    $r('app.media.Computer')));
  commentList.pushData(new FriendMoment('5', 'Artist', $r('app.media.Artist'), '作画', $r('app.media.Draw')));
  commentList.pushData(new FriendMoment('6', 'Chef', $r('app.media.Chef'), '来杯香槟', '', $r('app.media.Champagne')));
  return commentList;
}

