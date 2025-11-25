/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Node, Quaternion, Vec3 } from '@kit.ArkGraphics3D';

function sub(l: Vec3, r: Vec3): Vec3 {
  return { x: l.x - r.x, y: l.y - r.y, z: l.z - r.z };
}

function dot(l: Vec3, r: Vec3): number {
  return l.x * r.x + l.y * r.y + r.z * l.z;
}

function normalize(l: Vec3): Vec3 {
  let d = Math.sqrt(dot(l, l));
  return { x: l.x / d, y: l.y / d, z: l.z / d };
}

function cross(l: Vec3, r: Vec3): Vec3 {

  return { x: (l.y * r.z - l.z * r.y), y: (l.z * r.x - l.x * r.z), z: (l.x * r.y - l.y * r.x) };
}

function mul(l: Quaternion, d: number): Quaternion {
  return {
    x: l.x * d,
    y: l.y * d,
    z: l.z * d,
    w: l.w * d
  };
}

function lookAt(node: Node, eye: Vec3, center: Vec3, up: Vec3) {

  let t: number;

  let q: Quaternion = {
    x: 0.0,
    y: 0.0,
    z: 0.0,
    w: 0.0
  };
  let f = normalize(sub(center, eye));
  let m0 = normalize(cross(f, up));
  let m1 = cross(m0, f);
  let m2: Vec3 = { x: -f.x, y: -f.y, z: -f.z };
  if (m2.z < 0) {
    if (m0.x > m1.y) {
      t = 1.0 + m0.x - m1.y - m2.z;
      q = {
        x: t,
        y: m0.y + m1.x,
        z: m2.x + m0.z,
        w: m1.z - m2.y
      };
    } else {
      t = 1.0 - m0.x + m1.y - m2.z;
      q = {
        x: m0.y + m1.x,
        y: t,
        z: m1.z + m2.y,
        w: m2.x - m0.z
      };
    }
  } else {
    if (m0.x < -m1.y) {
      t = 1.0 - m0.x - m1.y + m2.z;
      q = {
        x: m2.x + m0.z,
        y: m1.z + m2.y,
        z: t,
        w: m0.y - m1.x
      };
    } else {
      t = 1.0 + m0.x + m1.y + m2.z;
      q = {
        x: m1.z - m2.y,
        y: m2.x - m0.z,
        z: m0.y - m1.x,
        w: t
      };
    }
  }
  node.position = eye;
  node.rotation = mul(q, 0.5 / Math.sqrt(t));
}

/** Get length */
function length(quat: Quaternion): number {
  return Math.sqrt(quat.x * quat.x + quat.y * quat.y + quat.z * quat.z + quat.w * quat.w);
}

function magnitudeVec3(vec: Vec3): number {
  return Math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
}

/** Return distance between vector2's */
function distanceVec3(v0: Vec3, v1: Vec3): number {
  let v: Vec3 = { x: v0.x - v1.x, y: v0.y - v1.y, z: v0.z - v1.z };
  return magnitudeVec3(v);
}

/** Creates a rotation which rotates angle degrees around axis, takes in angle as radians */
function angleAxis(angle: number, axis: Vec3): Quaternion {
  let sinHalfAngle: number = Math.sin(angle * 0.5);
  let axisMultiplied: Vec3 = { x: axis.x * sinHalfAngle, y: axis.y * sinHalfAngle, z: axis.z * sinHalfAngle };
  let ret: Quaternion = {
    x: axisMultiplied.x,
    y: axisMultiplied.y,
    z: axisMultiplied.z,
    w: Math.cos(angle * 0.5)
  };
  return ret;
}

/** Multiply vector3 by quaternion(rotation) */
function quatMultVec3(q: Quaternion, v: Vec3): Vec3 {
  let quatvector: Vec3 = { x: q.x, y: q.y, z: q.z };

  let uv: Vec3 = cross(quatvector, v);
  let uuv: Vec3 = (cross(quatvector, uv));
  let ret: Vec3 = {
    x: v.x + (uv.x * q.w + uuv.x) * 2,
    y: v.y + (uv.y * q.w + uuv.y) * 2, z: v.z + (uv.z * q.w + uuv.z) * 2
  };
  return ret;
}

function quatMultQuat(q0: Quaternion, q1: Quaternion): Quaternion {
  let ret: Quaternion = {
    x: q0.w * q1.x + q0.x * q1.w + q0.y * q1.z - q0.z * q1.y,
    y: q0.w * q1.y + q0.y * q1.w + q0.z * q1.x - q0.x * q1.z,
    z: q0.w * q1.z + q0.z * q1.w + q0.x * q1.y - q0.y * q1.x,
    w: q0.w * q1.w - q0.x * q1.x - q0.y * q1.y - q0.z * q1.z
  };
  return ret;
}

/** Normalizes quaternion */
function normalizeQuat(q: Quaternion): Quaternion {
  let len: number = length(q);
  if (len <= 0.0) {
    return {
      x: 0.0,
      y: 0.0,
      z: 0.0,
      w: 1.0
    };
  }
  let oneOverLen: number = 1.0 / len;
  return {
    x: q.x * oneOverLen,
    y: q.y * oneOverLen,
    z: q.z * oneOverLen,
    w: q.w * oneOverLen
  };
}

class OrbitCameraHelper {
  private orbitDistance_: number = 3.0;
  private cameraTargetPosition_: Vec3 = { x: 0, y: 0, z: 0 };
  private cameraRotation_: Quaternion = {
    x: 0,
    y: 0,
    z: 0,
    w: 1
  };
  private x_: number = 0;
  private y_: number = 0;
  private deltaX_: number = 0;
  private deltaY_: number = 0;
  private pinchDistance_: number | undefined = undefined;
  private state: number = -1; // 0 press, 1 pinch

  SetOrbitFromTarget(targetPosition: Vec3, rotation: Quaternion, orbitDistance: number): void {
    this.orbitDistance_ = orbitDistance;
    this.cameraRotation_ = rotation;
    this.cameraTargetPosition_ = targetPosition;
  }

  SetOrbitFromEyeWithDistance(eyePosition: Vec3, rotation: Quaternion, orbitDistance: number): void {
    this.orbitDistance_ = orbitDistance;
    this.cameraRotation_ = rotation;
    let toTargetVec = quatMultVec3(this.cameraRotation_, { x: 0.0, y: 0.0, z: -orbitDistance });
    this.cameraTargetPosition_ = {
      x: eyePosition.x + toTargetVec.x, y: eyePosition.y + toTargetVec.y,
      z: eyePosition.z + toTargetVec.z
    };
  }

  SetOrbitFromEye(eyePosition: Vec3, targetPosition: Vec3, rotation: Quaternion): void {
    this.orbitDistance_ = distanceVec3(eyePosition, targetPosition);
    this.cameraRotation_ = rotation;
    let toTargetVec = quatMultVec3(this.cameraRotation_, { x: 0.0, y: 0.0, z: -this.orbitDistance_ });
    this.cameraTargetPosition_ = {
      x: eyePosition.x + toTargetVec.x, y: eyePosition.y + toTargetVec.y,
      z: eyePosition.z + toTargetVec.z
    };
  }

  GetCameraPosition(): Vec3 {
    let ret = quatMultVec3(this.cameraRotation_, { x: 0.0, y: 0.0, z: this.orbitDistance_ });
    return {
      x: ret.x + this.cameraTargetPosition_.x, y: ret.y + this.cameraTargetPosition_.y,
      z: ret.z + this.cameraTargetPosition_.z
    };
  }

  GetCameraRotation(): Quaternion {
    return this.cameraRotation_;
  }

  OnPress(event: TouchEvent): void {
    if (event.touches.length == 1) {
      this.x_ = event.touches[0].x;
      this.y_ = event.touches[0].y;
      this.state = 0;
    }
  }

  OnRelease(event: TouchEvent): void {
    this.x_ = 0;
    this.y_ = 0;
    this.deltaX_ = 0;
    this.deltaY_ = 0;
    this.state = -1;
  }

  UpdateCameraRotation(dx: number, dy: number): void {
    let rotationX: Quaternion = angleAxis(dx, { x: 0.0, y: -1.0, z: 0.0 });
    let rotationY: Quaternion = angleAxis(dy, quatMultVec3(this.cameraRotation_,
      { x: -1.0, y: 0.0, z: 0.0 }));
    this.cameraRotation_ = normalizeQuat(quatMultQuat(quatMultQuat(rotationX, rotationY), this.cameraRotation_));
  }

  UpdateCameraTargetPosition(dx: number, dy: number): void {
    let dirX = quatMultVec3(this.cameraRotation_, { x: 1.0, y: 0.0, z: 0.0 });
    let dirY = quatMultVec3(this.cameraRotation_, { x: 0.0, y: -1.0, z: 0.0 });
    this.cameraTargetPosition_.x += dirX.x * dx + dirY.x * dy;
    this.cameraTargetPosition_.y += dirX.y * dx + dirY.y * dy;
    this.cameraTargetPosition_.z += dirX.z * dx + dirY.z * dy;
  }

  OnMove(event: TouchEvent): void {
    if (event.touches.length == 1 && this.state == 0) {
      let sensitivity: number = 0.01;
      this.deltaX_ = event.touches[0].x - this.x_;
      this.deltaY_ = event.touches[0].y - this.y_;
      this.x_ = event.touches[0].x;
      this.y_ = event.touches[0].y;
      this.UpdateCameraRotation(sensitivity * this.deltaX_, sensitivity * this.deltaY_);
    }
  }

  HandleTouchEvent(event: TouchEvent): void {
    if (event.type == TouchType.Down) {
      this.OnPress(event);
    }
    if (event.type == TouchType.Up || event.type == TouchType.Cancel) {
      this.OnRelease(event);
    }
    if (event.type == TouchType.Move) {
      this.OnMove(event);
    }
  }

  // pinch such a dizzy, better use touch event
  HandlePinchGestureActionUpdate(event: GestureEvent): void {
    if (!this.pinchDistance_) {
      this.pinchDistance_ = this.orbitDistance_;
    }
    let scale = event.scale;
    if (scale == 0) {
      scale = 0.01;
    }
    this.orbitDistance_ = this.pinchDistance_ * (1 / scale);
    this.state = 1;
  }

  HandlePinchGestureActionEnd(): void {
    this.pinchDistance_ = undefined;
    this.state = 1;
  }

  HandlePanGestureActionUpdate(event: GestureEvent, flag: number): void {
    let sensitivity: number = 0.01;
    this.deltaX_ = event.offsetX - this.x_;
    this.deltaY_ = event.offsetY - this.y_;
    if (flag == 0) {
      // rotation
      this.UpdateCameraRotation(sensitivity * this.deltaX_, sensitivity * this.deltaY_);
    } else if (flag == 1) {
      // translation
      this.UpdateCameraTargetPosition(-sensitivity * this.deltaX_, -sensitivity * this.deltaY_);
    }
    this.x_ = event.offsetX;
    this.y_ = event.offsetY;
  }

  HandlePanGestureActionEnd(): void {
    this.deltaX_ = 0;
    this.deltaY_ = 0;
    this.x_ = 0;
    this.y_ = 0;
  }
}

export { lookAt, OrbitCameraHelper };