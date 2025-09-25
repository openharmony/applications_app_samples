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

#include <cstring>
#include <memory>
#include <string>
#include <vector>
#include <unordered_map>
#include <utility>

#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <hilog/log.h>
#include <napi/native_api.h>

#include "ScrollUtils.h"

#ifndef LOG_TAG
#define LOG_TAG "ListMaker"
#endif

#include "ArkUINode.h"
#include "ArkUINodeAdapter.h"
#include "ListMaker.h"
#include "ListItemGroup.h"
#include "ListItemSwipe.h"

// ===== 常量定义 =====
namespace {
constexpr int K_ALPHABET_COUNT = 26;
constexpr int K_INDEX_ITEM_HEIGHT = 22;
constexpr int32_t K_GROUP_FIRST_ITEM_INDEX = 0;
constexpr int32_t K_FIRST_GROUP_INDEX = 0;

constexpr float K_LIST_WIDTH_PERCENT = 0.82f;
constexpr float K_FULL_PERCENT = 1.0f;
constexpr float K_LIST_SPACE = 8.0f;

constexpr float K_ITEM_FONT_SIZE = 16.0f;
constexpr float K_INDEX_FONT_SIZE = 14.0f;
constexpr float K_ROW_HEIGHT = 80.0f;

constexpr float K_DELETE_HEIGHT = 64.0f;
constexpr float K_DELETE_WIDTH = 88.0f;
constexpr float K_SWIPE_ACTION_DISTANCE = 96.0f;

constexpr float K_INDEX_BAR_WIDTH = 56.0f;
constexpr float K_INDEX_BAR_PAD_TOP = 0.0f;
constexpr float K_INDEX_BAR_PAD_RIGHT = 0.0f;
constexpr float K_INDEX_BAR_PAD_BOTTOM = 0.0f;
constexpr float K_INDEX_BAR_PAD_LEFT = 8.0f;

constexpr float K_HEADER_HEIGHT = 40.0f;
constexpr float K_FOOTER_HEIGHT = 28.0f;

constexpr uint32_t K_COLOR_WHITE = 0xFFFFFFFFU;
constexpr uint32_t K_COLOR_BLACK = 0xFF000000U;
constexpr uint32_t K_COLOR_DELETE_BG = 0xFFE53935U;
constexpr uint32_t K_COLOR_INDEX_ACTIVE = 0xFF003366U;
constexpr uint32_t K_COLOR_INDEX_INACTIVE = 0xFF222222U;
constexpr uint32_t K_COLOR_INDEX_ACTIVE_BG = 0xFFE0F0FFU;
constexpr uint32_t K_COLOR_INDEX_INACTIVE_BG = 0x00000000U;

constexpr uint32_t K_COLOR_HEADER_BG = 0xFFEFEFEFU;
constexpr uint32_t K_COLOR_FOOTER_BG = 0xFFF7F7F7U;

constexpr int K_EDGE_EFFECT_NONE = 0;

constexpr const char *K_DELETE_TEXT = "Delete";
constexpr const char *K_FOOTER_TEXT = "—— 已到底 ——";
constexpr const char *K_INVALID_TEXT = "<invalid>";

constexpr unsigned int K_LOG_DOMAIN = 0xFF00;
} // namespace

// ===== 数据源 =====
static const char *const NAMES_A[] = {"Alice", "Andrew", "Amy", "Aaron", "安娜", "安琪", "爱华", "阿明"};
static const char *const NAMES_B[] = {"Ben", "Bella", "Brian", "Brandon", "博文", "斌", "白雪", "彬彬"};
static const char *const NAMES_C[] = {"Chris", "Charlotte", "Cindy", "Caleb", "晨曦", "承泽", "楚怡", "春燕"};
static const char *const NAMES_D[] = {"Daniel", "David", "Diana", "Dylan", "大伟", "东旭", "德华", "丹妮"};
static const char *const NAMES_E[] = {"Emma", "Ethan", "Emily", "Eric", "恩泽", "恩雅", "尔雅", "恩宁"};
static const char *const NAMES_F[] = {"Frank", "Fiona", "Felix", "Fred", "方圆", "芙蓉", "芳怡", "飞扬"};
static const char *const NAMES_G[] = {"Grace", "George", "Gavin", "Gloria", "国强", "国华", "光耀", "桂英"};
static const char *const NAMES_H[] = {"Henry", "Hannah", "Helen", "Harry", "海峰", "红梅", "宏伟", "浩然"};
static const char *const NAMES_I[] = {"Isaac", "Ice", "Ian", "Isabella", "一涵", "一诺", "怡君", "依琳"};
static const char *const NAMES_J[] = {"Jack", "James", "Jason", "Julia", "佳怡", "建国", "靖雯", "俊杰"};
static const char *const NAMES_K[] = {"Kevin", "Kate", "Kelly", "Kyle", "可欣", "可可", "昆明", "康宁"};
static const char *const NAMES_L[] = {"Lucas", "Leo", "Lily", "Lauren", "丽丽", "丽华", "立国", "林涛"};
static const char *const NAMES_M[] = {"Michael", "Mary", "Mark", "Molly", "美玲", "明慧", "明杰", "梦瑶"};
static const char *const NAMES_N[] = {"Nancy", "Nathan", "Nick", "Nora", "楠楠", "宁静", "娜娜", "乃文"};
static const char *const NAMES_O[] = {"Oliver", "Olivia", "Owen", "Oscar", "欧阳娜", "欧莉", "欧阳晨", "欧文"};
static const char *const NAMES_P[] = {"Peter", "Paul", "Philip", "Penny", "佩琪", "佩华", "平安", "鹏飞"};
static const char *const NAMES_Q[] = {"Quentin", "Queenie", "Quinn", "Quincy", "琪琳", "倩倩", "清华", "强辉"};
static const char *const NAMES_R[] = {"Robert", "Rachel", "Ryan", "Ruby", "荣辉", "若曦", "瑞雪", "日新"};
static const char *const NAMES_S[] = {"Steven", "Susan", "Sarah", "Simon", "思远", "素芳", "诗涵", "少华"};
static const char *const NAMES_T[] = {"Thomas", "Tony", "Tina", "Taylor", "天宇", "婷怡", "涛涛", "同辉"};
static const char *const NAMES_U[] = {"Ulysses", "Uma", "Ulrich", "Ursula", "宇航", "宇轩", "宇宁", "宇泽"};
static const char *const NAMES_V[] = {"Victor", "Victoria", "Vincent", "Vivian", "薇薇", "维娜", "维德", "维琪"};
static const char *const NAMES_W[] = {"William", "Wendy", "Walter", "Willow", "伟强", "文静", "文博", "卫东"};
static const char *const NAMES_X[] = {"Xavier", "Xander", "Xenia", "Xiomara", "晓明", "欣怡", "旭东", "霞"};
static const char *const NAMES_Y[] = {"Yvonne", "Yolanda", "Yara", "Yvette", "怡然", "颖颖", "逸飞", "毅然"};
static const char *const NAMES_Z[] = {"Zoe", "Zachary", "Zane", "Zara", "紫琪", "志强", "梓涵", "泽宇"};

struct GroupNames {
    char letter;
    const char *const *arr;
    int size;
};

static const GroupNames GROUPS[] = {{'A', NAMES_A, Utils::ArrSize(NAMES_A)}, {'B', NAMES_B, Utils::ArrSize(NAMES_B)},
                                    {'C', NAMES_C, Utils::ArrSize(NAMES_C)}, {'D', NAMES_D, Utils::ArrSize(NAMES_D)},
                                    {'E', NAMES_E, Utils::ArrSize(NAMES_E)}, {'F', NAMES_F, Utils::ArrSize(NAMES_F)},
                                    {'G', NAMES_G, Utils::ArrSize(NAMES_G)}, {'H', NAMES_H, Utils::ArrSize(NAMES_H)},
                                    {'I', NAMES_I, Utils::ArrSize(NAMES_I)}, {'J', NAMES_J, Utils::ArrSize(NAMES_J)},
                                    {'K', NAMES_K, Utils::ArrSize(NAMES_K)}, {'L', NAMES_L, Utils::ArrSize(NAMES_L)},
                                    {'M', NAMES_M, Utils::ArrSize(NAMES_M)}, {'N', NAMES_N, Utils::ArrSize(NAMES_N)},
                                    {'O', NAMES_O, Utils::ArrSize(NAMES_O)}, {'P', NAMES_P, Utils::ArrSize(NAMES_P)},
                                    {'Q', NAMES_Q, Utils::ArrSize(NAMES_Q)}, {'R', NAMES_R, Utils::ArrSize(NAMES_R)},
                                    {'S', NAMES_S, Utils::ArrSize(NAMES_S)}, {'T', NAMES_T, Utils::ArrSize(NAMES_T)},
                                    {'U', NAMES_U, Utils::ArrSize(NAMES_U)}, {'V', NAMES_V, Utils::ArrSize(NAMES_V)},
                                    {'W', NAMES_W, Utils::ArrSize(NAMES_W)}, {'X', NAMES_X, Utils::ArrSize(NAMES_X)},
                                    {'Y', NAMES_Y, Utils::ArrSize(NAMES_Y)}, {'Z', NAMES_Z, Utils::ArrSize(NAMES_Z)}};

// ===== 交互上下文 =====
struct ClickCtx {
    ArkUI_NativeNodeAPI_1 *api{nullptr};
    std::shared_ptr<std::vector<std::string>> items;
    std::weak_ptr<ArkUINodeAdapter> adapter;
    int index{-1};
    uint64_t stableId{0};
    ArkUI_NodeHandle itemHandle{nullptr};
};

static std::unordered_map<ArkUI_NodeHandle, std::shared_ptr<ClickCtx>> s_btnCtx;
static std::unordered_map<ArkUI_NodeHandle, ArkUI_NodeHandle> s_itemToDeleteBtn;

// ===== 工具函数 =====
static int FindIndexByStableId(const std::vector<std::string> &items, uint64_t sid)
{
    const int n = static_cast<int>(items.size());
    for (int i = 0; i < n; ++i) {
        uint64_t v = static_cast<uint64_t>(std::hash<std::string>{}(items[static_cast<size_t>(i)]));
        if (v == sid) {
            return i;
        }
    }
    return -1;
}

static int ClampFallbackIndex(int fallback, int n)
{
    if (n <= 0) {
        return -1;
    }
    int idx = fallback;
    if (idx < 0) {
        idx = 0;
    }
    if (idx >= n) {
        idx = n - 1;
    }
    return idx;
}

// ===== 静态事件处理 =====
static void StaticDeleteBtnEvent(ArkUI_NodeEvent *ev)
{
    if (ev == nullptr) {
        return;
    }
    if (OH_ArkUI_NodeEvent_GetEventType(ev) != NODE_ON_CLICK) {
        return;
    }

    ClickCtx *ctx = reinterpret_cast<ClickCtx *>(OH_ArkUI_NodeEvent_GetUserData(ev));
    if (ctx == nullptr || ctx->api == nullptr) {
        return;
    }
    std::shared_ptr<std::vector<std::string>> items = ctx->items;
    if (!items) {
        OH_LOG_Print(LOG_APP, LOG_WARN, K_LOG_DOMAIN, LOG_TAG, "Delete skip: items is null");
        return;
    }

    int idx = FindIndexByStableId(*items, ctx->stableId);
    if (idx < 0) {
        idx = ClampFallbackIndex(ctx->index, static_cast<int>(items->size()));
        if (idx < 0) {
            OH_LOG_Print(LOG_APP, LOG_WARN, K_LOG_DOMAIN, LOG_TAG, "Delete skip: no valid index");
            return;
        }
    }

    const int n = static_cast<int>(items->size());
    if (idx < 0 || idx >= n) {
        OH_LOG_Print(LOG_APP, LOG_WARN, K_LOG_DOMAIN, LOG_TAG, "Delete skip: invalid idx=%d, size=%d", idx, n);
        return;
    }

    std::string deletedItem = (*items)[static_cast<size_t>(idx)];
    items->erase(items->begin() + idx);

    if (auto ad = ctx->adapter.lock()) {
        ad->RemoveRange(idx, 1);
        OH_LOG_Print(LOG_APP, LOG_INFO, K_LOG_DOMAIN, LOG_TAG, "Deleted item [%s] at index=%d, remaining=%d",
                     deletedItem.c_str(), idx, static_cast<int>(items->size()));
    } else {
        OH_LOG_Print(LOG_APP, LOG_WARN, K_LOG_DOMAIN, LOG_TAG, "Delete success but adapter is null");
    }
}

// ===== 视图构造工具 =====
static std::shared_ptr<BaseNode> MakeText(const char *s, float h, uint32_t bg)
{
    ArkUI_NativeNodeAPI_1 *api = NodeApiInstance::GetInstance()->GetNativeNodeAPI();
    ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
    std::shared_ptr<BaseNode> node = std::make_shared<BaseNode>(text);

    Utils::SetTextContent(api, text, s);
    Utils::SetAttributeFloat32(api, text, NODE_FONT_SIZE, K_ITEM_FONT_SIZE);
    Utils::SetAttributeFloat32(api, text, NODE_WIDTH_PERCENT, K_FULL_PERCENT);
    Utils::SetAttributeFloat32(api, text, NODE_HEIGHT, h);
    Utils::SetAttributeFloat32(api, text, NODE_TEXT_LINE_HEIGHT, h);
    Utils::SetAttributeInt32(api, text, NODE_TEXT_ALIGN, ARKUI_TEXT_ALIGNMENT_CENTER);
    Utils::SetAttributeUInt32(api, text, NODE_BACKGROUND_COLOR, bg);
    return node;
}

static void SetIndexTextStyle(ArkUI_NodeHandle text, int h, bool active)
{
    ArkUI_NativeNodeAPI_1 *api = NodeApiInstance::GetInstance()->GetNativeNodeAPI();
    Utils::SetAttributeFloat32(api, text, NODE_FONT_SIZE, K_INDEX_FONT_SIZE);
    Utils::SetAttributeFloat32(api, text, NODE_WIDTH_PERCENT, K_FULL_PERCENT);
    Utils::SetAttributeFloat32(api, text, NODE_HEIGHT, static_cast<float>(h));
    Utils::SetAttributeFloat32(api, text, NODE_TEXT_LINE_HEIGHT, static_cast<float>(h));
    Utils::SetAttributeInt32(api, text, NODE_TEXT_ALIGN, ARKUI_TEXT_ALIGNMENT_CENTER);
    Utils::SetAttributeUInt32(api, text, NODE_FONT_COLOR, active ? K_COLOR_INDEX_ACTIVE : K_COLOR_INDEX_INACTIVE);
    Utils::SetAttributeUInt32(api, text, NODE_BACKGROUND_COLOR,
                              active ? K_COLOR_INDEX_ACTIVE_BG : K_COLOR_INDEX_INACTIVE_BG);
}

struct IndexState {
    std::vector<std::shared_ptr<BaseNode>> letters;
    int selected;
    std::vector<bool> groupVisible;
    IndexState() : selected(-1) {}
};

static void UpdateIndexHighlight(const std::shared_ptr<IndexState> &st, int idx)
{
    if (!st) {
        return;
    }
    if (st->selected == idx) {
        return;
    }

    int prev = st->selected;
    if (prev >= 0 && prev < static_cast<int>(st->letters.size())) {
        ArkUI_NodeHandle prevHandle = st->letters[static_cast<size_t>(prev)]->GetHandle();
        SetIndexTextStyle(prevHandle, K_INDEX_ITEM_HEIGHT, false);
    }
    if (idx >= 0 && idx < static_cast<int>(st->letters.size())) {
        ArkUI_NodeHandle nowHandle = st->letters[static_cast<size_t>(idx)]->GetHandle();
        SetIndexTextStyle(nowHandle, K_INDEX_ITEM_HEIGHT, true);
        st->selected = idx;
    }
}

static std::shared_ptr<BaseNode> BuildRightIndexColumn(const std::shared_ptr<ListMaker> &list,
                                                       const std::shared_ptr<IndexState> &st)
{
    ArkUI_NativeNodeAPI_1 *api = NodeApiInstance::GetInstance()->GetNativeNodeAPI();
    ArkUI_NodeHandle colHandle = api->createNode(ARKUI_NODE_COLUMN);
    std::shared_ptr<BaseNode> col = std::make_shared<BaseNode>(colHandle);

    col->SetWidth(K_INDEX_BAR_WIDTH);
    col->SetHeightPercent(K_FULL_PERCENT);

    Utils::SetPadding(
        api, col->GetHandle(),
        Utils::Padding::Only(K_INDEX_BAR_PAD_TOP, K_INDEX_BAR_PAD_RIGHT, K_INDEX_BAR_PAD_BOTTOM, K_INDEX_BAR_PAD_LEFT));

    st->letters.reserve(K_ALPHABET_COUNT);
    for (int i = 0; i < K_ALPHABET_COUNT; ++i) {
        char label[2];
        label[0] = static_cast<char>('A' + i);
        label[1] = '\0';

        ArkUI_NodeHandle textHandle = api->createNode(ARKUI_NODE_TEXT);
        std::shared_ptr<BaseNode> t = std::make_shared<BaseNode>(textHandle);

        Utils::SetTextContent(api, textHandle, label);
        SetIndexTextStyle(textHandle, K_INDEX_ITEM_HEIGHT, false);

        int group = i;
        t->RegisterOnClick([list, st, i, group](ArkUI_NodeEvent *) {
            UpdateIndexHighlight(st, i);
            list->ScrollToIndexInGroup(group, 0);
        });

        col->AddChild(t);
        st->letters.emplace_back(t);
    }
    return col;
}

static std::shared_ptr<ListMaker> ApplyListSafeProps()
{
    std::shared_ptr<ListMaker> list = std::make_shared<ListMaker>();
    list->SetWidthPercent(K_LIST_WIDTH_PERCENT);
    list->SetHeightPercent(K_FULL_PERCENT);
    list->SetScrollBarState(true);
    list->SetClipContent(true);
    list->SetSpace(K_LIST_SPACE);
    list->SetNestedScrollMode(ListMaker::kNestedScrollParentFirst);
    return list;
}

static ArkUI_NodeHandle CreateDeleteButton(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle t = api->createNode(ARKUI_NODE_TEXT);
    Utils::SetTextContent(api, t, K_DELETE_TEXT);
    Utils::SetAttributeFloat32(api, t, NODE_FONT_SIZE, K_INDEX_FONT_SIZE);
    Utils::SetAttributeFloat32(api, t, NODE_HEIGHT, K_DELETE_HEIGHT);
    Utils::SetAttributeFloat32(api, t, NODE_TEXT_LINE_HEIGHT, K_DELETE_HEIGHT);
    Utils::SetAttributeInt32(api, t, NODE_TEXT_ALIGN, ARKUI_TEXT_ALIGNMENT_CENTER);
    Utils::SetAttributeUInt32(api, t, NODE_BACKGROUND_COLOR, K_COLOR_DELETE_BG);
    Utils::SetAttributeUInt32(api, t, NODE_FONT_COLOR, K_COLOR_WHITE);
    Utils::SetAttributeFloat32(api, t, NODE_WIDTH, K_DELETE_WIDTH);
    return t;
}

static void SetupSwipeForListItem(ArkUI_NodeHandle item, ArkUI_NativeNodeAPI_1 *api,
                                  const std::shared_ptr<std::vector<std::string>> &items,
                                  const std::weak_ptr<ArkUINodeAdapter> &adapterWeak)
{
    static std::vector<std::unique_ptr<ListItemSwipe>> s_swipeKeep;

    std::unique_ptr<ListItemSwipe> swipe = std::make_unique<ListItemSwipe>(api);

    auto makeDeleteBtn = [api, items, adapterWeak, item](ArkUI_NativeNodeAPI_1 *apiInner) -> ArkUI_NodeHandle {
        ArkUI_NodeHandle btn = CreateDeleteButton(apiInner);
        if (!btn) {
            return nullptr;
        }

        // 1) 创建时立即建立上下文
        std::shared_ptr<ClickCtx> ctx = std::make_shared<ClickCtx>();
        ctx->api = api;
        ctx->items = items;
        ctx->adapter = adapterWeak;
        ctx->itemHandle = item;

        s_itemToDeleteBtn[item] = btn;
        s_btnCtx[btn] = ctx;

        // 2) 双路径注册（两个 API 都试一次，避免实例不一致）
        apiInner->addNodeEventReceiver(btn, &StaticDeleteBtnEvent);
        apiInner->registerNodeEvent(btn, NODE_ON_CLICK, 0, ctx.get());

        // 保险：用外层 api 再注册一层（有的环境两个指针其实等价，但这样更稳）
        api->addNodeEventReceiver(btn, &StaticDeleteBtnEvent);
        api->registerNodeEvent(btn, NODE_ON_CLICK, 0, ctx.get());

        // 3) 父项兜底注册（在 item 上也注册 CLICK）
        //    点击冒泡到 item 时，我们在 StaticDeleteBtnEvent 里根据目标句柄再判断
        api->addNodeEventReceiver(item, &StaticDeleteBtnEvent);
        api->registerNodeEvent(item, NODE_ON_CLICK, 0, ctx.get());

        return btn;
    };

    swipe->BuildEndArea(makeDeleteBtn)
        .SetActionAreaDistance(K_SWIPE_ACTION_DISTANCE)
        .SetEdgeEffect(K_EDGE_EFFECT_NONE)
        .OnEnter([] {})
        .OnExit([] {})
        .OnAction([] {})
        .OnStateChange([](int /*st*/) {})
        .OnOffsetChange([](float /*off*/) {})
        .OnEnterWithUserData([](void *) {})
        .OnExitWithUserData([](void *) {})
        .OnActionWithUserData([](void *) {})
        .OnStateChangeWithUserData([](int /*st*/, void *) {})
        .OnOffsetChangeWithUserData([](float /*off*/, void *) {});

    swipe->AttachToListItem(item);
    s_swipeKeep.emplace_back(std::move(swipe));
}

static ArkUI_NodeHandle CreateListItemWithSwipe(ArkUI_NativeNodeAPI_1 *api,
                                                const std::shared_ptr<std::vector<std::string>> &items,
                                                const std::weak_ptr<ArkUINodeAdapter> &adapterWeak)
{
    ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
    ArkUI_NodeHandle item = api->createNode(ARKUI_NODE_LIST_ITEM);
    api->addChild(item, text);

    Utils::SetAttributeFloat32(api, item, NODE_WIDTH_PERCENT, K_FULL_PERCENT);
    Utils::SetAttributeFloat32(api, text, NODE_WIDTH_PERCENT, K_FULL_PERCENT);

    SetupSwipeForListItem(item, api, items, adapterWeak);
    return item;
}

static void BindListItemContent(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle item, int32_t index,
                                const std::shared_ptr<std::vector<std::string>> &items,
                                const std::weak_ptr<ArkUINodeAdapter> &adapterWeak)
{
    if (!Utils::ValidateApiAndNode(api, item, "BindListItemContent")) {
        return;
    }
    if (!Utils::IsNotNull(items)) {
        return;
    }

    ArkUI_NodeHandle text = api->getFirstChild(item);
    if (!Utils::IsNotNull(text)) {
        return;
    }

    const int32_t n = static_cast<int32_t>(items->size());
    const bool valid = Utils::IsValidIndex(index, n);
    const char *content = valid ? (*items)[static_cast<size_t>(index)].c_str() : K_INVALID_TEXT;

    Utils::SetTextContent(api, text, content);
    Utils::SetBackgroundColor(api, item, K_COLOR_WHITE);
    Utils::SetTextStyle(api, text, K_ITEM_FONT_SIZE, K_COLOR_BLACK, ARKUI_TEXT_ALIGNMENT_CENTER);
    Utils::SetAttributeFloat32(api, text, NODE_HEIGHT, K_ROW_HEIGHT);
    Utils::SetAttributeFloat32(api, text, NODE_TEXT_LINE_HEIGHT, K_ROW_HEIGHT);

    // 更新删除按钮上下文
    auto itBtn = s_itemToDeleteBtn.find(item);
    if (itBtn == s_itemToDeleteBtn.end()) {
        OH_LOG_Print(LOG_APP, LOG_WARN, K_LOG_DOMAIN, LOG_TAG,
                     "BindListItemContent: item not found in s_itemToDeleteBtn");
        return;
    }

    auto itCtx = s_btnCtx.find(itBtn->second);
    if (itCtx == s_btnCtx.end() || !itCtx->second) {
        OH_LOG_Print(LOG_APP, LOG_WARN, K_LOG_DOMAIN, LOG_TAG, "BindListItemContent: context not found for button");
        return;
    }

    ClickCtx &ctx = *itCtx->second;
    ctx.index = index;
    ctx.items = items;         // 更新到当前 Group 的 items
    ctx.adapter = adapterWeak; // 更新到当前 Group 的 adapter

    if (valid) {
        ctx.stableId = static_cast<uint64_t>(std::hash<std::string>{}((*items)[static_cast<size_t>(index)]));
    }

    OH_LOG_Print(LOG_APP, LOG_DEBUG, K_LOG_DOMAIN, LOG_TAG,
                 "BindListItemContent: updated context for index=%d, content=%s", index, content);
}

static NodeAdapterCallbacks CreateGroupCallbacks(const std::shared_ptr<std::vector<std::string>> &items)
{
    NodeAdapterCallbacks cb{};
    cb.getTotalCount = [items]() -> int32_t { return static_cast<int32_t>(items->size()); };
    cb.getStableId = [items](int32_t i) -> uint64_t {
        const int32_t n = static_cast<int32_t>(items->size());
        if (i >= 0 && i < n) {
            return static_cast<uint64_t>(std::hash<std::string>{}((*items)[static_cast<size_t>(i)]));
        }
        return static_cast<uint64_t>(i);
    };
    return cb;
}

static std::shared_ptr<std::vector<std::string>> CreateGroupItemsData(const GroupNames &gn)
{
    std::shared_ptr<std::vector<std::string>> items = std::make_shared<std::vector<std::string>>();
    items->reserve(static_cast<size_t>(gn.size));
    for (int i = 0; i < gn.size; ++i) {
        items->emplace_back(gn.arr[i]);
    }
    return items;
}

static void SetupGroupHeaderAndFooter(std::shared_ptr<ListItemGroupNode> &group, const GroupNames &gn, bool isLast)
{
    char title[16]{};
    title[0] = gn.letter;
    title[1] = '\0';

    std::shared_ptr<BaseNode> header = MakeText(title, K_HEADER_HEIGHT, K_COLOR_HEADER_BG);
    group->SetHeader(header);

    if (isLast) {
        std::shared_ptr<BaseNode> footer = MakeText(K_FOOTER_TEXT, K_FOOTER_HEIGHT, K_COLOR_FOOTER_BG);
        group->SetFooter(footer);
    }
}

// 修改后的 CreateGroupAdapterCallbacks 函数
static NodeAdapterCallbacks CreateGroupAdapterCallbacks(const std::shared_ptr<std::vector<std::string>> &items,
                                                        std::shared_ptr<ArkUINodeAdapter> adapter)
{
    NodeAdapterCallbacks cb = CreateGroupCallbacks(items);

    cb.onCreate = [items, adapterWeak = std::weak_ptr<ArkUINodeAdapter>(adapter)](
                      ArkUI_NativeNodeAPI_1 *api, int32_t /*index*/) -> ArkUI_NodeHandle {
        return CreateListItemWithSwipe(api, items, adapterWeak);
    };

    cb.onBind = [items, adapterWeak = std::weak_ptr<ArkUINodeAdapter>(adapter)](ArkUI_NativeNodeAPI_1 *api,
                                                                                ArkUI_NodeHandle item, int32_t index) {
        BindListItemContent(api, item, index, items, adapterWeak);
    };

    return cb;
}

static std::shared_ptr<ListItemGroupNode> BuildGroup(int gIndex, bool isLast,
                                                     const std::shared_ptr<IndexState> & /*st*/)
{
    const GroupNames &gn = GROUPS[static_cast<size_t>(gIndex)];
    std::shared_ptr<ListItemGroupNode> group = std::make_shared<ListItemGroupNode>();

    SetupGroupHeaderAndFooter(group, gn, isLast);

    std::shared_ptr<std::vector<std::string>> items = CreateGroupItemsData(gn);
    std::shared_ptr<ArkUINodeAdapter> adapter =
        std::make_shared<ArkUINodeAdapter>(static_cast<int32_t>(ARKUI_NODE_LIST_ITEM));
    NodeAdapterCallbacks cb = CreateGroupAdapterCallbacks(items, adapter);

    adapter->SetCallbacks(cb);
    group->SetLazyAdapter(adapter);
    return group;
}

/**
 * 创建按字母索引的懒加载列表
 */
std::shared_ptr<BaseNode> CreateLazyTextListExample()
{
    ArkUI_NativeNodeAPI_1 *api = NodeApiInstance::GetInstance()->GetNativeNodeAPI();
    ArkUI_NodeHandle rootHandle = api->createNode(ARKUI_NODE_ROW);
    std::shared_ptr<BaseNode> root = std::make_shared<BaseNode>(rootHandle);

    root->SetWidthPercent(K_FULL_PERCENT);
    root->SetHeightPercent(K_FULL_PERCENT);

    std::shared_ptr<ListMaker> list = ApplyListSafeProps();
    std::shared_ptr<IndexState> st = std::make_shared<IndexState>();
    st->groupVisible.assign(K_ALPHABET_COUNT, false);

    for (int g = 0; g < K_ALPHABET_COUNT; ++g) {
        bool isLast = (g == K_ALPHABET_COUNT - 1);
        std::shared_ptr<ListItemGroupNode> grp = BuildGroup(g, isLast, st);
        list->AddChild(std::static_pointer_cast<BaseNode>(grp));
    }

    std::shared_ptr<BaseNode> right = BuildRightIndexColumn(list, st);
    list->RegisterOnScrollIndex([st](int32_t first, int32_t last) {
        int idx = first;
        if (last == K_ALPHABET_COUNT - 1) {
            idx = last;
        }
        if (idx < 0)
            return;
        if (idx >= K_ALPHABET_COUNT)
            idx = K_ALPHABET_COUNT - 1;
        UpdateIndexHighlight(st, idx);
    });

    list->RegisterOnReachEnd([st]() { UpdateIndexHighlight(st, K_ALPHABET_COUNT - 1); });

    UpdateIndexHighlight(st, K_FIRST_GROUP_INDEX);

    root->AddChild(list);
    root->AddChild(right);

    static std::vector<std::shared_ptr<BaseNode>> g_keepAlive;
    g_keepAlive.emplace_back(root);
    return root;
}

ArkUI_NodeHandle ListMaker::createListPage()
{
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (api == nullptr) {
        return nullptr;
    }

    ArkUI_NodeHandle page = api->createNode(ARKUI_NODE_COLUMN);
    if (page == nullptr) {
        return nullptr;
    }
    Utils::SetAttributeFloat32(api, page, NODE_WIDTH_PERCENT, 1.0f);
    Utils::SetAttributeFloat32(api, page, NODE_HEIGHT_PERCENT, 1.0f);

    std::shared_ptr<BaseNode> root = CreateLazyTextListExample();
    if (root && root->GetHandle() != nullptr) {
        Utils::SetAttributeFloat32(api, root->GetHandle(), NODE_LAYOUT_WEIGHT, 1.0f);
        api->addChild(page, root->GetHandle());
    }

    return page;
}
