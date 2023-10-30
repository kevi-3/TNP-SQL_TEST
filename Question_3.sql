DELETE FROM EVENT
WHERE EXISTS (
    SELECT 1
    FROM BREAK AS B
    WHERE EVENT.device_id = B.device_id
    AND EVENT.shift_id = B.shift_id
    AND EVENT.event_start_time < B.break_end_time
    AND EVENT.event_end_time > B.break_start_time
);
