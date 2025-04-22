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

#include "base64.h"

static uint8 alphabet_map[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static uint8 reverse_map[] =
{
255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 62, 255, 255, 255, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 255, 255, 255, 255, 255, 255,
	255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 255, 255, 255, 255, 255,
	255, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 255, 255, 255, 255, 255
};

int base64_decode(const uint8* code, uint32 code_len, char* str)
{
	uint8 plain[1024];
	assert((code_len & 0x03) == 0); // 如果它的条件返回错误，则终止程序执行。4的倍数。

	uint32 i, j = 0;
	uint8 quad[4];
	for (i = 0; i < code_len; i += 4)
	{
		for (uint32 k = 0; k < 4; k++)
		{
			quad[k] = reverse_map[code[i + k]]; // 分组，每组四个分别依次转换为base64表内的十进制数
		}

		assert(quad[0] < 64 && quad[1] < 64);

		plain[j++] = (quad[0] << 2) | (quad[1] >> 4); // 取出第一个字符对应base64表的十进制数的前6位与第二个字符对应base64表的十进制数的前2位进行组合

		if (quad[2] >= 64)
			break;
		else if (quad[3] >= 64)
		{
			plain[j++] = (quad[1] << 4) | (quad[2] >> 2); // 取出第二个字符对应base64表的十进制数的后4位与第三个字符对应base64表的十进制数的前4位进行组合
			break;
		}
		else
		{
			plain[j++] = (quad[1] << 4) | (quad[2] >> 2);
			plain[j++] = (quad[2] << 6) | quad[3]; // 取出第三个字符对应base64表的十进制数的后2位与第4个字符进行组合
		}
	}
	plain[j] = 0;
	strcpy(str, (char*)plain);
	return j;
}
