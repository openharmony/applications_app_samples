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
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
struct ParticleExample5 {
  build() {
    Stack() {
      Text()
        .width(300).height(300).backgroundColor(Color.Black)
      Particle({
        particles: [
          {
            emitter: {
              particle: {
                type: ParticleType.POINT, //粒子类型
                config: {
                  radius: 5//圆点半径
                },
                count: 2000, //粒子总数
                lifetime: 10000, //粒子生命周期，单位ms
                lifetimeRange: 100//粒子生命周期取值范围，单位ms
              },
              emitRate: 100, //每秒发射粒子数
              shape: ParticleEmitterShape.ANNULUS,//环形发射器
              annulusRegion:{
                center:{x:LengthMetrics.percent(0.5),y:LengthMetrics.percent(0.5)}, // 圆环的圆心坐标
                innerRadius:LengthMetrics.vp(100), // 圆环的外圆半径
                outerRadius:LengthMetrics.vp(120), // 圆环的内圆半径
                startAngle:0, // 圆环的起始角度
                endAngle:360 // 圆环的结束角度
              }
            },
            color: {
              range: [Color.Pink, Color.White],
            },
            opacity: {
              range: [0.0, 1.0],
              updater: {
                type: ParticleUpdater.CURVE,
                config: [
                  {
                    from: 0.0,
                    to: 1.0,
                    startMillis: 0,
                    endMillis: 3000,
                    curve: Curve.EaseIn
                  },
                  {
                    from: 1.0,
                    to: 0.0,
                    startMillis: 5000,
                    endMillis: 10000,
                    curve: Curve.EaseIn
                  }
                ]
              }
            },
            scale: {
              range: [0.0, 0.0],
              updater: {
                type: ParticleUpdater.CURVE,
                config: [
                  {
                    from: 0.0,
                    to: 0.5,
                    startMillis: 0,
                    endMillis: 3000,
                    curve: Curve.EaseIn
                  }
                ]
              }
            },
          }
        ]
      }).width(300).height(300)
    }.width("100%").height("100%").align(Alignment.Center)
  }
}