#UPDATE wp_options SET option_value = 'http://localhost:8082' WHERE option_id IN (1, 2); # // http://localhost:8082
SELECT * FROM wp_options o WHERE o.option_id IN (1, 2);
