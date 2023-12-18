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

import { Controller, Get, Param } from '@nestjs/common';
import { AppService } from './app.service';
import { executeCommand, logger } from './util';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('获取设备SN')
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) { }

  @ApiOperation({
    summary: '获取设备SN'
  })
  @Get('sn')
  async findAll(): Promise<string> {
    try {
      let sn = await executeCommand('hdc list targets');
      sn = sn.slice(1).slice(0, sn.length - 6);
      if (sn.indexOf('Empty') !== -1) {
        logger(AppController.name).log(`获取设备号失败，当前终端没有连接设备`);
        return JSON.stringify({
          status: 'failed',
          sn: '',
          msg: '当前终端没有连接设备'
        });
      };
      logger(AppController.name).log(`获取设备号成功 ` + sn);
      return JSON.stringify({
        status: 'success',
        sn,
        msg: '获取设备号成功'
      });
    } catch (error) {
      logger(AppController.name).log(`获取设备号失败 ` + JSON.stringify(error));
      return JSON.stringify({
        status: 'failed',
        sn: '',
        msg: `获取设备号失败 ` + JSON.stringify(error)
      });
    };
  }
}
