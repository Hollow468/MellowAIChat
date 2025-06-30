import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {
        'en_US': {
          // Register
          'register': 'Register',
          'name': 'Name',
          'email': 'E-mail',
          'password': 'Password',
          'confirm_password': 'Confirm Password',
          'subscribe': 'Subscribe',
          'do_you_have_account': 'Do you have an account? ',
          'log_in': 'Log in',
          // Login
          'welcome': 'Welcome',
          'login_to_continue': 'Login to continue',
          'login': 'Login',
          'forget_password': 'Forget the password?',
          'is_no_account': 'IS NO ACCOUNT? ',
          'sign_up': 'Sign up',
          // Chat
          'how_can_i_help': 'How can I help you my friend?',
          'ask_anything': 'Ask me anything...',
          // Settings
          'settings': 'Settings',
          'api_url': 'API URL',
          'api_url_hint': 'e.g. https://api.siliconflow.cn/v1',
          'api_token': 'API Token',
          'connect_test': 'Connection Test',
          'connect_test_failed': 'Connection Test Failed',
          'connect_test_success': 'Connection Test Success',
          'model': 'Model',
          "model_count": 'Model Count',
          'context_limit': 'Context Message Limit',
          'display': 'Display',
          'language': 'Language',
          'chat': 'Chat',
          'cancel': 'Cancel',
          'save': 'Save',
          // Menu
          'menus_title': 'Menus',
          'sign_out': 'Sign Out',
          'prompt': 'Prompt',
          // History
          'new_chat': 'New Chat',
          'open_new_chat': 'Open New Chat',
          // Prompt
          'prompt_manage': 'Prompt Management',
          'create_new_prompt': 'Create New Prompt',
          'prompt_name': 'Name',
          'prompt_content': 'Character Setting (Prompt)',
          'my_prompt': 'My Prompts',
          'prompt_apply_success': 'Prompt applied successfully',
        },
        'zh_CN': {
          // Register
          'register': '注册',
          'name': '姓名',
          'email': '邮箱',
          'password': '密码',
          'confirm_password': '确认密码',
          'subscribe': '注册',
          'do_you_have_account': '已有账号？',
          'log_in': '登录',
          // Login
          'welcome': '欢迎',
          'login_to_continue': '登录以继续',
          'login': '登录',
          'forget_password': '忘记密码？',
          'is_no_account': '没有账号？',
          'sign_up': '注册',
          // Chat
          'how_can_i_help': '有什么可以帮您？',
          'ask_anything': '问我任何问题...',
          // Settings
          'settings': '设置',
          'api_url': '通用API地址',
          'api_token': 'API密钥',
          'connect_test': '连接测试',
          'connect_test_failed': '连接测试失败',
          'connect_test_success': '连接测试成功',
          'model': '模型',
          "model_count": '模型数量',
          'context_limit': '上下文消息数量上限',
          'display': '显示',
          'language': '语言',
          'chat': '对话',
          'cancel': '取消',
          'save': '保存',
          // Menu
          'menus_title': '菜单',
          'sign_out': '退出登录',
          'prompt': '提示词',
          // History
          'new_chat': '新对话',
          'open_new_chat': '打开新对话',
          // Prompt
          'prompt_manage': '提示词管理',
          'create_new_prompt': '创建新的提示词',
          'prompt_name': '名称',
          'prompt_content': '人物设定（Prompt）',
          'my_prompt': '我的提示词',
          'prompt_apply_success': '应用提示词成功',
        }
      };
}