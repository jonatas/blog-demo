-- FIXME: link blog post source here
-- Create sales table
CREATE TABLE sales (
    sales_id SERIAL PRIMARY KEY,
    data JSONB NOT NULL
);

-- Create user_history table
CREATE TABLE user_history (
    history_id SERIAL PRIMARY KEY,
    sales_id INT NOT NULL,
    user_data JSONB NOT NULL,
    FOREIGN KEY (sales_id) REFERENCES sales (sales_id)
);

CREATE OR REPLACE FUNCTION remove_history_of_canceled_sales()
RETURNS TRIGGER AS $$
BEGIN
  IF ( OLD.data->>sales_status <> 'canceled') AND
         (NEW.data->>sales_status = 'canceled') THEN


        DELETE FROM user_history WHERE sales_id = OLD.sales_id;
  END IF;
      RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER remove_user_history_from_cancel
AFTER UPDATE ON sales
FOR EACH ROW EXECUTE PROCEDURE remove_canceled_sales_history();

INSERT INTO sales (data) VALUES
('{"sales_status": "active"}'),
('{"sales_status": "pending"}'),
('{"sales_status": "canceled"}');

INSERT INTO user_history (sales_id, user_data) VALUES
(1, '{"user_info": "history for sale 1"}'),
(2, '{"user_info": "history for sale 2"}');

UPDATE sales SET data = jsonb_set(data, '{sales_status}', '"canceled"') WHERE sales_id = 1;

SELECT * FROM user_history;
