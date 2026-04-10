export interface BusinessScenario {
  id: string;
  domain: string;
  ability: string;
  entry: string;
  action: string;
  expectedState: string;
  expectedFocus: string;
  steps: string[];
}

class BusinessScenarioRecord implements BusinessScenario {
  id: string;
  domain: string;
  ability: string;
  entry: string;
  action: string;
  expectedState: string;
  expectedFocus: string;
  steps: string[];

  constructor(id: string, domain: string, ability: string, entry: string, action: string, expectedState: string,
    expectedFocus: string, steps: string[]) {
    this.id = id;
    this.domain = domain;
    this.ability = ability;
    this.entry = entry;
    this.action = action;
    this.expectedState = expectedState;
    this.expectedFocus = expectedFocus;
    this.steps = steps;
  }
}

const BASE_BUSINESS_SCENARIOS: BusinessScenario[] = [
  {
    id: 'home_001',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'open_picture_tab',
    expectedState: 'picture_ready',
    expectedFocus: 'menu0',
    steps: ['launch_entry', 'focus_picture_tab', 'verify_picture_ready']
  },
  {
    id: 'home_002',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'open_album_tab',
    expectedState: 'album_ready',
    expectedFocus: 'menu1',
    steps: ['launch_entry', 'focus_album_tab', 'verify_album_ready']
  },
  {
    id: 'home_003',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'open_distributed_tab',
    expectedState: 'distributed_ready',
    expectedFocus: 'menu2',
    steps: ['launch_entry', 'focus_distributed_tab', 'verify_distributed_ready']
  },
  {
    id: 'home_004',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'menu_left_boundary',
    expectedState: 'picture_ready',
    expectedFocus: 'menu0',
    steps: ['launch_entry', 'press_left', 'verify_menu0_focus']
  },
  {
    id: 'home_005',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'menu_right_boundary',
    expectedState: 'distributed_ready',
    expectedFocus: 'menu2',
    steps: ['launch_entry', 'press_right', 'verify_menu2_focus']
  },
  {
    id: 'home_006',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'move_to_album',
    expectedState: 'album_ready',
    expectedFocus: 'menu1',
    steps: ['launch_entry', 'press_right', 'verify_menu1_focus']
  },
  {
    id: 'home_007',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'move_to_distributed',
    expectedState: 'distributed_ready',
    expectedFocus: 'menu2',
    steps: ['launch_entry', 'press_right', 'verify_menu2_focus']
  },
  {
    id: 'home_008',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'move_back_to_album',
    expectedState: 'album_ready',
    expectedFocus: 'menu1',
    steps: ['launch_entry', 'press_left', 'verify_menu1_focus']
  },
  {
    id: 'home_009',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'move_back_to_picture',
    expectedState: 'picture_ready',
    expectedFocus: 'menu0',
    steps: ['launch_entry', 'press_left', 'verify_menu0_focus']
  },
  {
    id: 'home_010',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'open_picture_grid',
    expectedState: 'picture_grid_ready',
    expectedFocus: 'photo_0_0',
    steps: ['launch_entry', 'press_down', 'verify_first_photo_focus']
  },
  {
    id: 'home_011',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'open_album_grid',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album0',
    steps: ['launch_entry', 'press_down', 'verify_first_album_focus']
  },
  {
    id: 'home_012',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'open_distributed_manage',
    expectedState: 'dfs_manage_ready',
    expectedFocus: 'to_dfs_manage',
    steps: ['launch_entry', 'press_down', 'verify_dfs_manage_focus']
  },
  {
    id: 'home_013',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'normalize_picture_label',
    expectedState: 'labels_ready',
    expectedFocus: 'menu0',
    steps: ['load_labels', 'normalize_picture_label', 'verify_picture_label']
  },
  {
    id: 'home_014',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'normalize_album_label',
    expectedState: 'labels_ready',
    expectedFocus: 'menu1',
    steps: ['load_labels', 'normalize_album_label', 'verify_album_label']
  },
  {
    id: 'home_015',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'normalize_distributed_label',
    expectedState: 'labels_ready',
    expectedFocus: 'menu2',
    steps: ['load_labels', 'normalize_distributed_label', 'verify_distributed_label']
  },
  {
    id: 'home_016',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'open_choose_dialog',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: ['open_edit_dialog', 'focus_choose_action', 'verify_dialog2_focus']
  },
  {
    id: 'home_017',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'open_share_dialog',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog1',
    steps: ['open_edit_dialog', 'focus_share_action', 'verify_dialog1_focus']
  },
  {
    id: 'home_018',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'open_delete_dialog',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog0',
    steps: ['open_edit_dialog', 'focus_delete_action', 'verify_dialog0_focus']
  },
  {
    id: 'home_019',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'rotation_0_contract',
    expectedState: 'rotation_ready',
    expectedFocus: 'menu0',
    steps: ['load_rotation_matrix', 'select_rotation_0', 'verify_rotation_0']
  },
  {
    id: 'home_020',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'rotation_90_contract',
    expectedState: 'rotation_ready',
    expectedFocus: 'menu0',
    steps: ['load_rotation_matrix', 'select_rotation_90', 'verify_rotation_90']
  },
  {
    id: 'home_021',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'rotation_180_contract',
    expectedState: 'rotation_ready',
    expectedFocus: 'menu0',
    steps: ['load_rotation_matrix', 'select_rotation_180', 'verify_rotation_180']
  },
  {
    id: 'home_022',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'rotation_270_contract',
    expectedState: 'rotation_ready',
    expectedFocus: 'menu0',
    steps: ['load_rotation_matrix', 'select_rotation_270', 'verify_rotation_270']
  },
  {
    id: 'home_023',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'wait_for_stable_short',
    expectedState: 'wait_history_ready',
    expectedFocus: 'menu0',
    steps: ['create_driver', 'wait_60ms', 'verify_delay_history']
  },
  {
    id: 'home_024',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'wait_for_stable_medium',
    expectedState: 'wait_history_ready',
    expectedFocus: 'menu0',
    steps: ['create_driver', 'wait_120ms', 'verify_delay_history']
  },
  {
    id: 'home_025',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'wait_for_stable_long',
    expectedState: 'wait_history_ready',
    expectedFocus: 'menu0',
    steps: ['create_driver', 'wait_240ms', 'verify_delay_history']
  },
  {
    id: 'home_026',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'validate_chinese_labels',
    expectedState: 'labels_ready',
    expectedFocus: 'menu0',
    steps: ['load_label_set', 'validate_chinese_labels', 'verify_label_set']
  },
  {
    id: 'home_027',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'validate_english_labels',
    expectedState: 'labels_ready',
    expectedFocus: 'menu1',
    steps: ['load_label_set', 'validate_english_labels', 'verify_label_set']
  },
  {
    id: 'home_028',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'reject_unreadable_labels',
    expectedState: 'labels_invalid',
    expectedFocus: 'menu2',
    steps: ['load_label_set', 'validate_invalid_labels', 'verify_invalid_result']
  },
  {
    id: 'home_029',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'fallback_picture_by_id',
    expectedState: 'picture_ready',
    expectedFocus: 'menu0',
    steps: ['clear_text_selector', 'focus_menu0_by_id', 'verify_picture_ready']
  },
  {
    id: 'home_030',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'fallback_album_by_id',
    expectedState: 'album_ready',
    expectedFocus: 'menu1',
    steps: ['clear_text_selector', 'focus_menu1_by_id', 'verify_album_ready']
  },
  {
    id: 'home_031',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'fallback_distributed_by_id',
    expectedState: 'distributed_ready',
    expectedFocus: 'menu2',
    steps: ['clear_text_selector', 'focus_menu2_by_id', 'verify_distributed_ready']
  },
  {
    id: 'home_032',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'choose_dialog_text_candidate',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: ['build_dialog_candidates', 'tap_choose_candidate', 'verify_dialog2_focus']
  },
  {
    id: 'home_033',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'share_dialog_text_candidate',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog1',
    steps: ['build_dialog_candidates', 'tap_share_candidate', 'verify_dialog1_focus']
  },
  {
    id: 'home_034',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'delete_dialog_text_candidate',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog0',
    steps: ['build_dialog_candidates', 'tap_delete_candidate', 'verify_dialog0_focus']
  },
  {
    id: 'home_035',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'core_label_contract',
    expectedState: 'labels_ready',
    expectedFocus: 'menu0',
    steps: ['start_entry_ability', 'get_core_home_labels', 'verify_label_count']
  },
  {
    id: 'home_036',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_candidate_order',
    expectedState: 'candidate_ready',
    expectedFocus: 'menu0',
    steps: ['build_home_candidates', 'read_picture_candidates', 'verify_candidate_order']
  },
  {
    id: 'home_037',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_candidate_order',
    expectedState: 'candidate_ready',
    expectedFocus: 'menu1',
    steps: ['build_home_candidates', 'read_album_candidates', 'verify_candidate_order']
  },
  {
    id: 'home_038',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_candidate_order',
    expectedState: 'candidate_ready',
    expectedFocus: 'menu2',
    steps: ['build_home_candidates', 'read_distributed_candidates', 'verify_candidate_order']
  },
  {
    id: 'home_039',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'rotation_sequence_matrix',
    expectedState: 'rotation_ready',
    expectedFocus: 'menu0',
    steps: ['load_rotation_names', 'iterate_rotation_matrix', 'verify_rotation_length']
  },
  {
    id: 'home_040',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'wait_and_rotation_sequence',
    expectedState: 'driver_ready',
    expectedFocus: 'menu0',
    steps: ['wait_for_driver', 'rotate_driver', 'verify_driver_history']
  },
  {
    id: 'album_001',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'open_all_album',
    expectedState: 'photo_list_ready',
    expectedFocus: 'album0',
    steps: ['focus_album0', 'open_all_album', 'verify_photo_list_route']
  },
  {
    id: 'album_002',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'open_favorite_album',
    expectedState: 'photo_list_ready',
    expectedFocus: 'album1',
    steps: ['focus_album1', 'open_favorite_album', 'verify_photo_list_route']
  },
  {
    id: 'album_003',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'open_screenshot_album',
    expectedState: 'photo_list_ready',
    expectedFocus: 'album2',
    steps: ['focus_album2', 'open_screenshot_album', 'verify_photo_list_route']
  },
  {
    id: 'album_004',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'open_trash_album',
    expectedState: 'delete_list_ready',
    expectedFocus: 'album3',
    steps: ['focus_album3', 'open_trash_album', 'verify_delete_list_route']
  },
  {
    id: 'album_005',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'open_nas_session_album',
    expectedState: 'nas_session_ready',
    expectedFocus: 'album4',
    steps: ['focus_album4', 'open_nas_session_album', 'verify_nas_session_route']
  },
  {
    id: 'album_006',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_left_boundary',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album0',
    steps: ['focus_album0', 'press_left', 'verify_album0_focus']
  },
  {
    id: 'album_007',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'album_right_boundary',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album4',
    steps: ['focus_album4', 'press_right', 'verify_album4_focus']
  },
  {
    id: 'album_008',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_move_right_to_favorite',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album1',
    steps: ['focus_album0', 'press_right', 'verify_album1_focus']
  },
  {
    id: 'album_009',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'album_move_right_to_screenshot',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album2',
    steps: ['focus_album1', 'press_right', 'verify_album2_focus']
  },
  {
    id: 'album_010',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'album_move_right_to_trash',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album3',
    steps: ['focus_album2', 'press_right', 'verify_album3_focus']
  },
  {
    id: 'album_011',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'album_move_right_to_nas',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album4',
    steps: ['focus_album3', 'press_right', 'verify_album4_focus']
  },
  {
    id: 'album_012',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'album_move_left_to_trash',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album3',
    steps: ['focus_album4', 'press_left', 'verify_album3_focus']
  },
  {
    id: 'album_013',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'album_move_left_to_screenshot',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album2',
    steps: ['focus_album3', 'press_left', 'verify_album2_focus']
  },
  {
    id: 'album_014',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'album_move_left_to_favorite',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album1',
    steps: ['focus_album2', 'press_left', 'verify_album1_focus']
  },
  {
    id: 'album_015',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'album_move_left_to_all',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album0',
    steps: ['focus_album1', 'press_left', 'verify_album0_focus']
  },
  {
    id: 'album_016',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_down_to_nas',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album4',
    steps: ['focus_album0', 'press_down', 'verify_album4_focus']
  },
  {
    id: 'album_017',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'album_up_to_all',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album0',
    steps: ['focus_album4', 'press_up', 'verify_album0_focus']
  },
  {
    id: 'album_018',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_focus_fail_fallback',
    expectedState: 'album_menu_ready',
    expectedFocus: 'menu1',
    steps: ['deny_album_focus', 'request_album_focus', 'verify_menu1_focus']
  },
  {
    id: 'album_019',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_route_all_params',
    expectedState: 'route_ready',
    expectedFocus: 'album0',
    steps: ['open_all_album', 'capture_route_params', 'verify_all_album_params']
  },
  {
    id: 'album_020',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'album_route_favorite_params',
    expectedState: 'route_ready',
    expectedFocus: 'album1',
    steps: ['open_favorite_album', 'capture_route_params', 'verify_favorite_album_params']
  },
  {
    id: 'album_021',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'album_route_screenshot_params',
    expectedState: 'route_ready',
    expectedFocus: 'album2',
    steps: ['open_screenshot_album', 'capture_route_params', 'verify_screenshot_album_params']
  },
  {
    id: 'album_022',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'album_route_trash_params',
    expectedState: 'route_ready',
    expectedFocus: 'album3',
    steps: ['open_trash_album', 'capture_route_params', 'verify_trash_album_params']
  },
  {
    id: 'album_023',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'album_route_nas_params',
    expectedState: 'route_ready',
    expectedFocus: 'album4',
    steps: ['open_nas_album', 'capture_route_params', 'verify_nas_album_params']
  },
  {
    id: 'album_024',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'tab_down_from_album_with_data',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album0',
    steps: ['build_album_grid', 'press_down_from_menu1', 'verify_album0_focus']
  },
  {
    id: 'album_025',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'tab_down_from_album_with_nas_only',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album4',
    steps: ['build_album_grid', 'focus_nas_entry', 'verify_album4_focus']
  },
  {
    id: 'album_026',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_neighbor_matrix_all',
    expectedState: 'neighbor_ready',
    expectedFocus: 'album0',
    steps: ['build_neighbor_matrix', 'read_all_neighbors', 'verify_neighbor_contract']
  },
  {
    id: 'album_027',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'album_neighbor_matrix_favorite',
    expectedState: 'neighbor_ready',
    expectedFocus: 'album1',
    steps: ['build_neighbor_matrix', 'read_favorite_neighbors', 'verify_neighbor_contract']
  },
  {
    id: 'album_028',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'album_neighbor_matrix_screenshot',
    expectedState: 'neighbor_ready',
    expectedFocus: 'album2',
    steps: ['build_neighbor_matrix', 'read_screenshot_neighbors', 'verify_neighbor_contract']
  },
  {
    id: 'album_029',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'album_neighbor_matrix_trash',
    expectedState: 'neighbor_ready',
    expectedFocus: 'album3',
    steps: ['build_neighbor_matrix', 'read_trash_neighbors', 'verify_neighbor_contract']
  },
  {
    id: 'album_030',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'album_neighbor_matrix_nas',
    expectedState: 'neighbor_ready',
    expectedFocus: 'album4',
    steps: ['build_neighbor_matrix', 'read_nas_neighbors', 'verify_neighbor_contract']
  },
  {
    id: 'album_031',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'focus_album_tile_success',
    expectedState: 'focus_ready',
    expectedFocus: 'album0',
    steps: ['allow_album0_focus', 'request_album0_focus', 'verify_album0_focus']
  },
  {
    id: 'album_032',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'focus_album_tile_success',
    expectedState: 'focus_ready',
    expectedFocus: 'album1',
    steps: ['allow_album1_focus', 'request_album1_focus', 'verify_album1_focus']
  },
  {
    id: 'album_033',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'focus_album_tile_success',
    expectedState: 'focus_ready',
    expectedFocus: 'album2',
    steps: ['allow_album2_focus', 'request_album2_focus', 'verify_album2_focus']
  },
  {
    id: 'album_034',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'focus_album_tile_success',
    expectedState: 'focus_ready',
    expectedFocus: 'album3',
    steps: ['allow_album3_focus', 'request_album3_focus', 'verify_album3_focus']
  },
  {
    id: 'album_035',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'focus_album_tile_success',
    expectedState: 'focus_ready',
    expectedFocus: 'album4',
    steps: ['allow_album4_focus', 'request_album4_focus', 'verify_album4_focus']
  },
  {
    id: 'album_036',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'tab_left_from_album_menu',
    expectedState: 'menu_ready',
    expectedFocus: 'menu0',
    steps: ['focus_menu1', 'press_left', 'verify_menu0_focus']
  },
  {
    id: 'album_037',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'tab_right_from_album_menu',
    expectedState: 'menu_ready',
    expectedFocus: 'menu2',
    steps: ['focus_menu1', 'press_right', 'verify_menu2_focus']
  },
  {
    id: 'album_038',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_grid_first_tile_contract',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album0',
    steps: ['build_album_grid', 'focus_first_album', 'verify_album0_focus']
  },
  {
    id: 'album_039',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'album_grid_trash_contract',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album3',
    steps: ['build_album_grid', 'focus_trash_album', 'verify_album3_focus']
  },
  {
    id: 'album_040',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'album_grid_nas_contract',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album4',
    steps: ['build_album_grid', 'focus_nas_album', 'verify_album4_focus']
  },
  {
    id: 'distributed_001',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'open_device_page',
    expectedState: 'device_page_ready',
    expectedFocus: 'menu2',
    steps: ['open_distributed_tab', 'load_device_page', 'verify_device_page_ready']
  },
  {
    id: 'distributed_002',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'empty_device_state',
    expectedState: 'device_empty',
    expectedFocus: 'menu2',
    steps: ['open_distributed_tab', 'load_empty_devices', 'verify_empty_state']
  },
  {
    id: 'distributed_003',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'device_scan_failure',
    expectedState: 'device_error',
    expectedFocus: 'menu2',
    steps: ['open_distributed_tab', 'inject_scan_error', 'verify_error_state']
  },
  {
    id: 'distributed_004',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'device_scan_retry',
    expectedState: 'device_retry_ready',
    expectedFocus: 'menu2',
    steps: ['open_distributed_tab', 'retry_scan', 'verify_retry_state']
  },
  {
    id: 'distributed_005',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'mount_dfs_success',
    expectedState: 'dfs_connected',
    expectedFocus: 'dfs_photo_0',
    steps: ['select_device', 'mount_dfs', 'verify_dfs_connected']
  },
  {
    id: 'distributed_006',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'mount_dfs_failure',
    expectedState: 'dfs_error',
    expectedFocus: 'to_dfs_manage',
    steps: ['select_device', 'mount_dfs', 'verify_dfs_error']
  },
  {
    id: 'distributed_007',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'open_receive_dialog',
    expectedState: 'receive_ready',
    expectedFocus: 'menu0',
    steps: ['trigger_receive_flow', 'open_receive_dialog', 'verify_receive_state']
  },
  {
    id: 'distributed_008',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'receive_pending_state',
    expectedState: 'receive_pending',
    expectedFocus: 'menu1',
    steps: ['trigger_receive_flow', 'set_pending_state', 'verify_pending_overlay']
  },
  {
    id: 'distributed_009',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'receive_complete_state',
    expectedState: 'receive_complete',
    expectedFocus: 'menu0',
    steps: ['trigger_receive_flow', 'set_complete_state', 'verify_complete_overlay']
  },
  {
    id: 'distributed_010',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'receive_idle_state',
    expectedState: 'receive_idle',
    expectedFocus: 'menu0',
    steps: ['trigger_receive_flow', 'set_idle_state', 'verify_idle_overlay']
  },
  {
    id: 'distributed_011',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'dfs_size_kb_boundary',
    expectedState: 'size_ready',
    expectedFocus: 'menu2',
    steps: ['set_transfer_size_1024', 'format_transfer_size', 'verify_kb_boundary']
  },
  {
    id: 'distributed_012',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'dfs_size_kb_fraction',
    expectedState: 'size_ready',
    expectedFocus: 'menu2',
    steps: ['set_transfer_size_1536', 'format_transfer_size', 'verify_kb_fraction']
  },
  {
    id: 'distributed_013',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'dfs_size_mb_boundary',
    expectedState: 'size_ready',
    expectedFocus: 'menu2',
    steps: ['set_transfer_size_2mb', 'format_transfer_size', 'verify_mb_boundary']
  },
  {
    id: 'distributed_014',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'dfs_size_mb_fraction',
    expectedState: 'size_ready',
    expectedFocus: 'menu2',
    steps: ['set_transfer_size_55mb', 'format_transfer_size', 'verify_mb_fraction']
  },
  {
    id: 'distributed_015',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'group_observer_all_album',
    expectedState: 'group_ready',
    expectedFocus: 'menu2',
    steps: ['load_all_album_photos', 'group_observer_photos', 'verify_group_count']
  },
  {
    id: 'distributed_016',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'group_observer_favorite_album',
    expectedState: 'group_ready',
    expectedFocus: 'menu2',
    steps: ['load_favorite_photos', 'group_observer_photos', 'verify_group_count']
  },
  {
    id: 'distributed_017',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'group_observer_trash_album',
    expectedState: 'group_ready',
    expectedFocus: 'menu2',
    steps: ['load_trash_photos', 'group_observer_photos', 'verify_group_count']
  },
  {
    id: 'distributed_018',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'key_callback_menu_shortcut',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: ['focus_menu0', 'invoke_key_callback', 'verify_dialog_focus']
  },
  {
    id: 'distributed_019',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'key_callback_grid_shortcut',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: ['focus_photo_grid', 'invoke_key_callback', 'verify_dialog_focus']
  },
  {
    id: 'distributed_020',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'key_callback_dfs_shortcut',
    expectedState: 'dfs_dialog_ready',
    expectedFocus: 'dfs_dialog_confirm',
    steps: ['focus_menu2', 'invoke_key_callback', 'verify_dfs_dialog']
  },
  {
    id: 'distributed_021',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'album_neighbor_all_right',
    expectedState: 'neighbor_ready',
    expectedFocus: 'menu2',
    steps: ['build_dense_album_matrix', 'read_all_right_neighbor', 'verify_neighbor_result']
  },
  {
    id: 'distributed_022',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'album_neighbor_favorite_left',
    expectedState: 'neighbor_ready',
    expectedFocus: 'menu2',
    steps: ['build_dense_album_matrix', 'read_favorite_left_neighbor', 'verify_neighbor_result']
  },
  {
    id: 'distributed_023',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'album_neighbor_all_down',
    expectedState: 'neighbor_ready',
    expectedFocus: 'menu2',
    steps: ['build_dense_album_matrix', 'read_all_down_neighbor', 'verify_neighbor_result']
  },
  {
    id: 'distributed_024',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'album_neighbor_nas_up',
    expectedState: 'neighbor_ready',
    expectedFocus: 'menu2',
    steps: ['build_dense_album_matrix', 'read_nas_up_neighbor', 'verify_neighbor_result']
  },
  {
    id: 'distributed_025',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'album_neighbor_trash_right',
    expectedState: 'neighbor_ready',
    expectedFocus: 'menu2',
    steps: ['build_dense_album_matrix', 'read_trash_right_neighbor', 'verify_neighbor_result']
  },
  {
    id: 'distributed_026',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'album_neighbor_nas_right_boundary',
    expectedState: 'neighbor_ready',
    expectedFocus: 'menu2',
    steps: ['build_dense_album_matrix', 'read_nas_right_neighbor', 'verify_no_neighbor']
  },
  {
    id: 'distributed_027',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'wifi_close_on_complete',
    expectedState: 'wifi_closed',
    expectedFocus: 'menu0',
    steps: ['set_receive_complete', 'close_wifi_connection', 'verify_close_count']
  },
  {
    id: 'distributed_028',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'wifi_keep_on_pending',
    expectedState: 'wifi_open',
    expectedFocus: 'menu1',
    steps: ['set_receive_pending', 'skip_wifi_close', 'verify_close_count']
  },
  {
    id: 'distributed_029',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'focus_dialog_allowed',
    expectedState: 'focus_ready',
    expectedFocus: 'dialog2',
    steps: ['allow_dialog2_focus', 'request_dialog2_focus', 'verify_dialog2_focus']
  },
  {
    id: 'distributed_030',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'focus_dialog_denied',
    expectedState: 'focus_fallback',
    expectedFocus: 'menu0',
    steps: ['deny_dialog_focus', 'request_dialog_focus', 'verify_menu0_focus']
  },
  {
    id: 'distributed_031',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'observer_single_day_group',
    expectedState: 'group_ready',
    expectedFocus: 'menu2',
    steps: ['load_single_day_photos', 'run_observer', 'verify_single_group']
  },
  {
    id: 'distributed_032',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'observer_dual_day_group',
    expectedState: 'group_ready',
    expectedFocus: 'menu2',
    steps: ['load_dual_day_photos', 'run_observer', 'verify_dual_group']
  },
  {
    id: 'distributed_033',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'observer_favorite_group',
    expectedState: 'group_ready',
    expectedFocus: 'menu2',
    steps: ['load_favorite_day_photos', 'run_observer', 'verify_favorite_group']
  },
  {
    id: 'distributed_034',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'observer_trash_group',
    expectedState: 'group_ready',
    expectedFocus: 'menu2',
    steps: ['load_trash_day_photos', 'run_observer', 'verify_trash_group']
  },
  {
    id: 'distributed_035',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'menu_shortcut_empty_photo_guard',
    expectedState: 'guard_ready',
    expectedFocus: 'menu0',
    steps: ['clear_photo_groups', 'invoke_menu_shortcut', 'verify_no_dialog']
  },
  {
    id: 'distributed_036',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'dialog_shortcut_lock_guard',
    expectedState: 'guard_ready',
    expectedFocus: 'menu0',
    steps: ['open_existing_dialog', 'invoke_menu_shortcut', 'verify_dialog_lock']
  },
  {
    id: 'distributed_037',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'receive_overlay_back_priority',
    expectedState: 'overlay_ready',
    expectedFocus: 'menu0',
    steps: ['open_receive_overlay', 'invoke_back_action', 'verify_receive_closed']
  },
  {
    id: 'distributed_038',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'device_overlay_back_priority',
    expectedState: 'overlay_ready',
    expectedFocus: 'menu0',
    steps: ['open_device_overlay', 'invoke_back_action', 'verify_device_closed']
  },
  {
    id: 'distributed_039',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'delete_overlay_back_priority',
    expectedState: 'overlay_ready',
    expectedFocus: 'menu0',
    steps: ['open_delete_overlay', 'invoke_back_action', 'verify_delete_closed']
  },
  {
    id: 'distributed_040',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'complete_distributed_matrix',
    expectedState: 'matrix_ready',
    expectedFocus: 'menu2',
    steps: ['load_distributed_matrix', 'iterate_distributed_cases', 'verify_matrix_size']
  },
  {
    id: 'nas_001',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'load_single_client',
    expectedState: 'client_ready',
    expectedFocus: 'client_0',
    steps: ['find_nas_clients', 'load_single_client', 'verify_client_focus']
  },
  {
    id: 'nas_002',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'load_double_client',
    expectedState: 'client_ready',
    expectedFocus: 'client_0',
    steps: ['find_nas_clients', 'load_double_client', 'verify_client_focus']
  },
  {
    id: 'nas_003',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_4',
    action: 'load_five_client',
    expectedState: 'client_ready',
    expectedFocus: 'client_0',
    steps: ['find_nas_clients', 'load_five_client', 'verify_client_focus']
  },
  {
    id: 'nas_004',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'find_client_failure',
    expectedState: 'client_error',
    expectedFocus: 'client_0',
    steps: ['find_nas_clients', 'inject_find_failure', 'verify_error_state']
  },
  {
    id: 'nas_005',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'open_login_dialog',
    expectedState: 'dialog_ready',
    expectedFocus: 'client_0',
    steps: ['focus_client_card', 'open_login_dialog', 'verify_dialog_open']
  },
  {
    id: 'nas_006',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'confirm_login_success',
    expectedState: 'auth_success',
    expectedFocus: 'client_0',
    steps: ['open_login_dialog', 'confirm_login', 'verify_success_toast']
  },
  {
    id: 'nas_007',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'confirm_login_false',
    expectedState: 'auth_failed',
    expectedFocus: 'client_0',
    steps: ['open_login_dialog', 'confirm_login', 'verify_failure_toast']
  },
  {
    id: 'nas_008',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'confirm_login_throw',
    expectedState: 'auth_failed',
    expectedFocus: 'client_0',
    steps: ['open_login_dialog', 'throw_login_error', 'verify_failure_toast']
  },
  {
    id: 'nas_009',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'client_left_navigation',
    expectedState: 'client_grid_ready',
    expectedFocus: 'client_0',
    steps: ['focus_client1', 'press_left', 'verify_client0_focus']
  },
  {
    id: 'nas_010',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'client_right_navigation',
    expectedState: 'client_grid_ready',
    expectedFocus: 'client_1',
    steps: ['focus_client0', 'press_right', 'verify_client1_focus']
  },
  {
    id: 'nas_011',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_5',
    action: 'client_down_navigation',
    expectedState: 'client_grid_ready',
    expectedFocus: 'client_5',
    steps: ['focus_client0', 'press_down', 'verify_client5_focus']
  },
  {
    id: 'nas_012',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'client_up_navigation',
    expectedState: 'client_grid_ready',
    expectedFocus: 'client_1',
    steps: ['focus_client6', 'press_up', 'verify_client1_focus']
  },
  {
    id: 'nas_013',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'center_key_open_dialog',
    expectedState: 'dialog_ready',
    expectedFocus: 'client_0',
    steps: ['focus_client0', 'press_center', 'verify_dialog_open']
  },
  {
    id: 'nas_014',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'enter_key_open_dialog',
    expectedState: 'dialog_ready',
    expectedFocus: 'client_1',
    steps: ['focus_client1', 'press_enter', 'verify_dialog_open']
  },
  {
    id: 'nas_015',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'auth_success_middle_client',
    expectedState: 'auth_success',
    expectedFocus: 'client_0',
    steps: ['select_middle_client', 'confirm_auth', 'verify_client_removed']
  },
  {
    id: 'nas_016',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'auth_success_last_client',
    expectedState: 'route_back',
    expectedFocus: 'client_0',
    steps: ['select_last_client', 'confirm_auth', 'verify_route_back']
  },
  {
    id: 'nas_017',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'auth_failure_keep_client',
    expectedState: 'auth_failed',
    expectedFocus: 'client_0',
    steps: ['select_client', 'confirm_failed_auth', 'verify_client_retained']
  },
  {
    id: 'nas_018',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'auth_throw_keep_client',
    expectedState: 'auth_failed',
    expectedFocus: 'client_0',
    steps: ['select_client', 'throw_auth_error', 'verify_client_retained']
  },
  {
    id: 'nas_019',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'load_single_session',
    expectedState: 'session_ready',
    expectedFocus: 'session_0',
    steps: ['load_nas_session', 'append_placeholder', 'verify_session_count']
  },
  {
    id: 'nas_020',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_3',
    action: 'load_three_sessions',
    expectedState: 'session_ready',
    expectedFocus: 'session_0',
    steps: ['load_nas_sessions', 'append_placeholder', 'verify_session_count']
  },
  {
    id: 'nas_021',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_5',
    action: 'load_five_sessions',
    expectedState: 'session_ready',
    expectedFocus: 'session_0',
    steps: ['load_nas_sessions', 'append_placeholder', 'verify_session_count']
  },
  {
    id: 'nas_022',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'session_left_navigation',
    expectedState: 'session_grid_ready',
    expectedFocus: 'session_0',
    steps: ['focus_session1', 'press_left', 'verify_session0_focus']
  },
  {
    id: 'nas_023',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_1',
    action: 'session_right_navigation',
    expectedState: 'session_grid_ready',
    expectedFocus: 'session_1',
    steps: ['focus_session0', 'press_right', 'verify_session1_focus']
  },
  {
    id: 'nas_024',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_5',
    action: 'session_down_navigation',
    expectedState: 'session_grid_ready',
    expectedFocus: 'session_5',
    steps: ['focus_session0', 'press_down', 'verify_session5_focus']
  },
  {
    id: 'nas_025',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_1',
    action: 'session_up_navigation',
    expectedState: 'session_grid_ready',
    expectedFocus: 'session_1',
    steps: ['focus_session6', 'press_up', 'verify_session1_focus']
  },
  {
    id: 'nas_026',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'enter_real_session',
    expectedState: 'photo_list_ready',
    expectedFocus: 'session_0',
    steps: ['focus_real_session', 'press_enter', 'verify_photo_list_route']
  },
  {
    id: 'nas_027',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'center_real_session',
    expectedState: 'photo_list_ready',
    expectedFocus: 'session_0',
    steps: ['focus_real_session', 'press_center', 'verify_photo_list_route']
  },
  {
    id: 'nas_028',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'enter_placeholder_session',
    expectedState: 'nas_client_ready',
    expectedFocus: 'session_0',
    steps: ['focus_placeholder_session', 'press_enter', 'verify_nas_client_route']
  },
  {
    id: 'nas_029',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'center_placeholder_session',
    expectedState: 'nas_client_ready',
    expectedFocus: 'session_0',
    steps: ['focus_placeholder_session', 'press_center', 'verify_nas_client_route']
  },
  {
    id: 'nas_030',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'focus_first_session_tile',
    expectedState: 'focus_ready',
    expectedFocus: 'session_0',
    steps: ['allow_session0_focus', 'request_session0_focus', 'verify_session0_focus']
  },
  {
    id: 'nas_031',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_3',
    action: 'focus_middle_session_tile',
    expectedState: 'focus_ready',
    expectedFocus: 'session_3',
    steps: ['allow_session3_focus', 'request_session3_focus', 'verify_session3_focus']
  },
  {
    id: 'nas_032',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_6',
    action: 'focus_last_session_tile',
    expectedState: 'focus_ready',
    expectedFocus: 'session_6',
    steps: ['allow_session6_focus', 'request_session6_focus', 'verify_session6_focus']
  },
  {
    id: 'nas_033',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_2',
    action: 'retry_focus_exhausted',
    expectedState: 'focus_failed',
    expectedFocus: 'session_0',
    steps: ['deny_session2_focus', 'retry_focus_request', 'verify_default_focus']
  },
  {
    id: 'nas_034',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_5',
    action: 'retry_focus_exhausted_again',
    expectedState: 'focus_failed',
    expectedFocus: 'session_0',
    steps: ['deny_session5_focus', 'retry_focus_request', 'verify_default_focus']
  },
  {
    id: 'nas_035',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'page_show_hide_once',
    expectedState: 'callback_stable',
    expectedFocus: 'session_0',
    steps: ['page_show', 'page_hide', 'verify_callback_count']
  },
  {
    id: 'nas_036',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'page_show_hide_twice',
    expectedState: 'callback_stable',
    expectedFocus: 'session_0',
    steps: ['page_show_twice', 'page_hide_twice', 'verify_callback_count']
  },
  {
    id: 'nas_037',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'record_focus_history_first_client',
    expectedState: 'focus_ready',
    expectedFocus: 'client_0',
    steps: ['request_client0_focus', 'record_focus_history', 'verify_history_head']
  },
  {
    id: 'nas_038',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_3',
    action: 'record_focus_history_middle_client',
    expectedState: 'focus_ready',
    expectedFocus: 'client_3',
    steps: ['request_client3_focus', 'record_focus_history', 'verify_history_head']
  },
  {
    id: 'nas_039',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_6',
    action: 'record_focus_history_last_client',
    expectedState: 'focus_ready',
    expectedFocus: 'client_6',
    steps: ['request_client6_focus', 'record_focus_history', 'verify_history_head']
  },
  {
    id: 'nas_040',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'complete_nas_matrix',
    expectedState: 'matrix_ready',
    expectedFocus: 'session_0',
    steps: ['load_nas_matrix', 'iterate_nas_cases', 'verify_matrix_size']
  }
];

const HOME_EXPANSION_SCENARIOS: BusinessScenario[] = [
  {
    id: 'home_041',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'restore_picture_focus_after_dialog',
    expectedState: 'focus_restored',
    expectedFocus: 'menu0',
    steps: [
      'open_picture_dialog',
      'dismiss_picture_dialog',
      'verify_menu0_focus'
    ]
  },
  {
    id: 'home_042',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'restore_album_focus_after_dialog',
    expectedState: 'focus_restored',
    expectedFocus: 'menu1',
    steps: [
      'open_album_dialog',
      'dismiss_album_dialog',
      'verify_menu1_focus'
    ]
  },
  {
    id: 'home_043',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'restore_distributed_focus_after_dialog',
    expectedState: 'focus_restored',
    expectedFocus: 'menu2',
    steps: [
      'open_distributed_dialog',
      'dismiss_distributed_dialog',
      'verify_menu2_focus'
    ]
  },
  {
    id: 'home_044',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_reenter_after_back',
    expectedState: 'picture_ready',
    expectedFocus: 'menu0',
    steps: [
      'enter_picture_tab',
      'invoke_back_action',
      'verify_menu0_focus'
    ]
  },
  {
    id: 'home_045',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_tab_reenter_after_back',
    expectedState: 'album_ready',
    expectedFocus: 'menu1',
    steps: [
      'enter_album_tab',
      'invoke_back_action',
      'verify_menu1_focus'
    ]
  },
  {
    id: 'home_046',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_tab_reenter_after_back',
    expectedState: 'distributed_ready',
    expectedFocus: 'menu2',
    steps: [
      'enter_distributed_tab',
      'invoke_back_action',
      'verify_menu2_focus'
    ]
  },
  {
    id: 'home_047',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_refresh_after_reload',
    expectedState: 'picture_refreshed',
    expectedFocus: 'menu0',
    steps: [
      'load_picture_tab',
      'trigger_picture_reload',
      'verify_picture_refreshed'
    ]
  },
  {
    id: 'home_048',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_tab_refresh_after_reload',
    expectedState: 'album_refreshed',
    expectedFocus: 'menu1',
    steps: [
      'load_album_tab',
      'trigger_album_reload',
      'verify_album_refreshed'
    ]
  },
  {
    id: 'home_049',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_tab_refresh_after_reload',
    expectedState: 'distributed_refreshed',
    expectedFocus: 'menu2',
    steps: [
      'load_distributed_tab',
      'trigger_distributed_reload',
      'verify_distributed_refreshed'
    ]
  },
  {
    id: 'home_050',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_focus_from_boot',
    expectedState: 'boot_ready',
    expectedFocus: 'menu0',
    steps: [
      'boot_entry_ability',
      'resolve_picture_default',
      'verify_menu0_focus'
    ]
  },
  {
    id: 'home_051',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_tab_focus_from_boot',
    expectedState: 'boot_ready',
    expectedFocus: 'menu1',
    steps: [
      'boot_entry_ability',
      'resolve_album_default',
      'verify_menu1_focus'
    ]
  },
  {
    id: 'home_052',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_tab_focus_from_boot',
    expectedState: 'boot_ready',
    expectedFocus: 'menu2',
    steps: [
      'boot_entry_ability',
      'resolve_distributed_default',
      'verify_menu2_focus'
    ]
  },
  {
    id: 'home_053',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_shortcut_open_menu',
    expectedState: 'shortcut_ready',
    expectedFocus: 'dialog2',
    steps: [
      'focus_picture_root',
      'press_shortcut_key',
      'verify_dialog2_focus'
    ]
  },
  {
    id: 'home_054',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_shortcut_open_menu',
    expectedState: 'shortcut_ready',
    expectedFocus: 'dialog2',
    steps: [
      'focus_album_root',
      'press_shortcut_key',
      'verify_dialog2_focus'
    ]
  },
  {
    id: 'home_055',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_shortcut_open_menu',
    expectedState: 'shortcut_ready',
    expectedFocus: 'dfs_dialog_confirm',
    steps: [
      'focus_distributed_root',
      'press_shortcut_key',
      'verify_dfs_dialog_focus'
    ]
  },
  {
    id: 'home_056',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_label_cache',
    expectedState: 'labels_ready',
    expectedFocus: 'menu0',
    steps: [
      'load_picture_labels',
      'cache_picture_label',
      'verify_picture_label'
    ]
  },
  {
    id: 'home_057',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_tab_label_cache',
    expectedState: 'labels_ready',
    expectedFocus: 'menu1',
    steps: [
      'load_album_labels',
      'cache_album_label',
      'verify_album_label'
    ]
  },
  {
    id: 'home_058',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_tab_label_cache',
    expectedState: 'labels_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_distributed_labels',
      'cache_distributed_label',
      'verify_distributed_label'
    ]
  },
  {
    id: 'home_059',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_history_restore',
    expectedState: 'history_ready',
    expectedFocus: 'menu0',
    steps: [
      'store_picture_history',
      'restore_picture_history',
      'verify_menu0_focus'
    ]
  },
  {
    id: 'home_060',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_tab_history_restore',
    expectedState: 'history_ready',
    expectedFocus: 'menu1',
    steps: [
      'store_album_history',
      'restore_album_history',
      'verify_menu1_focus'
    ]
  },
  {
    id: 'home_061',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_tab_history_restore',
    expectedState: 'history_ready',
    expectedFocus: 'menu2',
    steps: [
      'store_distributed_history',
      'restore_distributed_history',
      'verify_menu2_focus'
    ]
  },
  {
    id: 'home_062',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_to_album_roundtrip',
    expectedState: 'album_ready',
    expectedFocus: 'menu1',
    steps: [
      'focus_menu0',
      'press_right',
      'verify_menu1_focus'
    ]
  },
  {
    id: 'home_063',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_to_distributed_roundtrip',
    expectedState: 'distributed_ready',
    expectedFocus: 'menu2',
    steps: [
      'focus_menu1',
      'press_right',
      'verify_menu2_focus'
    ]
  },
  {
    id: 'home_064',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_to_picture_roundtrip',
    expectedState: 'picture_ready',
    expectedFocus: 'menu0',
    steps: [
      'focus_menu2',
      'press_left_twice',
      'verify_menu0_focus'
    ]
  },
  {
    id: 'home_065',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_driver_delay_contract',
    expectedState: 'driver_ready',
    expectedFocus: 'menu0',
    steps: [
      'load_picture_driver',
      'record_picture_delay',
      'verify_delay_sequence'
    ]
  },
  {
    id: 'home_066',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_tab_driver_delay_contract',
    expectedState: 'driver_ready',
    expectedFocus: 'menu1',
    steps: [
      'load_album_driver',
      'record_album_delay',
      'verify_delay_sequence'
    ]
  },
  {
    id: 'home_067',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_tab_driver_delay_contract',
    expectedState: 'driver_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_distributed_driver',
      'record_distributed_delay',
      'verify_delay_sequence'
    ]
  },
  {
    id: 'home_068',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_focus_ring_contract',
    expectedState: 'focus_ring_ready',
    expectedFocus: 'menu0',
    steps: [
      'build_picture_focus_ring',
      'focus_menu0',
      'verify_focus_ring_head'
    ]
  },
  {
    id: 'home_069',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_tab_focus_ring_contract',
    expectedState: 'focus_ring_ready',
    expectedFocus: 'menu1',
    steps: [
      'build_album_focus_ring',
      'focus_menu1',
      'verify_focus_ring_head'
    ]
  },
  {
    id: 'home_070',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_tab_focus_ring_contract',
    expectedState: 'focus_ring_ready',
    expectedFocus: 'menu2',
    steps: [
      'build_distributed_focus_ring',
      'focus_menu2',
      'verify_focus_ring_head'
    ]
  },
  {
    id: 'home_071',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_candidate_rebuild',
    expectedState: 'candidate_ready',
    expectedFocus: 'menu0',
    steps: [
      'build_picture_candidates',
      'rebuild_picture_candidates',
      'verify_candidate_order'
    ]
  },
  {
    id: 'home_072',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu1',
    action: 'album_tab_candidate_rebuild',
    expectedState: 'candidate_ready',
    expectedFocus: 'menu1',
    steps: [
      'build_album_candidates',
      'rebuild_album_candidates',
      'verify_candidate_order'
    ]
  },
  {
    id: 'home_073',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_tab_candidate_rebuild',
    expectedState: 'candidate_ready',
    expectedFocus: 'menu2',
    steps: [
      'build_distributed_candidates',
      'rebuild_distributed_candidates',
      'verify_candidate_order'
    ]
  },
  {
    id: 'home_074',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'picture_tab_state_snapshot',
    expectedState: 'snapshot_ready',
    expectedFocus: 'menu0',
    steps: [
      'capture_picture_snapshot',
      'persist_picture_snapshot',
      'verify_snapshot_state'
    ]
  },
  {
    id: 'home_075',
    domain: '首页流程',
    ability: 'EntryAbility',
    entry: 'menu0',
    action: 'home_complete_focus_matrix',
    expectedState: 'matrix_ready',
    expectedFocus: 'menu0',
    steps: [
      'load_home_focus_matrix',
      'iterate_home_focus_cases',
      'verify_matrix_size'
    ]
  }
];

const ALBUM_EXPANSION_SCENARIOS: BusinessScenario[] = [
  {
    id: 'album_041',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'reopen_all_album_after_back',
    expectedState: 'photo_list_ready',
    expectedFocus: 'album0',
    steps: [
      'open_all_album',
      'invoke_back_action',
      'verify_album0_focus'
    ]
  },
  {
    id: 'album_042',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'reopen_favorite_album_after_back',
    expectedState: 'photo_list_ready',
    expectedFocus: 'album1',
    steps: [
      'open_favorite_album',
      'invoke_back_action',
      'verify_album1_focus'
    ]
  },
  {
    id: 'album_043',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'reopen_screenshot_album_after_back',
    expectedState: 'photo_list_ready',
    expectedFocus: 'album2',
    steps: [
      'open_screenshot_album',
      'invoke_back_action',
      'verify_album2_focus'
    ]
  },
  {
    id: 'album_044',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'reopen_trash_album_after_back',
    expectedState: 'photo_list_ready',
    expectedFocus: 'album3',
    steps: [
      'open_trash_album',
      'invoke_back_action',
      'verify_album3_focus'
    ]
  },
  {
    id: 'album_045',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'reopen_nas_album_after_back',
    expectedState: 'photo_list_ready',
    expectedFocus: 'album4',
    steps: [
      'open_nas_album',
      'invoke_back_action',
      'verify_album4_focus'
    ]
  },
  {
    id: 'album_046',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'all_album_focus_boundary_left',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album0',
    steps: [
      'focus_album0',
      'press_left',
      'verify_album0_focus'
    ]
  },
  {
    id: 'album_047',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'favorite_album_focus_boundary_left',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album1',
    steps: [
      'focus_album1',
      'press_left',
      'verify_left_boundary'
    ]
  },
  {
    id: 'album_048',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'trash_album_focus_boundary_right',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album3',
    steps: [
      'focus_album3',
      'press_right',
      'verify_right_boundary'
    ]
  },
  {
    id: 'album_049',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'nas_album_focus_boundary_right',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album4',
    steps: [
      'focus_album4',
      'press_right',
      'verify_album4_focus'
    ]
  },
  {
    id: 'album_050',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'all_album_vertical_down',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album3',
    steps: [
      'focus_album0',
      'press_down',
      'verify_album3_focus'
    ]
  },
  {
    id: 'album_051',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'favorite_album_vertical_down',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album4',
    steps: [
      'focus_album1',
      'press_down',
      'verify_album4_focus'
    ]
  },
  {
    id: 'album_052',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'trash_album_vertical_up',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album0',
    steps: [
      'focus_album3',
      'press_up',
      'verify_album0_focus'
    ]
  },
  {
    id: 'album_053',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'nas_album_vertical_up',
    expectedState: 'album_grid_ready',
    expectedFocus: 'album1',
    steps: [
      'focus_album4',
      'press_up',
      'verify_album1_focus'
    ]
  },
  {
    id: 'album_054',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'all_album_open_menu',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: [
      'focus_album0',
      'press_shortcut_key',
      'verify_dialog2_focus'
    ]
  },
  {
    id: 'album_055',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'favorite_album_open_menu',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: [
      'focus_album1',
      'press_shortcut_key',
      'verify_dialog2_focus'
    ]
  },
  {
    id: 'album_056',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'trash_album_open_menu',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: [
      'focus_album3',
      'press_shortcut_key',
      'verify_dialog2_focus'
    ]
  },
  {
    id: 'album_057',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'nas_album_open_menu',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: [
      'focus_album4',
      'press_shortcut_key',
      'verify_dialog2_focus'
    ]
  },
  {
    id: 'album_058',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'all_album_cover_refresh',
    expectedState: 'album_cover_ready',
    expectedFocus: 'album0',
    steps: [
      'load_all_album_cover',
      'refresh_album_cover',
      'verify_cover_ready'
    ]
  },
  {
    id: 'album_059',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'favorite_album_cover_refresh',
    expectedState: 'album_cover_ready',
    expectedFocus: 'album1',
    steps: [
      'load_favorite_cover',
      'refresh_album_cover',
      'verify_cover_ready'
    ]
  },
  {
    id: 'album_060',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'screenshot_album_cover_refresh',
    expectedState: 'album_cover_ready',
    expectedFocus: 'album2',
    steps: [
      'load_screenshot_cover',
      'refresh_album_cover',
      'verify_cover_ready'
    ]
  },
  {
    id: 'album_061',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'trash_album_cover_refresh',
    expectedState: 'album_cover_ready',
    expectedFocus: 'album3',
    steps: [
      'load_trash_cover',
      'refresh_album_cover',
      'verify_cover_ready'
    ]
  },
  {
    id: 'album_062',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'nas_album_cover_refresh',
    expectedState: 'album_cover_ready',
    expectedFocus: 'album4',
    steps: [
      'load_nas_cover',
      'refresh_album_cover',
      'verify_cover_ready'
    ]
  },
  {
    id: 'album_063',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'all_album_photo_count_sync',
    expectedState: 'album_count_ready',
    expectedFocus: 'album0',
    steps: [
      'load_all_album_count',
      'sync_album_count',
      'verify_count_ready'
    ]
  },
  {
    id: 'album_064',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'favorite_album_photo_count_sync',
    expectedState: 'album_count_ready',
    expectedFocus: 'album1',
    steps: [
      'load_favorite_count',
      'sync_album_count',
      'verify_count_ready'
    ]
  },
  {
    id: 'album_065',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album2',
    action: 'screenshot_album_photo_count_sync',
    expectedState: 'album_count_ready',
    expectedFocus: 'album2',
    steps: [
      'load_screenshot_count',
      'sync_album_count',
      'verify_count_ready'
    ]
  },
  {
    id: 'album_066',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'trash_album_photo_count_sync',
    expectedState: 'album_count_ready',
    expectedFocus: 'album3',
    steps: [
      'load_trash_count',
      'sync_album_count',
      'verify_count_ready'
    ]
  },
  {
    id: 'album_067',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'nas_album_photo_count_sync',
    expectedState: 'album_count_ready',
    expectedFocus: 'album4',
    steps: [
      'load_nas_count',
      'sync_album_count',
      'verify_count_ready'
    ]
  },
  {
    id: 'album_068',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_grid_focus_restore_all',
    expectedState: 'focus_restored',
    expectedFocus: 'album0',
    steps: [
      'store_album0_focus',
      'restore_album_focus',
      'verify_album0_focus'
    ]
  },
  {
    id: 'album_069',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'album_grid_focus_restore_favorite',
    expectedState: 'focus_restored',
    expectedFocus: 'album1',
    steps: [
      'store_album1_focus',
      'restore_album_focus',
      'verify_album1_focus'
    ]
  },
  {
    id: 'album_070',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'album_grid_focus_restore_trash',
    expectedState: 'focus_restored',
    expectedFocus: 'album3',
    steps: [
      'store_album3_focus',
      'restore_album_focus',
      'verify_album3_focus'
    ]
  },
  {
    id: 'album_071',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album4',
    action: 'album_grid_focus_restore_nas',
    expectedState: 'focus_restored',
    expectedFocus: 'album4',
    steps: [
      'store_album4_focus',
      'restore_album_focus',
      'verify_album4_focus'
    ]
  },
  {
    id: 'album_072',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_route_history_all',
    expectedState: 'route_ready',
    expectedFocus: 'album0',
    steps: [
      'open_all_album_route',
      'record_route_history',
      'verify_route_history'
    ]
  },
  {
    id: 'album_073',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album1',
    action: 'album_route_history_favorite',
    expectedState: 'route_ready',
    expectedFocus: 'album1',
    steps: [
      'open_favorite_route',
      'record_route_history',
      'verify_route_history'
    ]
  },
  {
    id: 'album_074',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album3',
    action: 'album_route_history_trash',
    expectedState: 'route_ready',
    expectedFocus: 'album3',
    steps: [
      'open_trash_route',
      'record_route_history',
      'verify_route_history'
    ]
  },
  {
    id: 'album_075',
    domain: '相册导航',
    ability: 'EntryAbility',
    entry: 'album0',
    action: 'album_complete_navigation_matrix',
    expectedState: 'matrix_ready',
    expectedFocus: 'album0',
    steps: [
      'load_album_navigation_matrix',
      'iterate_album_navigation_cases',
      'verify_matrix_size'
    ]
  }
];

const DISTRIBUTED_EXPANSION_SCENARIOS: BusinessScenario[] = [
  {
    id: 'distributed_041',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_device_list_refresh',
    expectedState: 'device_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_device_list',
      'refresh_device_list',
      'verify_device_state'
    ]
  },
  {
    id: 'distributed_042',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_device_name_empty',
    expectedState: 'device_empty',
    expectedFocus: 'menu2',
    steps: [
      'load_empty_devices',
      'clear_device_name',
      'verify_empty_name'
    ]
  },
  {
    id: 'distributed_043',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_device_name_restore',
    expectedState: 'device_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_named_devices',
      'restore_device_name',
      'verify_device_name'
    ]
  },
  {
    id: 'distributed_044',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_receive_popup_prepare',
    expectedState: 'receive_ready',
    expectedFocus: 'receive1',
    steps: [
      'load_receive_payload',
      'open_receive_popup',
      'verify_receive_focus'
    ]
  },
  {
    id: 'distributed_045',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_receive_popup_summary',
    expectedState: 'receive_ready',
    expectedFocus: 'receive1',
    steps: [
      'build_receive_summary',
      'show_receive_popup',
      'verify_receive_summary'
    ]
  },
  {
    id: 'distributed_046',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_receive_progress_10',
    expectedState: 'progress_ready',
    expectedFocus: 'receive1',
    steps: [
      'load_receive_progress',
      'set_progress_10',
      'verify_progress_value'
    ]
  },
  {
    id: 'distributed_047',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_receive_progress_50',
    expectedState: 'progress_ready',
    expectedFocus: 'receive1',
    steps: [
      'load_receive_progress',
      'set_progress_50',
      'verify_progress_value'
    ]
  },
  {
    id: 'distributed_048',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_receive_progress_100',
    expectedState: 'progress_ready',
    expectedFocus: 'menu0',
    steps: [
      'load_receive_progress',
      'set_progress_100',
      'verify_progress_completion'
    ]
  },
  {
    id: 'distributed_049',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_close_wifi_after_finish',
    expectedState: 'wifi_closed',
    expectedFocus: 'menu0',
    steps: [
      'open_receive_overlay',
      'close_wifi_connection',
      'verify_wifi_closed'
    ]
  },
  {
    id: 'distributed_050',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_ignore_unknown_state',
    expectedState: 'state_ignored',
    expectedFocus: 'menu2',
    steps: [
      'load_unknown_state',
      'ignore_unknown_state',
      'verify_state_unchanged'
    ]
  },
  {
    id: 'distributed_051',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_focus_restore_after_dfs_dialog',
    expectedState: 'focus_restored',
    expectedFocus: 'menu2',
    steps: [
      'open_dfs_dialog',
      'dismiss_dfs_dialog',
      'verify_menu2_focus'
    ]
  },
  {
    id: 'distributed_052',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_route_to_device_manage',
    expectedState: 'route_ready',
    expectedFocus: 'menu2',
    steps: [
      'open_device_manage',
      'record_route_target',
      'verify_route_target'
    ]
  },
  {
    id: 'distributed_053',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_cancel_to_dfs_dialog',
    expectedState: 'dialog_closed',
    expectedFocus: 'menu2',
    steps: [
      'open_dfs_dialog',
      'cancel_dfs_dialog',
      'verify_menu2_focus'
    ]
  },
  {
    id: 'distributed_054',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_confirm_to_dfs_dialog',
    expectedState: 'route_ready',
    expectedFocus: 'menu2',
    steps: [
      'open_dfs_dialog',
      'confirm_dfs_dialog',
      'verify_dfs_route'
    ]
  },
  {
    id: 'distributed_055',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_select_first_device',
    expectedState: 'device_selected',
    expectedFocus: 'device_0',
    steps: [
      'load_device_grid',
      'focus_first_device',
      'verify_device_0_focus'
    ]
  },
  {
    id: 'distributed_056',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_select_last_device',
    expectedState: 'device_selected',
    expectedFocus: 'device_7',
    steps: [
      'load_device_grid',
      'focus_last_device',
      'verify_last_device_focus'
    ]
  },
  {
    id: 'distributed_057',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_device_grid_left_boundary',
    expectedState: 'device_grid_ready',
    expectedFocus: 'device_0',
    steps: [
      'focus_device_0',
      'press_left',
      'verify_left_boundary'
    ]
  },
  {
    id: 'distributed_058',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_device_grid_right_boundary',
    expectedState: 'device_grid_ready',
    expectedFocus: 'device_7',
    steps: [
      'focus_device_7',
      'press_right',
      'verify_right_boundary'
    ]
  },
  {
    id: 'distributed_059',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_device_grid_up_boundary',
    expectedState: 'device_grid_ready',
    expectedFocus: 'device_1',
    steps: [
      'focus_device_1',
      'press_up',
      'verify_up_boundary'
    ]
  },
  {
    id: 'distributed_060',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_device_grid_down_boundary',
    expectedState: 'device_grid_ready',
    expectedFocus: 'device_6',
    steps: [
      'focus_device_6',
      'press_down',
      'verify_down_boundary'
    ]
  },
  {
    id: 'distributed_061',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_receive_back_to_menu',
    expectedState: 'overlay_closed',
    expectedFocus: 'menu0',
    steps: [
      'open_receive_overlay',
      'press_back',
      'verify_menu0_focus'
    ]
  },
  {
    id: 'distributed_062',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_delete_back_to_menu',
    expectedState: 'overlay_closed',
    expectedFocus: 'menu0',
    steps: [
      'open_delete_overlay',
      'press_back',
      'verify_menu0_focus'
    ]
  },
  {
    id: 'distributed_063',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_overlay_priority_receive',
    expectedState: 'overlay_ready',
    expectedFocus: 'menu0',
    steps: [
      'open_receive_overlay',
      'resolve_overlay_priority',
      'verify_receive_priority'
    ]
  },
  {
    id: 'distributed_064',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_overlay_priority_device',
    expectedState: 'overlay_ready',
    expectedFocus: 'menu0',
    steps: [
      'open_device_overlay',
      'resolve_overlay_priority',
      'verify_device_priority'
    ]
  },
  {
    id: 'distributed_065',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_overlay_priority_delete',
    expectedState: 'overlay_ready',
    expectedFocus: 'menu0',
    steps: [
      'open_delete_overlay',
      'resolve_overlay_priority',
      'verify_delete_priority'
    ]
  },
  {
    id: 'distributed_066',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_shortcut_from_root',
    expectedState: 'dialog_ready',
    expectedFocus: 'dfs_dialog_confirm',
    steps: [
      'focus_distributed_root',
      'press_shortcut_key',
      'verify_dfs_dialog_focus'
    ]
  },
  {
    id: 'distributed_067',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_shortcut_from_grid',
    expectedState: 'dialog_ready',
    expectedFocus: 'dialog2',
    steps: [
      'focus_distributed_grid',
      'press_shortcut_key',
      'verify_dialog2_focus'
    ]
  },
  {
    id: 'distributed_068',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_shortcut_dialog_locked',
    expectedState: 'dialog_locked',
    expectedFocus: 'dialog2',
    steps: [
      'open_existing_dialog',
      'press_shortcut_key',
      'verify_dialog_unchanged'
    ]
  },
  {
    id: 'distributed_069',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_session_album_metadata',
    expectedState: 'metadata_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_session_models',
      'build_album_metadata',
      'verify_metadata_ready'
    ]
  },
  {
    id: 'distributed_070',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_device_count_sync',
    expectedState: 'device_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_device_count',
      'sync_device_count',
      'verify_device_count'
    ]
  },
  {
    id: 'distributed_071',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_receive_type_picture',
    expectedState: 'receive_ready',
    expectedFocus: 'receive1',
    steps: [
      'load_picture_payload',
      'render_receive_popup',
      'verify_picture_label'
    ]
  },
  {
    id: 'distributed_072',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_receive_type_video',
    expectedState: 'receive_ready',
    expectedFocus: 'receive1',
    steps: [
      'load_video_payload',
      'render_receive_popup',
      'verify_video_label'
    ]
  },
  {
    id: 'distributed_073',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_size_label_kb',
    expectedState: 'size_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_small_file_size',
      'format_receive_size',
      'verify_kb_label'
    ]
  },
  {
    id: 'distributed_074',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_size_label_mb',
    expectedState: 'size_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_large_file_size',
      'format_receive_size',
      'verify_mb_label'
    ]
  },
  {
    id: 'distributed_075',
    domain: '分布式流程',
    ability: 'EntryAbility',
    entry: 'menu2',
    action: 'distributed_complete_reception_matrix',
    expectedState: 'matrix_ready',
    expectedFocus: 'menu2',
    steps: [
      'load_receive_matrix',
      'iterate_receive_cases',
      'verify_matrix_size'
    ]
  }
];

const NAS_EXPANSION_SCENARIOS: BusinessScenario[] = [
  {
    id: 'nas_041',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_client_refresh_after_scan',
    expectedState: 'client_ready',
    expectedFocus: 'client_0',
    steps: [
      'scan_nas_clients',
      'refresh_client_list',
      'verify_client_focus'
    ]
  },
  {
    id: 'nas_042',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_client_refresh_after_retry',
    expectedState: 'client_ready',
    expectedFocus: 'client_0',
    steps: [
      'retry_nas_scan',
      'refresh_client_list',
      'verify_client_focus'
    ]
  },
  {
    id: 'nas_043',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'nas_login_success_restore_focus',
    expectedState: 'login_ready',
    expectedFocus: 'client_1',
    steps: [
      'open_login_dialog',
      'submit_valid_credentials',
      'verify_client1_focus'
    ]
  },
  {
    id: 'nas_044',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'nas_login_failure_keep_focus',
    expectedState: 'login_failed',
    expectedFocus: 'client_1',
    steps: [
      'open_login_dialog',
      'submit_invalid_credentials',
      'verify_client1_focus'
    ]
  },
  {
    id: 'nas_045',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_2',
    action: 'nas_mount_success_route_album',
    expectedState: 'mount_ready',
    expectedFocus: 'client_2',
    steps: [
      'request_mount_client2',
      'open_nas_album_route',
      'verify_mount_success'
    ]
  },
  {
    id: 'nas_046',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_2',
    action: 'nas_mount_failure_keep_client',
    expectedState: 'mount_failed',
    expectedFocus: 'client_2',
    steps: [
      'request_mount_client2',
      'simulate_mount_failure',
      'verify_client2_focus'
    ]
  },
  {
    id: 'nas_047',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_logout_restore_client_list',
    expectedState: 'client_ready',
    expectedFocus: 'client_0',
    steps: [
      'open_client_session',
      'logout_current_client',
      'verify_client_list'
    ]
  },
  {
    id: 'nas_048',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_3',
    action: 'nas_dialog_cancel_restore_focus',
    expectedState: 'dialog_closed',
    expectedFocus: 'client_3',
    steps: [
      'open_client_dialog',
      'cancel_client_dialog',
      'verify_client3_focus'
    ]
  },
  {
    id: 'nas_049',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_3',
    action: 'nas_dialog_confirm_restore_focus',
    expectedState: 'dialog_closed',
    expectedFocus: 'client_3',
    steps: [
      'open_client_dialog',
      'confirm_client_dialog',
      'verify_client3_focus'
    ]
  },
  {
    id: 'nas_050',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_first_client_boundary_left',
    expectedState: 'focus_ready',
    expectedFocus: 'client_0',
    steps: [
      'focus_client0',
      'press_left',
      'verify_left_boundary'
    ]
  },
  {
    id: 'nas_051',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_6',
    action: 'nas_last_client_boundary_right',
    expectedState: 'focus_ready',
    expectedFocus: 'client_6',
    steps: [
      'focus_client6',
      'press_right',
      'verify_right_boundary'
    ]
  },
  {
    id: 'nas_052',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_grid_move_down',
    expectedState: 'focus_ready',
    expectedFocus: 'client_3',
    steps: [
      'focus_client0',
      'press_down',
      'verify_client3_focus'
    ]
  },
  {
    id: 'nas_053',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_3',
    action: 'nas_grid_move_up',
    expectedState: 'focus_ready',
    expectedFocus: 'client_0',
    steps: [
      'focus_client3',
      'press_up',
      'verify_client0_focus'
    ]
  },
  {
    id: 'nas_054',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_4',
    action: 'nas_grid_move_left',
    expectedState: 'focus_ready',
    expectedFocus: 'client_3',
    steps: [
      'focus_client4',
      'press_left',
      'verify_client3_focus'
    ]
  },
  {
    id: 'nas_055',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_4',
    action: 'nas_grid_move_right',
    expectedState: 'focus_ready',
    expectedFocus: 'client_5',
    steps: [
      'focus_client4',
      'press_right',
      'verify_client5_focus'
    ]
  },
  {
    id: 'nas_056',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'nas_password_mask_render',
    expectedState: 'dialog_ready',
    expectedFocus: 'client_1',
    steps: [
      'open_password_dialog',
      'render_password_mask',
      'verify_mask_state'
    ]
  },
  {
    id: 'nas_057',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'nas_username_cache_restore',
    expectedState: 'dialog_ready',
    expectedFocus: 'client_1',
    steps: [
      'cache_username_value',
      'restore_username_value',
      'verify_username_value'
    ]
  },
  {
    id: 'nas_058',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'nas_share_list_refresh',
    expectedState: 'share_ready',
    expectedFocus: 'session_0',
    steps: [
      'load_share_list',
      'refresh_share_list',
      'verify_share_state'
    ]
  },
  {
    id: 'nas_059',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'nas_session_list_refresh',
    expectedState: 'session_ready',
    expectedFocus: 'session_0',
    steps: [
      'load_session_list',
      'refresh_session_list',
      'verify_session_state'
    ]
  },
  {
    id: 'nas_060',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'nas_session_cover_sync',
    expectedState: 'session_ready',
    expectedFocus: 'session_0',
    steps: [
      'load_session_cover',
      'sync_session_cover',
      'verify_session_cover'
    ]
  },
  {
    id: 'nas_061',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'nas_session_count_sync',
    expectedState: 'session_ready',
    expectedFocus: 'session_0',
    steps: [
      'load_session_count',
      'sync_session_count',
      'verify_session_count'
    ]
  },
  {
    id: 'nas_062',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'nas_album_route_open',
    expectedState: 'route_ready',
    expectedFocus: 'session_0',
    steps: [
      'open_nas_album_route',
      'record_route_state',
      'verify_route_state'
    ]
  },
  {
    id: 'nas_063',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'session_0',
    action: 'nas_album_route_back',
    expectedState: 'route_ready',
    expectedFocus: 'client_0',
    steps: [
      'open_nas_album_route',
      'invoke_back_action',
      'verify_client0_focus'
    ]
  },
  {
    id: 'nas_064',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_focus_history_first',
    expectedState: 'focus_ready',
    expectedFocus: 'client_0',
    steps: [
      'request_client0_focus',
      'record_focus_history',
      'verify_history_head'
    ]
  },
  {
    id: 'nas_065',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_3',
    action: 'nas_focus_history_middle',
    expectedState: 'focus_ready',
    expectedFocus: 'client_3',
    steps: [
      'request_client3_focus',
      'record_focus_history',
      'verify_history_head'
    ]
  },
  {
    id: 'nas_066',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_6',
    action: 'nas_focus_history_last',
    expectedState: 'focus_ready',
    expectedFocus: 'client_6',
    steps: [
      'request_client6_focus',
      'record_focus_history',
      'verify_history_head'
    ]
  },
  {
    id: 'nas_067',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_empty_client_state',
    expectedState: 'client_empty',
    expectedFocus: 'client_0',
    steps: [
      'load_empty_clients',
      'render_empty_state',
      'verify_empty_state'
    ]
  },
  {
    id: 'nas_068',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_1',
    action: 'nas_multi_client_state',
    expectedState: 'client_ready',
    expectedFocus: 'client_0',
    steps: [
      'load_multi_clients',
      'render_client_grid',
      'verify_client_grid'
    ]
  },
  {
    id: 'nas_069',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_loading_state_transition',
    expectedState: 'loading_ready',
    expectedFocus: 'client_0',
    steps: [
      'load_loading_state',
      'resolve_loading_state',
      'verify_loading_transition'
    ]
  },
  {
    id: 'nas_070',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_retry_state_transition',
    expectedState: 'retry_ready',
    expectedFocus: 'client_0',
    steps: [
      'load_retry_state',
      'resolve_retry_state',
      'verify_retry_transition'
    ]
  },
  {
    id: 'nas_071',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_disconnect_state_transition',
    expectedState: 'disconnect_ready',
    expectedFocus: 'client_0',
    steps: [
      'load_disconnect_state',
      'resolve_disconnect_state',
      'verify_disconnect_transition'
    ]
  },
  {
    id: 'nas_072',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_2',
    action: 'nas_error_banner_contract',
    expectedState: 'banner_ready',
    expectedFocus: 'client_2',
    steps: [
      'open_error_banner',
      'render_error_banner',
      'verify_banner_state'
    ]
  },
  {
    id: 'nas_073',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_2',
    action: 'nas_success_banner_contract',
    expectedState: 'banner_ready',
    expectedFocus: 'client_2',
    steps: [
      'open_success_banner',
      'render_success_banner',
      'verify_banner_state'
    ]
  },
  {
    id: 'nas_074',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_2',
    action: 'nas_focus_after_mount',
    expectedState: 'mount_ready',
    expectedFocus: 'client_2',
    steps: [
      'mount_nas_client',
      'restore_client_focus',
      'verify_client2_focus'
    ]
  },
  {
    id: 'nas_075',
    domain: 'NAS 流程',
    ability: 'EntryAbility',
    entry: 'client_0',
    action: 'nas_complete_client_matrix',
    expectedState: 'matrix_ready',
    expectedFocus: 'client_0',
    steps: [
      'load_nas_client_matrix',
      'iterate_nas_client_cases',
      'verify_matrix_size'
    ]
  }
];

const BUSINESS_SCENARIOS: BusinessScenario[] = [
  ...BASE_BUSINESS_SCENARIOS,
  ...HOME_EXPANSION_SCENARIOS,
  ...ALBUM_EXPANSION_SCENARIOS,
  ...DISTRIBUTED_EXPANSION_SCENARIOS,
  ...NAS_EXPANSION_SCENARIOS
];

export class BusinessScenarioCatalog {
  static getAll(): BusinessScenario[] {
    return BUSINESS_SCENARIOS.map((item) => {
      return new BusinessScenarioRecord(
        item.id,
        item.domain,
        item.ability,
        item.entry,
        item.action,
        item.expectedState,
        item.expectedFocus,
        [...item.steps]
      );
    });
  }

  static getDomains(): string[] {
    return ['首页流程', '相册导航', '分布式流程', 'NAS 流程'];
  }

  static getByDomain(domain: string): BusinessScenario[] {
    return BusinessScenarioCatalog.getAll().filter((item) => item.domain === domain);
  }

  static findById(id: string): BusinessScenario | undefined {
    return BusinessScenarioCatalog.getAll().find((item) => item.id === id);
  }
}
