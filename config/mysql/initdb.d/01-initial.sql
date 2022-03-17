USE mysql;

-- Delete root user with access from any host without password.
DELETE
FROM `user`
WHERE `user` = 'root'
  AND `host` <> '%';

-- Reload privileges
FLUSH PRIVILEGES;
