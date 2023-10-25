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

import { TitleBar } from '../../../../common/TitleBar';

class TrackSpawnReturn {
  x?: number;
  y?: number;
  d: number = 0.0;
}
class Point {
  x: number = 0.0;
  y: number = 0.0;
  vy: number = 0.0;
  z: number = 0.0;
  radius: number = 0.0;
  color: number = 0.0;
  distance: number = 0.0;
}
class ParticleEngine {
  ctx!: CanvasRenderingContext2D;
  width: number = 0;
  height: number = 0;
  frameNo: number = 0;

  // canvas x
  camX: number = 0;
  // canvas y
  camY: number = 0;
  // canvas analog z
  camZ: number = 0;
  // particle curve rate of its orbits
  pitch: number = 0.0;
  yaw: number = 0;
  // central axis of canvas width
  cx: number = 0.0;
  // central axis of canvas height
  cy: number = 0.0;
  // particle orbits generation scale
  scale: number = 0;

  points:Array<Point> = [];
  // max particles to be generated
  initParticles: number = 0;
  // y shifting rate for each frame
  initV: number = 0.0;
  // max particles generation radius
  distributionRadius: number = 0;
  // vortex generated height
  vortexHeight: number = 0;
}

let sampleParticleEngine: ParticleEngine = new ParticleEngine();

@Entry
@Component
struct ParticleSample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private spawn: boolean = false;
  private interval: number = 0;

  elevation(x: number, y: number, z: number) {
    let distance = Math.sqrt(x * x + y * y + z * z);
    if (distance && z / distance >= -1 && z / distance <= 1){
      return Math.acos(z / distance);
    }
    return 0.00000001;
  }

  rgb(colorRGBData: number) {
    colorRGBData += 0.000001;
    // generate rgb value by random for particles
    let r = Math.round((0.5 + Math.sin(colorRGBData) * 0.5) * 16);
    let g = Math.round((0.5 + Math.cos(colorRGBData) * 0.5) * 16);
    let b = Math.round((0.5 - Math.sin(colorRGBData) * 0.5) * 16);
    return '#' + r.toString(16) + g.toString(16) + b.toString(16);
  }

  interpolateColors(RGB1: number[], RGB2: number[], degree: number) {
    let w2: number = degree;
    let w1: number = 1 - w2;
    return [w1 * RGB1[0] + w2 * RGB2[0], w1 * RGB1[1] + w2 * RGB2[1], w1 * RGB1[2] + w2 * RGB2[2]];
  }

  rgbArray(colorRGBData: number) {
    colorRGBData += 0.000001;
    // generate rgb value by random for particles and returned as an array
    let r = Math.round((0.5 + Math.sin(colorRGBData) * 0.5) * 256);
    let g = Math.round((0.5 + Math.cos(colorRGBData) * 0.5) * 256);
    let b = Math.round((0.5 - Math.sin(colorRGBData) * 0.5) * 256);
    return [r, g, b];
  }

  colorString(colorArray: number[]) {
    // generate rgb value by random with a generated rgb array for particles and returned as a string
    let r = Math.round(colorArray[0]);
    let g = Math.round(colorArray[1]);
    let b = Math.round(colorArray[2]);
    return '#' + ('0' + r.toString(16)).slice(-2) + ('0' + g.toString(16)).slice(-2) + ('0' + b.toString(16)).slice(-2);
  }

  particleEnginePerform(particleEngine: ParticleEngine) {
    if (particleEngine.points.length < particleEngine.initParticles) {
      for (let i = 0; i < 5; ++i) {
        this.particleItemSpawn(particleEngine);
      }
    }
    let p: number, d: number, t: number;

    // generate particle move path for animation which is a spiral orbit
    p = Math.atan2(particleEngine.camX, particleEngine.camZ);
    d = Math.sqrt(particleEngine.camX * particleEngine.camX + particleEngine.camZ * particleEngine.camZ);
    // move by each frame
    d -= Math.sin(particleEngine.frameNo / 80) / 25;
    t = Math.cos(particleEngine.frameNo / 300) / 165;
    particleEngine.camX = Math.sin(p + t) * d;
    particleEngine.camZ = Math.cos(p + t) * d;
    particleEngine.camY = -Math.sin(particleEngine.frameNo / 220) * 15;
    particleEngine.yaw = Math.PI + p + t;
    particleEngine.pitch = this.elevation(particleEngine.camX, particleEngine.camZ, particleEngine.camY) - Math.PI / 2;

    let x: number, y: number, z: number;
    for (let i = 0; i < particleEngine.points.length; ++i) {
      x = particleEngine.points[i].x;
      y = particleEngine.points[i].y;
      z = particleEngine.points[i].z;
      // distance between particles, 1.0075 is the justify number
      d = Math.sqrt(x * x + z * z) / 1.0075;
      t = 0.1 / (1 + d * d / 5);
      p = Math.atan2(x, z) + t;
      particleEngine.points[i].x = Math.sin(p) * d;
      particleEngine.points[i].z = Math.cos(p) * d;
      particleEngine.points[i].y += particleEngine.points[i].vy * t * ((Math.sqrt(particleEngine.distributionRadius) - d) * 2);
      if (particleEngine.points[i].y > particleEngine.vortexHeight / 2 || d < 0.25) {
        particleEngine.points.splice(i, 1);
        this.particleItemSpawn(particleEngine);
      }
    }
  }

  TrackSpawn(x: number, y: number, z: number, particleEngine: ParticleEngine): TrackSpawnReturn {
    let p: number, d: number;
    x -= particleEngine.camX;
    y -= particleEngine.camY - 8;
    z -= particleEngine.camZ;
    p = Math.atan2(x, z);
    d = Math.sqrt(x * x + z * z);
    x = Math.sin(p - particleEngine.yaw) * d;
    z = Math.cos(p - particleEngine.yaw) * d;
    p = Math.atan2(y, z);
    d = Math.sqrt(y * y + z * z);
    y = Math.sin(p - particleEngine.pitch) * d;
    z = Math.cos(p - particleEngine.pitch) * d;
    let rx1 = -1000;
    let ry1 = 1;
    let rx2 = 1000;
    let ry2 = 1;
    let rx3 = 0;
    let ry3 = 0;
    let rx4 = x;
    let ry4 = z;
    let uc = (ry4 - ry3) * (rx2 - rx1) - (rx4 - rx3) * (ry2 - ry1);
    let ua = ((rx4 - rx3) * (ry1 - ry3) - (ry4 - ry3) * (rx1 - rx3)) / uc;
    let ub = ((rx2 - rx1) * (ry1 - ry3) - (ry2 - ry1) * (rx1 - rx3)) / uc;
    if (!z) {
      z = 0.000000001;
    }
    if (ua > 0 && ua < 1 && ub > 0 && ub < 1) {
      return {
        x: particleEngine.cx + (rx1 + ua * (rx2 - rx1)) * particleEngine.scale,
        y: particleEngine.cy + y / z * particleEngine.scale,
        d: (x * x + y * y + z * z)
      };
    } else {
      return { d: -1 };
    }
  }

  sortMethod(a: Point, b: Point) {
    return b.distance - a.distance;
  }

  particleSpawn(particleEngine: ParticleEngine) {
    particleEngine.ctx.globalAlpha = 0.15;
    particleEngine.ctx.fillStyle = '#000';
    particleEngine.ctx.globalCompositeOperation = 'source-over';
    particleEngine.ctx.fillRect(0, 0, particleEngine.width, particleEngine.height);

    let point: TrackSpawnReturn, x: number, y: number, z: number, a: number, size: number, d: number;
    for (let i = 0; i < particleEngine.points.length; ++i) {
      x = particleEngine.points[i].x;
      y = particleEngine.points[i].y;
      z = particleEngine.points[i].z;
      point = this.TrackSpawn(x, y, z, particleEngine);
      if (point.d !== -1) {
        particleEngine.points[i].distance = point.d;
        size = 1 + particleEngine.points[i].radius / (1 + point.d);
        d = Math.abs(particleEngine.points[i].y);
        a = 0.8 - Math.pow(d / (particleEngine.vortexHeight / 2), 1000) * 0.8;
        particleEngine.ctx.globalAlpha = a >= 0 && a <= 1 ? a : 0;
        particleEngine.ctx.fillStyle = this.rgb(particleEngine.points[i].color);
        if (point.x !== undefined && point.y !== undefined && point.x > -1 && point.x < particleEngine.width && point.y > -1 && point.y < particleEngine.height) {
          particleEngine.ctx.fillRect(point.x - size / 2, point.y - size / 2, size, size);
        }
      }
    }
    particleEngine.points.sort(this.sortMethod);
  }

  particleItemSpawn(particleEngine: ParticleEngine) {
    let p: number;
    let ls: number;
    let pt: Point = {
      x: 0.0,
      y: 0.0,
      vy: 0.0,
      z: 0.0,
      radius: 0.0,
      color: 0.0,
      distance: 0.0
    };
    // vortex points x, y, z(analog) values generation
    p = Math.PI * 2 * Math.random();
    ls = Math.sqrt(Math.random() * particleEngine.distributionRadius);
    pt.x = Math.sin(p) * ls;
    pt.y = -particleEngine.vortexHeight / 2;
    pt.vy = particleEngine.initV / 20 + Math.random() * particleEngine.initV;
    pt.z = Math.cos(p) * ls;
    pt.radius = 200 + 800 * Math.random();
    pt.color = pt.radius / 1000 + particleEngine.frameNo / 250;
    particleEngine.points.push(pt);
  }

  init(particleEngine: ParticleEngine) {
    particleEngine.ctx = this.context;
    particleEngine.width = this.context.width;
    particleEngine.height = this.context.height;
    particleEngine.frameNo = 0;

    // canvas x
    particleEngine.camX = 0;
    // canvas y
    particleEngine.camY = 0;
    // canvas analog z
    particleEngine.camZ = -14;
    // particle curve rate of its orbits
    particleEngine.pitch = this.elevation(particleEngine.camX, particleEngine.camZ, particleEngine.camY) - Math.PI / 2;
    particleEngine.yaw = 0;
    // central axis of canvas width
    particleEngine.cx = particleEngine.width / 2;
    // central axis of canvas height
    particleEngine.cy = particleEngine.height / 2;
    // particle orbits generation scale
    particleEngine.scale = 500;

    particleEngine.points = [];
    // max particles to be generated
    particleEngine.initParticles = 80;
    // y shifting rate for each frame
    particleEngine.initV = 0.01;
    // max particles generation radius
    particleEngine.distributionRadius = 800;
    // vortex generated height
    particleEngine.vortexHeight = 25;
  }

  particleFrameGenerate(particleEngine: ParticleEngine) {
    particleEngine.frameNo++;
    this.particleEnginePerform(particleEngine);
    this.particleSpawn(particleEngine);
  }

  animationOn() {
    this.interval = setInterval(() => {
      this.particleFrameGenerate(sampleParticleEngine);
    }, 20);
  }

  build(){
    Column() {
      TitleBar({ title: $r('app.string.particle_effect') });
      Column() {
        Canvas(this.context)
          .width('90%')
          .height('90%')
          .borderRadius(24)
          .backgroundColor(Color.Black);
      }
      .padding(12)
      .margin({ left: 12, right: 12, top: 24, bottom: 24 })
      .borderRadius(24)
      .width('90%')
      .backgroundColor(Color.Black)
      .height('70%');

      Grid() {
        GridItem() {
          Button($r('app.string.particle_spawn'))
            .onClick(() => {
              if (this.spawn !== true) {
                this.init(sampleParticleEngine);
                this.animationOn();
                this.spawn = true;
              }
            })
            .width('100%');
        }

        GridItem() {
          Button($r('app.string.particle_spawn_stop'))
            .onClick(() => {
              this.spawn = false;
              clearInterval(this.interval);
            })
            .width('100%');
        }
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(12)
      .padding({ left: 24, right: 24, bottom: 24 })
      .width('100%');
    }
    .backgroundColor($r('app.color.background_shallow_grey'));
  }

  aboutToDisappear() {
    clearInterval(this.interval);
  }
}