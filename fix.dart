import 'dart:io';

void main() {
  final file = File(r'd:\Flutter Projects\basra_website\lib\core\views\components\collapsible_sidebar.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
    '''        color: AppColors.softCharcoal,\n        color: AppColors.sidebarBackground,''',
    '''        color: AppColors.sidebarBackground,'''
  );
  
  content = content.replaceAll(
    '''          right: BorderSide(color: AppColors.border, width: 1.0),\n          right: BorderSide(color: AppColors.sidebarBorder, width: 1.0),''',
    '''          right: BorderSide(color: AppColors.sidebarBorder, width: 1.0),'''
  );
  
  content = content.replaceAll(
    '''            color: AppColors.softCharcoal,\n            color: AppColors.sidebarBackgroundDark,''',
    '''            color: AppColors.sidebarBackgroundDark,'''
  );
  
  content = content.replaceAll(
    '''                    color: AppColors.darkGrey,\n                    color: Colors.white,''',
    '''                    color: Colors.white,'''
  );
  
  content = content.replaceAll(
    '''                    border: Border.all(color: AppColors.border, width: 1.0),\n                    border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.0),''',
    '''                    border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.0),'''
  );
  
  content = content.replaceAll(
    '''                            color: AppColors.accentYellow,\n                            color: Colors.white,''',
    '''                            color: Colors.white,'''
  );
  
  content = content.replaceAll(
    '''                            color: AppColors.textMuted,\n                            color: Colors.white70,''',
    '''                            color: Colors.white70,'''
  );
  
  content = content.replaceAll(
    '''                    color: AppColors.textMuted,\n                    color: Colors.white70,''',
    '''                    color: Colors.white70,'''
  );
  
  content = content.replaceAll(
    '''    final color = !isAccessible\n        ? AppColors.textMuted\n        ? Colors.white.withValues(alpha: 0.45)\n        : isCatActive\n            ? AppColors.accentYellow\n            : AppColors.textSecondary;\n            ? Colors.white\n            : Colors.white.withValues(alpha: 0.85);''',
    '''    final color = !isAccessible\n        ? Colors.white.withValues(alpha: 0.45)\n        : isCatActive\n            ? Colors.white\n            : Colors.white.withValues(alpha: 0.85);'''
  );

  content = content.replaceAll(
    '''            color: isCatActive && isAccessible\n                ? AppColors.secondaryMaroon\n                ? AppColors.sidebarActiveItem\n                : Colors.transparent,''',
    '''            color: isCatActive && isAccessible\n                ? AppColors.sidebarActiveItem\n                : Colors.transparent,'''
  );

  content = content.replaceAll(
    '''                      color: AppColors.accentYellow,\n                      color: Colors.white,''',
    '''                      color: Colors.white,'''
  );
  
  content = content.replaceAll(
    '''                    color: AppColors.textMuted,\n                    color: Colors.white.withValues(alpha: 0.65),''',
    '''                    color: Colors.white.withValues(alpha: 0.65),'''
  );
  
  content = content.replaceAll(
    '''                color: isActive\n                    ? AppColors.secondaryMaroon\n                    ? AppColors.sidebarActiveItem\n                    : hovered\n                        ? AppColors.darkGrey\n                        ? AppColors.sidebarHoverItem\n                        : Colors.transparent,''',
    '''                color: isActive\n                    ? AppColors.sidebarActiveItem\n                    : hovered\n                        ? AppColors.sidebarHoverItem\n                        : Colors.transparent,'''
  );
  
  content = content.replaceAll(
    '''                        color: isActive\n                            ? AppColors.accentYellow\n                            ? Colors.white\n                            : hovered\n                                ? AppColors.textPrimary\n                                : AppColors.textMuted,\n                                ? Colors.white\n                                : Colors.white.withValues(alpha: 0.72),''',
    '''                        color: isActive\n                            ? Colors.white\n                            : hovered\n                                ? Colors.white\n                                : Colors.white.withValues(alpha: 0.72),'''
  );
  
  content = content.replaceAll(
    '''                        color: isActive\n                            ? AppColors.accentYellow\n                            ? Colors.white\n                            : hovered\n                                ? AppColors.textPrimary\n                                : AppColors.textSecondary,\n                                ? Colors.white\n                                : Colors.white.withValues(alpha: 0.85),''',
    '''                        color: isActive\n                            ? Colors.white\n                            : hovered\n                                ? Colors.white\n                                : Colors.white.withValues(alpha: 0.85),'''
  );

  content = content.replaceAll(
    '''                  color: AppColors.textMuted,\n                  color: Colors.white70,''',
    '''                  color: Colors.white70,'''
  );
  
  content = content.replaceAll(
    '''                color: AppColors.textMuted,\n                color: Colors.white70,''',
    '''                color: Colors.white70,'''
  );
  
  file.writeAsStringSync(content);
}
