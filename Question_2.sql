
CREATE TABLE tempSplit AS
SELECT
    E.device_id,
    E.shift_id,
    E.event_id,
    E.event_start_time AS original_event_start_time,
    CASE
        WHEN E.event_start_time < B.break_start_time THEN B.break_start_time
        ELSE E.event_start_time
    END AS event_start_time,
    CASE
        WHEN E.event_end_time > B.break_end_time THEN B.break_end_time
        ELSE E.event_end_time
    END AS event_end_time
FROM Events AS E
JOIN Breaks AS B 
	ON E.device_id = B.device_id
    AND E.shift_id = B.shift_id
    AND E.event_start_time < B.break_end_time
    AND E.event_end_time > B.break_start_time;

-- Insert the split events into the original events table
INSERT INTO Events (device_id, shift_id, event_id, event_start_time, event_end_time)
SELECT
    device_id,
    shift_id,
    event_id,
    event_start_time,
    event_end_time
FROM tempSplit;


DROP TABLE IF EXISTS tempSplit;
