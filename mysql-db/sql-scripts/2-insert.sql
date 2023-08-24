-- Inserting data into the USER table
INSERT INTO USER (firstName, lastName, isAdmin, email, password) VALUES
('John', 'Doe', true, 'johndoe@email.com', '$2b$10$wDwdOvEEk6tnTx6JSZ6UlOapQ4CPXeDLXkeHZ69UYAKlwyCh9uCce'), # password123
('Jane', 'Smith', false, 'janesmith@email.com', '$2b$10$7aJ1uuaJCgI/kEh24GUBlu3Wb7.uD1.xlFrB9zFEwssOEAjp0dWF2'), # password456
('Mark', 'Johnson', true, 'markjohnson@email.com', '$2b$10$Ld/EnyM0IaPHXKS1BAsOJ.19lvyNDe3obDcoLbczDkqB5TJqeesHO'); # password789

-- Inserting data into the EVENT table
INSERT INTO EVENT (title, location, startDate, endDate, description) VALUES
('Company Picnic', 'Central Park', '2023-09-07 11:00:00', '2023-09-07 17:00:00', 'Annual company picnic for all employees.'),
('Sales Conference', 'New York Marriott Marquis', '2023-09-08 09:00:00', '2023-09-08 11:00:00', 'Sales conference for all regional managers.'),
('Product Launch', 'Jacob K. Javits Convention Center', '2024-09-05 05:00:00', '2024-09-05 07:00:00', 'Launch of new product line at the convention center.');

-- Inserting data into the ATTENDANCE_RECORD table
INSERT INTO ATTENDANCE_RECORD (userId, eventId) VALUES
(1, 1),
(2, 1),
(3, 1),
(1, 2),
(2, 2),
(3, 3);

-- Inserting data into the EVENT_SCHEDULE_ITEM table
INSERT INTO EVENT_SCHEDULE_ITEM (eventId, startDate, endDate, activity, description) VALUES
(1, '2023-07-15 11:00:00', '2023-07-15 12:00:00', 'Lunch', 'Enjoy food and drinks with colleagues.'),
(1, '2023-07-15 12:00:00', '2023-07-15 13:00:00', 'Games', 'Play games and participate in team-building activities.'),
(2, '2023-09-12 09:00:00', '2023-09-12 10:30:00', 'Keynote Speech', 'Hear from the CEO about the company vision.'),
(2, '2023-09-12 10:30:00', '2023-09-12 12:00:00', 'Breakout Sessions', 'Participate in workshops and networking sessions.'),
(2, '2023-09-13 09:00:00', '2023-09-13 10:30:00', 'Keynote Speech', 'Hear from industry experts about the latest trends.'),
(2, '2023-09-13 10:30:00', '2023-09-13 12:00:00', 'Breakout Sessions', 'Participate in workshops and networking sessions.'),
(3, '2024-03-01 09:00:00', '2024-03-01 10:30:00', 'Product Demo', 'Get a firsthand look at the new product line.')