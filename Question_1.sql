CREATE TABLE shiftEvents AS
SELECT
	E.device_id,
	S.shift_id AS event_shift_id,
	S.shift_code AS event_shift_code,
	E.event_id,
	,CASE WHEN E.event_start_time < S.shift_start_time THEN S.shift_start_time
		ELSE E.event_start_time
	END AS event_start_time,
	,CASE WHEN E.event_end_time > S.shift_end_time THEN S.shift_end_time
		ELSE E.event_end_time
	END AS event_end_time
FROM event E
JOIN shift S
ON E.device_id = S.device_id
AND E.event_start_time < S.shift_end_time
AND E.event_end_time > S.shift_start_time;

INSERT INTO events_new (device_id, shift_id, shift_code, event_id, event_start_time, event_end_time)
SELECT
    device_id,
    event_shift_id,
    event_shift_code,
    event_id,
    event_start_time,
    event_end_time
FROM shiftEvents;

DROP TABLE IF EXISTS shiftEvents;
