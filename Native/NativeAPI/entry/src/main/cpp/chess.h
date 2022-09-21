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
#ifndef NativeAPI_chess_H
#define NativeAPI_chess_H

const int SIZE = 15; // 棋盘大小
const int WIN_NUM = 5; // 五子棋连子最大数
const int USER_CHESS = 1; // 1为用户落子
const int AI_CHESS = 2; // 2为AI落子
const int NO_CHESS = 0; // 0为空位
const int MAX_SIZE = 4; // 4为最大数组数
const int LINE_THREE_PIECE = 3; // 3为水平棋子数
const int VERTICAL_THREE_PIECE = 3; // 3为竖直棋子数
const int RIGHT_OBLIQUE_PIECE = 3; // 3为右斜棋子数
const int INDEX_NUM = 2; // 2为循环索引
int chessBoard[SIZE][SIZE] = { // 五子棋棋盘，默认0为空位置，1为用户落子，2为AI落子
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } };
int USER_WIN = 1; // 1代表用户胜利
int AI_WIN = 2; // 2代表AI胜利
int NO_WIN = 0; // 0代表无胜利方
int result[3] = { NO_WIN, SIZE + 1, SIZE + 1 }; // 记录ai上次的落子位置,result返回0代表无胜利方，返回1代表用户胜利，返回2代表AI胜利
int aiCoiledNum = 0; // 记录AI当前最大连子数

#endif // NativeAPI_chess_H
