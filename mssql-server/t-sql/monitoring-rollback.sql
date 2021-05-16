select 
der.session_id,
der.command,
der.status,
der.percent_complete
from sys.dm_exec_requests as der
where der.session_id = 52