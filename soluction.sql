-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT * FROM `students` WHERE YEAR (`date_of_birth`) = 1990;

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * FROM `courses` WHERE `cfu` > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * FROM `students` WHERE TIMESTAMPDIFF(YEAR, `date_of_birth`, CURDATE()) > 30;

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * FROM `courses` WHERE `year` = 1 AND `period` = 'I Semestre';

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * FROM `exams` WHERE `date` = '2020-06-20' AND `hour` >= '14:%';

-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * FROM `degrees` WHERE `level` = 'magistrale';

-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) AS `num_dipartimento` FROM `departments`;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(`phone`) AS `senza_telefono` FROM `teachers`;

-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT YEAR(`enrolment_date`) AS `anno_iscrizione`, COUNT(*) AS `numero_iscritti` FROM `students` GROUP BY `anno_iscrizione`;

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT `office_address` AS `indirizzo_ufficio`, COUNT(*) AS `numero_insegnanti` FROM `teachers` GROUP BY `office_address` HAVING `numero_insegnanti` > 1;

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT ROUND(AVG(`vote`)) AS `media_voto`, `exam_id` FROM `exam_student` GROUP BY `exam_id`;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(*) AS `numero_corsi`, `department_id` AS `id_dipartimento` FROM `degrees` GROUP BY `department_id`;

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT S.`name`, `S`.`surname` FROM `students` AS S JOIN `degrees` AS D ON `S`.`degree_id` = `D`.`id` WHERE D.`name` = 'Corso di Laurea in Economia';

-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT DEG.`name` FROM `degrees` AS DEG JOIN `departments` AS DEP ON DEG.`department_id` = DEP.`id` WHERE DEP.`name` = 'Dipartimento di Neuroscienze';

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT C.*, `T`.`id` AS 'id_teacher' FROM `courses` AS C JOIN `course_teacher` AS CT ON C.`id` = `CT`.`course_id` JOIN `teachers` AS T WHERE T.`surname` = 'Amato' AND T.`name` = 'Fulvio';

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT `students`.`name`,`students`.`surname`,`degrees`.`name` AS 'Corso Laurea', `departments`.`name`AS 'Dipartimento' FROM `students` JOIN `degrees` ON `students`.`degree_id` = `degrees`.`id` JOIN `departments` ON `degrees`.`department_id` = `departments`.`id` ORDER BY `students`.`surname`, `students`.`name`;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT * FROM `degrees` JOIN `courses` ON `degrees`.`id` = `courses`.`degree_id` JOIN `course_teacher` ON `courses`.`id` = `course_teacher`.`course_id` JOIN `teachers` ON `teachers`.`id` = `course_teacher`.`teacher_id`;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT T.name, T.surname FROM `course_teacher` AS CT JOIN `teachers` as T ON CT.`teacher_id` = T.`id`JOIN `courses` AS C ON `CT`.`course_id` = `C`.`id` JOIN `degrees` AS DEG ON C.`degree_id` = DEG.`id` JOIN `departments` AS DEP ON `DEG`.`department_id` = `DEP`.`id` WHERE `DEP`.`name` = 'Dipartimento di Matematica';

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami
SELECT S.`name`, S.`surname`, C.`name` AS 'Nome Corso', COUNT(ES.`vote`) AS 'Numero Tentativi', MAX(ES.`vote`) AS `voto_massimo` FROM `students` AS S JOIN `exam_student` AS ES ON `S`.`id` = `ES`.`student_id` JOIN `exams` AS E ON `E`.`id` = `ES`.`exam_id` JOIN `courses` AS C ON `C`.`id` = `E`.`course_id` GROUP BY `S`.`id`, `C`.`id` HAVING `voto_massimo` >= 18;