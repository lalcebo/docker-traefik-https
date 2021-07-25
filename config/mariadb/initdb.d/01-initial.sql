USE mysql;

-- Delete root user with access from any host without password.
DELETE
FROM `user`
WHERE `user` = 'root'
  AND `host` <> '%';

-- Update root user with local access with password.
UPDATE `user`
SET `host` = '%'
WHERE `user` = 'root'
  AND `plugin` = 'mysql_native_password';

-- Reload privileges
FLUSH PRIVILEGES;
