-- №1 Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. 
-- Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. 
Функция должна возвращать номер пользователя.

DELIMITER |
drop procedure if exists del_user1 |
create procedure del_user1(in user_id INT(4))
BEGIN
    -- Удаляем все сообщения пользователя
    DELETE FROM messages WHERE from_user_id = user_id;

    -- Удаляем все лайки пользователя
    DELETE FROM likes WHERE user_id = user_id;

    -- Удаляем все медиа записи пользователя
    DELETE FROM media WHERE user_id = user_id;

    -- Удаляем профиль пользователя
   DELETE FROM users WHERE id = user_id;

    SELECT user_id;

END
|
DELIMITER |
CALL del_user1('8');
|

-- №2 Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.
DELIMITER |
drop procedure if exists del_user1 |
create procedure del_user1(in user_id INT(4))
BEGIN
	START TRANSACTION;
    -- Удаляем все сообщения пользователя
    DELETE FROM messages WHERE from_user_id = user_id;

    -- Удаляем все лайки пользователя
    DELETE FROM likes WHERE user_id = user_id;

    -- Удаляем все медиа записи пользователя
    DELETE FROM media WHERE user_id = user_id;

    -- Удаляем профиль пользователя
   DELETE FROM users WHERE id = user_id;

   COMMIT;
   SELECT user_id;

END
|
DELIMITER |
CALL del_user1('8');
|

-- №3. Написать триггер, который проверяет новое появляющееся сообщество. Длина названия сообщества (поле name) должна быть не менее 5 символов. 
-- Если требование не выполнено, то выбрасывать исключение с пояснением.

DELIMITER |
CREATE TRIGGER community_name_length_norms
BEFORE INSERT ON communities
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.name) < 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'В названии сообщества должно быть более 4 символов';
        -- Состояние 45000 является общим состоянием, представляющим «необработанное пользовательское исключение».
    END IF;
END
|

DELIMITER ;

