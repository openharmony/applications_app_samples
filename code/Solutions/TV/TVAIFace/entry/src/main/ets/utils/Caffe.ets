/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { FaceObject, finalboxModel } from '../Types/ParamsType';
interface Delta {
  x: number,
  y: number
}

export class CRect2f {
  public val: number[] = []

  constructor(x1: number, y1: number, x2: number, y2: number) {
    this.val[0] = x1;
    this.val[1] = y1;
    this.val[2] = x2;
    this.val[3] = y2;
  }

  operator(i: number) {
    return this.val[i];
  }

  print() {
    return `rect ${this.val.join(',')} \n`;
  }
}
;

export function _ratio_enum(anchor: number[], ratios: number[]) {
  let w = anchor[2] - anchor[0] + 1;
  let h = anchor[3] - anchor[1] + 1;
  let x_ctr = anchor[0] + 0.5 * (w - 1);
  let y_ctr = anchor[1] + 0.5 * (h - 1);

  let sz = w * h;

  let res: number[][] = [];
  for (let s = 0; s < ratios.length; s++) {
    let r = ratios[s];
    let size_ratios = sz / r;
    let ws = Math.sqrt(size_ratios);
    let hs = ws * r;
    let ratio_anchor =
      new CRect2f(x_ctr - 0.5 * (ws - 1), y_ctr - 0.5 * (hs - 1), x_ctr + 0.5 * (ws - 1), y_ctr + 0.5 * (hs - 1));
    res.push(ratio_anchor.val);
  }
  return res;
}

export function _scale_enum(ratio_anchor: number[][], scales: number[]) {
  let res: number[][] = [];
  for (let a = 0; a < ratio_anchor.length; a++) {
    let anchor = ratio_anchor[a];

    let w = anchor[2] - anchor[0] + 1;
    let h = anchor[3] - anchor[1] + 1;
    let x_ctr = anchor[0] + 0.5 * (w - 1);
    let y_ctr = anchor[1] + 0.5 * (h - 1);


    for (let s = 0; s < scales.length; s++) {
      let ws = w * scales[s];
      let hs = h * scales[s];

      let scale_anchor =
        new CRect2f(x_ctr - 0.5 * (ws - 1), y_ctr - 0.5 * (hs - 1), x_ctr + 0.5 * (ws - 1), y_ctr + 0.5 * (hs - 1));
      res.push(scale_anchor.val);
    }
  }
  return res;
}

export function landmark_pred(anchor: number[], delta: Delta[], ratiow = 1, ratioh = 1) {
  let w = anchor[2] - anchor[0] + 1;
  let h = anchor[3] - anchor[1] + 1;
  let x_ctr = anchor[0] + 0.5 * (w - 1);
  let y_ctr = anchor[1] + 0.5 * (h - 1);
  let pts_delta: Delta[] = [];
  for (let i = 0; i < delta.length; i++) {
    pts_delta[i] = {
      x: (delta[i].x * w + x_ctr) * ratiow,
      y: (delta[i].y * h + y_ctr) * ratioh
    };
  }
  return pts_delta;
}

//得到最后的box
export function bbox_pred(anchor: number[], delta: number[], ratiow = 1, ratioh = 1): finalboxModel {
  let w = anchor[2] - anchor[0] + 1;
  let h = anchor[3] - anchor[1] + 1;
  let x_ctr = anchor[0] + 0.5 * (w - 1);
  let y_ctr = anchor[1] + 0.5 * (h - 1);

  let dx = delta[0];
  let dy = delta[1];
  let dw = delta[2];
  let dh = delta[3];

  let pred_ctr_x = dx * w + x_ctr;
  let pred_ctr_y = dy * h + y_ctr;
  let pred_w = Math.exp(dw) * w;
  let pred_h = Math.exp(dh) * h;

  return {
    x: (pred_ctr_x - 0.5 * (pred_w - 1.0)) * ratiow,
    y: (pred_ctr_y - 0.5 * (pred_h - 1.0)) * ratioh,
    w: (pred_ctr_x + 0.5 * (pred_w - 1.0)) * ratiow,
    h: (pred_ctr_y + 0.5 * (pred_h - 1.0)) * ratioh,
    width: 0,
    height: 0,
    size: 0
  };
}

export function nms_cpu(boxes: FaceObject[], threshold: number) {
  let filterOutBoxes: FaceObject[] = [];
  let boxes_len = boxes.length;
  if (boxes_len == 0) {
    return filterOutBoxes;
  }

  let idx: number[] = [];
  for (let i = 0; i < boxes_len; i++) {
    idx.push(i);
  }
  boxes.sort((a:FaceObject,b: FaceObject) =>{
    if (a.score !== undefined && b.score !== undefined) {
      return a.score - b!.score
    }
    return 0
  })

  while (idx.length > 0) {
    let good_idx = idx[0];
    filterOutBoxes.push(boxes[good_idx]);
    let tmp = [...idx];
    idx = [];

    for (let i = 1; i < tmp.length; i++) {
      let tmp_i = tmp[i];

      let inter_x1 = Math.max(boxes[good_idx].finalbox.x, boxes[tmp_i].finalbox.x);
      let inter_y1 = Math.max(boxes[good_idx].finalbox.y, boxes[tmp_i].finalbox.y);
      let inter_x2 = Math.min(boxes[good_idx].finalbox.w, boxes[tmp_i].finalbox.w);
      let inter_y2 = Math.min(boxes[good_idx].finalbox.h, boxes[tmp_i].finalbox.h);

      let w = Math.max((inter_x2 - inter_x1 + 1), 0.0);
      let h = Math.max((inter_y2 - inter_y1 + 1), 0.0);
      let inter_area = w * h;
      let area_1 = (boxes[good_idx].finalbox.w - boxes[good_idx].finalbox.x + 1) *
        (boxes[good_idx].finalbox.h - boxes[good_idx].finalbox.y + 1);
      let area_2 = (boxes[tmp_i].finalbox.w - boxes[tmp_i].finalbox.x + 1) *
        (boxes[tmp_i].finalbox.h - boxes[tmp_i].finalbox.y + 1);

      let o = inter_area / (area_1 + area_2 - inter_area);

      if (o <= threshold) {
        idx.push(tmp_i);
      }

    }
  }
  return filterOutBoxes;
}

