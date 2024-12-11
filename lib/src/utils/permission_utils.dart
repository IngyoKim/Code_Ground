class RolePermissions {
  static const Map<String, List<String>> permissions = {
    'master': ['create', 'edit_all', 'delete', 'manage_roles'],
    'operator': ['create', 'edit_own'],
    'member': ['view'],
  };

  static bool canPerformAction(String role, String action) {
    return permissions[role]?.contains(action) ?? false;
  }
}
