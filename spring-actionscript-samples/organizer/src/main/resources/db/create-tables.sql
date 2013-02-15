CREATE TABLE contacts (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	firstName VARCHAR(30),
	lastName VARCHAR(30),
	email VARCHAR(50),
	phone VARCHAR(15),
	address VARCHAR(100),
	city VARCHAR(50),
	state VARCHAR(50),
	zip VARCHAR(10),
	dob DATETIME,
	pic VARCHAR(50)
);

CREATE INDEX idx_contacts_id ON contacts(id);