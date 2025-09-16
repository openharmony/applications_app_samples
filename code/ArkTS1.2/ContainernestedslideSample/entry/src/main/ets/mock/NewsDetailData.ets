/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { NewsCommentModel } from '../model/NewsCommentModel';
import { $r } from '@ohos.arkui.component';

export function mockData(): Array<NewsCommentModel> {
  const commentList: Array<NewsCommentModel> = new Array<NewsCommentModel>();
  commentList.push(new NewsCommentModel(
    '1', $r('app.media.news_image_1'), '你若安好便是晴天', '', '', '国足加油！国足必胜！', '2024-11-01 23:00:00')
  ;
  commentList.push(new NewsCommentModel(
    '2', $r('app.media.news_image_2'), '天要下雨娘要嫁人', '', '', '来点信心，加油加油~', '2024-11-01 23:00:00')
  );
  commentList.push(new NewsCommentModel(
    '3', $r('app.media.news_image_3'), '太阳打北边出来了', '', '', '下一场什么时候，有直播吗', '2024-11-01 23:00:00')
  );
  commentList.push(new NewsCommentModel(
    '4', $r('app.media.news_image_4'), '西红柿炒鸡蛋蛋卷(特辣)', '', '', '教练组的战术调整值得肯定，尤其是在中场控制方面有所改善。',
    '2024-11-01 23:00:00')
  );
  commentList.push(new NewsCommentModel(
    '5', $r('app.media.news_image_6'), '东边有个塔玛，西边有个喇嘛', '', '', '期待他们在未来的比赛中继续进步！', '2024-11-01 23:00:00')
  );
  commentList.push(new NewsCommentModel(
    '7', $r('app.media.news_image_7'), '等烟雨而我在等你', '', '', '希望接下来的比赛中继续发挥，成为球队的中坚力量。','2024-11-01 23:00:00')
  );
  commentList.push(new NewsCommentModel(
    '8', $r('app.media.news_image_8'), '大事不妙了', '', '', '与世界强队的差距依然显著，继续努力吧。', '2024-11-01 23:00:00')
  );
  commentList.push(new NewsCommentModel(
    '9', $r('app.media.news_image_5'), '小猫带耳机', '', '', '国足必胜，加油加油。', '2024-11-01 23:00:00')
  );
  return commentList;
}

// 模拟当前用户昵称
export const curUser: string = '兔子不吃窝边草';

