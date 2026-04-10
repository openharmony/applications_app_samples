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
  