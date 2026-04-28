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

const shadowRootElementInstance = document.createElement('ohtv-browser-shadow-root');
document.body.appendChild(shadowRootElementInstance);

// 定义自定义元素
class ShadowRootElement extends HTMLElement {
    constructor() {
        super();
        // 创建一个 Shadow DOM 根节点
        this._shadowRoot = this.attachShadow({ mode: 'closed' });
        this.createStyle();
    }

    // 提供一个方法来获取缓存的 shadowRoot
    get cachedShadowRoot() {
        return this._shadowRoot;
    }


    createStyle() {
        // 创建一个新的 style 元素
        const style = document.createElement('style');
        // 定义 @keyframes 动画规则
        const keyframes = `
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 2px rgba(0,0,0,1);
            }
            70% {
                box-shadow: 0 0 0 5px rgba(246, 246, 246, 0.6);
             }
            100% {
                box-shadow: 0 0 0 2px rgba(0,0,0,1);
             }
          }
          `;

        // 将 @keyframes 规则添加到 style 元素的文本内容中
        style.textContent = keyframes;
        // 将 style 元素添加到 head 中
        this._shadowRoot.appendChild(style);
    }

}

// 注册自定义元素
customElements.define('ohtv-browser-shadow-root', ShadowRootElement);


function getDirectionEdgePoints(currentRect, targetRect, direction) {
    let curPointX;
    let curPointY;
    let targetPointX;
    let targetPointY;
    switch (direction) {
        case 'right':
            curPointX = currentRect.right;
            curPointY = currentRect.top;
            targetPointX = targetRect.left;
            targetPointY = targetRect.top;
            break;
        case 'down':
            curPointX = currentRect.left;
            curPointY = currentRect.bottom;
            targetPointX = targetRect.left;
            targetPointY = targetRect.top;
            break;
        case 'left':
            curPointX = currentRect.left;
            curPointY = currentRect.top;
            targetPointX = targetRect.right;
            targetPointY = targetRect.top;
            break;
        case 'up':
            curPointX = currentRect.left;
            curPointY = currentRect.top;
            targetPointX = targetRect.left;
            targetPointY = targetRect.bottom;
            break;
        default:
            break;
    }
    return { curPointX, curPointY, targetPointX, targetPointY };
}

function computeDirectionWeight(currentRect, target, direction) {
    const targetRect = target.el.getBoundingClientRect();
    const vector = { right: [1, 0], left: [-1, 0], down: [0, 1], up: [0, -1] }[direction];
    const { curPointX, curPointY, targetPointX, targetPointY } =
        getDirectionEdgePoints(currentRect, targetRect, direction);
    const targetVectorX = targetPointX - curPointX;
    const targetVectorY = targetPointY - curPointY;
    const dirVectorX = vector[0];
    const dirVectorY = vector[1];
    const dotProduct = targetVectorX * dirVectorX + targetVectorY * dirVectorY;
    const targetMagnitude = Math.sqrt(targetVectorX ** 2 + targetVectorY ** 2);
    const dirMagnitude = Math.sqrt(dirVectorX ** 2 + dirVectorY ** 2);
    let cosAngle = dotProduct / (targetMagnitude * dirMagnitude);
    if (targetMagnitude === 0) {
        cosAngle = 1;
    } else if (isNaN(cosAngle) || cosAngle <= 0) {
        return -1;
    }
    const angleWeight = cosAngle;
    const distanceDecayFactor = 0.1;
    const distanceWeight = 1 / (1 + distanceDecayFactor * targetMagnitude);
    return distanceWeight * angleWeight;
}

class FocusNavigator {
    constructor() {
        this.elements = [];
        this.currentIndex = -1;
        this.focusMode = false;
        this.hintMode = false;
        this.hintChars = 'ABCDEFGHIJKL';
        this.currentElement = null;
        this.rTree = new rbush();
    }

    buildIndex() {
        const entries = this.elements.map(el => {
            const rect = el.getBoundingClientRect();
            return {
                el,
                minX: rect.left,
                minY: rect.top,
                maxX: rect.right,
                maxY: rect.bottom,
                cx: (rect.left + rect.right) / 2, // 中心坐标
                cy: (rect.top + rect.bottom) / 2
            };
        });
        this.rTree.clear();
        this.rTree.load(entries);
    }

    // 初始化可交互元素集合
    initElements() {
        this.elements = Array.from(document.querySelectorAll(
            'a[href],img,svg,div[style*=background],span[style*=background],[data-src],video,audio,a,[role=link],input,textarea,dialog,label,select,code,pre'
        )).filter(el => this.isVisible(el));
        this.buildIndex();
    }

    // 可见性检测（升级版）
    isVisible(el) {
        const style = window.getComputedStyle(el);
        return el.offsetWidth > 0 &&
            el.offsetHeight > 0 &&
            style.visibility !== 'hidden' &&
            style.display !== 'none' &&
            style.opacity !== '0';
    }

    // 进入标签模式
    enterHintMode() {
        this.elements.forEach((el, index) => {
            const hint = this.hintChars[index % this.hintChars.length];
            this.createHintMarker(el, hint);
        });
    }

    // 退出标签模式
    exitHintMode() {
        this.deleteHintMarker();
    }

    // 创建标签标记
    createHintMarker(el, hint) {
        const marker = document.createElement('div');
        marker.className = 'hint';
        marker.textContent = hint;
        marker.style = `position: absolute;
    top: ${el.getBoundingClientRect().top + window.scrollY}px;
    left: ${el.getBoundingClientRect().left + window.scrollX}px;
    background: #FF5722; color: white; padding: 2px 5px; z-index: 999999;`;
        el.dataset.hintKey = hint;
        shadowRootElementInstance.cachedShadowRoot.appendChild(marker);
    }

    deleteHintMarker() {
        shadowRootElementInstance.cachedShadowRoot.querySelectorAll('.hint').forEach(el => el.remove());
    }

    removeHighlightElement() {
        // 移除旧高亮
        shadowRootElementInstance.cachedShadowRoot.querySelectorAll('.focus-highlight').forEach(el => el.remove());
    }

    highlightElement(el) {
        // 移除旧高亮
        this.removeHighlightElement();

        const elRect = el.getBoundingClientRect();

        // 创建动态光晕效果
        const highlight = document.createElement('div');
        highlight.className = 'focus-highlight';
        highlight.style.cssText = `
        position: absolute;
        top: ${elRect.top + window.scrollY}px;
        left: ${elRect.left + window.scrollX}px;
        width: ${elRect.width}px;
        height: ${elRect.height}px;
        box-shadow: 0 0 0 2px #000000;
        transition: all 0.2s;
        pointer-events: none;
        z-index: 999999;
        border-radius: 2px;
        animation: pulse 1s infinite;
      `;
        shadowRootElementInstance.cachedShadowRoot.appendChild(highlight);

        // 智能滚动
        this.smartScroll(el);
    }


    // 滚动优化
    smartScroll(target) {
        const rect = target.getBoundingClientRect();
        const buffer = 200; // 滚动缓冲区域

        if (rect.bottom > window.innerHeight) {
            window.scrollBy(0, rect.bottom - window.innerHeight + buffer);
        } else if (rect.top < 200) {
            window.scrollBy(0, rect.top - buffer);
        }
    }

    // 搜索区域提示显示
    showSearchAreaBox(searchArea) {
        const areaElm = document.createElement('div');
        areaElm.className = 'search-area';
        areaElm.style = `
      position: absolute;
      top: ${searchArea.minY}px;
      left: ${searchArea.minX}px;
      width: ${searchArea.maxX - searchArea.minX}px;
      height: ${searchArea.maxY - searchArea.minY}px;
      background: #ff663366;
      color: white;
      padding: 2px 5px;
      z-index: 999999;`;
        shadowRootElementInstance.cachedShadowRoot.appendChild(areaElm);
        setTimeout(() => {
            areaElm.remove();
        }, 1000);
    }

    // 通过按键方向查找元素
    findNextElement(currentEl, direction) {
        const currentRect = currentEl.getBoundingClientRect();
        const searchArea = this.getDirectionalSearchArea(currentRect, direction);

        const candidates = this.rTree.search(searchArea)
            .map(entry => ({
                el: entry.el,
                score: this.calculateDirectionScore(currentRect, entry, direction)
            }))
            .filter(item => item.score > 0 && item.el !== currentEl)
            .sort((a, b) => b.score - a.score);
        return candidates[0]?.el;
    }

    // 计算权重得分
    calculateDirectionScore(currentRect, target, direction) {
        return computeDirectionWeight(currentRect, target, direction);
    }

    // 获取搜索区域
    getDirectionalSearchArea(currentRect, direction) {
        const padding = 400; // 搜索扩展区域
        const offset = 20; // 反向扩展区域
        return {
            right: {
                minX: currentRect.right + 1,
                minY: currentRect.top - offset,
                maxX: window.innerWidth,
                maxY: currentRect.bottom + window.scrollY + padding
            },
            left: {
                minX: 0,
                minY: currentRect.top - offset,
                maxX: currentRect.left - 1,
                maxY: currentRect.bottom + window.scrollY + padding
            },
            down: {
                minX: currentRect.left - offset,
                minY: currentRect.bottom + 1,
                maxX: currentRect.right + padding,
                maxY: currentRect.bottom + window.scrollY + window.innerHeight
            },
            up: {
                minX: currentRect.left - offset,
                minY: 0,
                maxX: currentRect.right + padding,
                maxY: currentRect.top + window.scrollY - 1
            }
        }[direction];
    }
}

const focusNavigator = new FocusNavigator();

const observer = new MutationObserver(() => {
    focusNavigator.initElements();
});

observer.observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['style', 'class']
});

document.addEventListener('keydown', (e) => {
    if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
        const direction = e.key.replace('Arrow', '').toLowerCase();
        const nextElement = focusNavigator.findNextElement(focusNavigator.currentElement, direction);
        if (nextElement) {
            focusNavigator.currentElement = nextElement;
            focusNavigator.highlightElement(focusNavigator.currentElement);
        } else if (!nextElement && direction === 'up') {
            if (window.etsObj) {
                window.etsObj.cancelFocusEvent();
            }
        }
        e.preventDefault();
    }

    if (e.key === 'Enter' && focusNavigator.currentElement) {
        focusNavigator.currentElement.click();
    }

    if (e.key === 'Backspace') {
        if (window.etsObj) {
            if (!focusNavigator.focusMode) {
                window.etsObj.openFocusEvent();
            } else {
                window.etsObj.cancelFocusEvent();
            }
        } else {
            if (!focusNavigator.focusMode) {
                openWebFocus();
            } else {
                closeWebFocus();
            }
        }
    }

});


// 开启web聚焦
function openWebFocus() {
    if (focusNavigator.elements.length > 0) {
        if (focusNavigator.currentElement === null) {
            focusNavigator.currentElement = focusNavigator.elements[0];
        }
        focusNavigator.highlightElement(focusNavigator.currentElement);
        focusNavigator.focusMode = true;
    }
}
// 取消web聚焦
function closeWebFocus() {
    focusNavigator.removeHighlightElement();
    focusNavigator.focusMode = false;
}
