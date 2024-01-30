/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import xml from '@ohos.convertxml';
import convertxml from '@ohos.convertxml';
import util from '@ohos.util';
/**
 * 画svg到离线画板
 * @param context
 * @param offContext
 * @param resource svg资源，例如$r('app.media.svg_test')
 * @param width 绘制大小
 * @param height
 * @param dx 绘制左上角偏移x
 * @param dy
 */
export async function drawSvg(context: Context, offContext: OffscreenCanvasRenderingContext2D
                              , resource: Resource, width: number, height: number, dx: number = 0, dy: number = 0) {
  const unit8Array: Uint8Array = await context.resourceManager.getMediaContent(resource);
  let textDecoder: util.TextDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
  const text: string = textDecoder.decodeWithStream(unit8Array);
  // 获取描述对象
  const svgClass = transformToSvgObj(text);
  if (svgClass === null) {
    return
  }
  // 这里加了一个1.5的倍数校正。。这个1.5是实验出来的，至于为什么需要这个倍数。。我还未找到原因
  const scaleW: number = width / svgClass.width * 1.5
  const scaleH: number = height / svgClass.height * 1.5
  // 设置偏移量，一定要先设置偏移量，否则偏移量也会被缩放
  offContext.translate(dx, dy);
  // 设置缩放比
  offContext.scale(scaleW, scaleH);
  svgClass.paths.forEach(svaPath => {
    const path = new Path2D(svaPath.path);
    offContext.fillStyle = svaPath.fillColor;
    offContext.fill(path);
  })
}

export function transformToSvgObj(text: string): SvgClass {
  let conv: convertxml.ConvertXML = new convertxml.ConvertXML();
  let options: xml.ConvertOptions = {
    trim: false,
    declarationKey: '_declaration',
    instructionKey: '_instruction',
    attributesKey: '_attributes',
    textKey: '_text',
    cdataKey: '_cdata',
    doctypeKey: '_doctype',
    commentKey: '_comment',
    parentKey: '_parent',
    typeKey: '_type',
    nameKey: '_name',
    elementsKey: '_elements'
  };
  const obj: Object = conv.convertToJSObject(text, options);
  const e: Elements[] = getAllElements(obj as ObjectType);
  const svgClass: SvgClass = new SvgClass();
  for (let i: number = 0; i < e.length; i++) {
    const element: Elements = e[i];
    if (element.name === 'svg') {
      svgClass.width = Number(element._attributes.width);
      svgClass.height = Number(element._attributes.height);
    } else if (element.name === 'path') {
      const path: SvgPath = new SvgPath();
      path.path = element._attributes.d;
      path.fillColor = element._attributes.fill;
      svgClass.paths.push(path);
    }
  }
  return svgClass;
}

function getAllElements(obj: ObjectType): Elements[] {
  const set: Elements[] = [];
  if (obj instanceof Array) {
    const arr: Array<ObjectType> = obj as Array<ObjectType>;
    const length: number = arr.length;
    for (let i: number = 0; i < length; i++) {
      set.push(...getAllElements(arr[i]));
    }
  }
  if (obj._attributes !== undefined && obj?._type !== undefined
  && obj._type === 'element' && obj._name !== undefined) {
    const e: Elements = new Elements();
    e.name = obj._name;
    e._attributes = obj._attributes;
    set.push(e);
  }
  if (obj._elements !== undefined) {
    set.push(...getAllElements(obj._elements));
  }
  return set;
}

class ObjectType {
  _attributes?: AttributesType
  _type?: string
  _name?: string
  _elements?: ObjectType
}


class Elements {
  name: string = '';
  _attributes: AttributesType = new AttributesType();
}

class AttributesType {
  width: number = 0
  height: number = 0
  d: string = ''
  fill: string = ''
}


export class SvgClass {
  width: number = 0;
  height: number = 0;
  paths: SvgPath[] = [];
}

export class SvgPath {
  path: string = '';
  fillColor: string = '';
}