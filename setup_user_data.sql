-- YT考公学习打卡 - 用户数据同步表（自建 Token 认证，无需 Supabase Auth）
-- 在 Supabase SQL Editor 中执行此脚本

-- 1. 删除旧表（如果存在）
DROP TABLE IF EXISTS user_data;

-- 2. 创建 user_data 表
CREATE TABLE user_data (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account TEXT NOT NULL,
  token TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(account)
);

-- 3. 启用行级安全（允许匿名读写，通过 token 验证在应用层完成）
ALTER TABLE user_data ENABLE ROW LEVEL SECURITY;

-- 4. 允许公开读写（安全由应用层 token 验证保证）
CREATE POLICY "Allow public read" ON user_data FOR SELECT USING (true);
CREATE POLICY "Allow public insert" ON user_data FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update" ON user_data FOR UPDATE USING (true);

-- 5. 索引
CREATE INDEX idx_user_data_account ON user_data(account);
CREATE INDEX idx_user_data_token ON user_data(token);
