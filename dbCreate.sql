-- Create Passenger table
CREATE TABLE Passenger (
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    PRIMARY KEY (email)
);

-- Create Airline table
CREATE TABLE Airline (
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL,
    PRIMARY KEY (name, country)
);

-- Create Aircraft table
CREATE TABLE Aircraft (
    aircraft_id INT NOT NULL AUTO_INCREMENT,
    model VARCHAR(255),
    start_row_letter CHAR(1),
    end_row_letter CHAR(1),
    seat_per_row INT,
    provider_name VARCHAR(255),
    provider_country VARCHAR(100),
    PRIMARY KEY (aircraft_id),
    FOREIGN KEY (provider_name, provider_country) REFERENCES Airline(name, country)
);

-- Create Flight table
CREATE TABLE Flight (
    flight_id INT NOT NULL AUTO_INCREMENT,
    departure_time DATETIME,
    arrival_time DATETIME,
    departure_airport_code VARCHAR(10),
    arrival_airport_code VARCHAR(10),
    price DECIMAL(10, 2),
    currency VARCHAR(3),
    aircraft_id INT,
    PRIMARY KEY (flight_id),
    UNIQUE (departure_time, arrival_time, departure_airport_code, arrival_airport_code),
    FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id)
);

-- Create Ticket table
CREATE TABLE Ticket (
    ticket_id INT NOT NULL AUTO_INCREMENT,
    created_date DATETIME,
    paid_status BOOLEAN,
    paid_date DATETIME,
    email VARCHAR(255),
    flight_id INT,
    PRIMARY KEY (ticket_id),
    FOREIGN KEY (email) REFERENCES Passenger(email),
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id)
);

-- Create Seat table
CREATE TABLE Seat (
    name VARCHAR(10) NOT NULL,
    type VARCHAR(50),
    price DECIMAL(10, 2),
    flight_id INT NOT NULL,
    ticket_id INT NOT NULL,
    PRIMARY KEY (name, flight_id, ticket_id),    
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id),
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id)
);

-- Create Luggage table
CREATE TABLE Luggage (
    luggage_id INT NOT NULL,
    weight DECIMAL(5, 2),
    price DECIMAL(10, 2),    
    PRIMARY KEY (luggage_id)
);

-- Create Luggage_Ticket table
CREATE TABLE Luggage_Ticket (
    luggage_id INT NOT NULL,
    ticket_id INT NOT NULL,
    PRIMARY KEY (luggage_id,ticket_id),
    FOREIGN KEY (luggage_id) REFERENCES Luggage(luggage_id),
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id)
);

-- Create Insurance table
CREATE TABLE Insurance (
    insurance_id INT NOT NULL,
    type VARCHAR(50),
    price DECIMAL(10, 2),    
    PRIMARY KEY (insurance_id)
);

-- Create Insurance_Ticket table
CREATE TABLE Insurance_Ticket (
    insurance_id INT NOT NULL,
    ticket_id INT NOT NULL,
    PRIMARY KEY (insurance_id,ticket_id),
    FOREIGN KEY (insurance_id) REFERENCES Insurance(insurance_id),
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id)
);

-- Insert fake passengers
INSERT INTO Passenger (email, phone, first_name, last_name) VALUES
('john.doe@email.com', '0412345678', 'John', 'Doe'),
('jane.smith@email.com', '0419876543', 'Jane', 'Smith'),
('michael.lee@email.com', '0423456789', 'Michael', 'Lee'),
('emma.watson@email.com', '0429876543', 'Emma', 'Watson'),
('david.jones@email.com', '0412463579', 'David', 'Jones'),
('sophia.brown@email.com', '0413579246', 'Sophia', 'Brown'),
('liam.wilson@email.com', '0424681357', 'Liam', 'Wilson'),
('mia.moore@email.com', '0415792468', 'Mia', 'Moore'),
('ethan.taylor@email.com', '0424685791', 'Ethan', 'Taylor'),
('olivia.miller@email.com', '0413579246', 'Olivia', 'Miller');

-- Insert fake airlines
INSERT INTO Airline (name, country) VALUES
('Qantas', 'Australia'),
('Singapore Airlines', 'Singapore'),
('Cathay Pacific', 'Hong Kong'),
('Japan Airlines', 'Japan'),
('Korean Air', 'South Korea'),
('Thai Airways', 'Thailand'),
('China Southern', 'China'),
('Vietnam Airlines', 'Vietnam'),
('Air India', 'India'),
('Malaysia Airlines', 'Malaysia');

-- Insert fake aircraft
INSERT INTO Aircraft (aircraft_id, model, start_row_letter, end_row_letter, seat_per_row, provider_name, provider_country) VALUES
(1, 'Boeing 777', 'A', 'Z', 10, 'Qantas', 'Australia'),
(2, 'Boeing 787', 'A', 'Z', 9, 'Singapore Airlines', 'Singapore'),
(3, 'Airbus A350', 'A', 'Z', 8, 'Cathay Pacific', 'Hong Kong'),
(4, 'Airbus A380', 'A', 'Z', 10, 'Japan Airlines', 'Japan'),
(5, 'Boeing 747', 'A', 'Z', 9, 'Korean Air', 'South Korea'),
(6, 'Boeing 737', 'A', 'Z', 6, 'Thai Airways', 'Thailand'),
(7, 'Airbus A320', 'A', 'Z', 6, 'China Southern', 'China'),
(8, 'Airbus A330', 'A', 'Z', 8, 'Vietnam Airlines', 'Vietnam'),
(9, 'Boeing 777', 'A', 'Z', 10, 'Air India', 'India'),
(10, 'Airbus A350', 'A', 'Z', 8, 'Malaysia Airlines', 'Malaysia');

-- Insert 30 flights from Sydney (SYD) to various Asian countries
INSERT INTO Flight (flight_id, departure_time, arrival_time, departure_airport_code, arrival_airport_code, price, currency, aircraft_id) VALUES
(1, '2024-10-01 09:00:00', '2024-10-01 15:00:00', 'SYD', 'SIN', 800, 'AUD', 2),   -- Singapore
(2, '2024-10-02 11:00:00', '2024-10-02 19:00:00', 'SYD', 'HKG', 900, 'AUD', 3),   -- Hong Kong
(3, '2024-10-03 10:00:00', '2024-10-03 20:00:00', 'SYD', 'NRT', 1000, 'AUD', 4),  -- Tokyo (Japan)
(4, '2024-10-04 14:00:00', '2024-10-04 22:00:00', 'SYD', 'ICN', 950, 'AUD', 5),   -- Seoul (South Korea)
(5, '2024-10-05 08:00:00', '2024-10-05 16:00:00', 'SYD', 'BKK', 750, 'AUD', 6),   -- Bangkok (Thailand)
(6, '2024-10-06 12:00:00', '2024-10-06 20:00:00', 'SYD', 'CAN', 700, 'AUD', 7),   -- Guangzhou (China)
(7, '2024-10-07 10:00:00', '2024-10-07 18:00:00', 'SYD', 'SGN', 850, 'AUD', 8),   -- Ho Chi Minh City (Vietnam)
(8, '2024-10-08 13:00:00', '2024-10-08 23:00:00', 'SYD', 'DEL', 1200, 'AUD', 9),  -- New Delhi (India)
(9, '2024-10-09 10:00:00', '2024-10-09 18:00:00', 'SYD', 'KUL', 900, 'AUD', 10),  -- Kuala Lumpur (Malaysia)
(10, '2024-10-10 09:00:00', '2024-10-10 16:00:00', 'SYD', 'TPE', 950, 'AUD', 2),  -- Taipei (Taiwan)
(11, '2024-10-11 11:00:00', '2024-10-11 19:00:00', 'SYD', 'CGK', 800, 'AUD', 3),  -- Jakarta (Indonesia)
(12, '2024-10-12 08:00:00', '2024-10-12 16:00:00', 'SYD', 'HND', 1050, 'AUD', 4), -- Tokyo (Haneda)
(13, '2024-10-13 14:00:00', '2024-10-13 21:00:00', 'SYD', 'DPS', 750, 'AUD', 5),  -- Denpasar (Bali)
(14, '2024-10-14 10:00:00', '2024-10-14 18:00:00', 'SYD', 'HKT', 700, 'AUD', 6),  -- Phuket (Thailand)
(15, '2024-10-15 12:00:00', '2024-10-15 20:00:00', 'SYD', 'PNH', 800, 'AUD', 7),  -- Phnom Penh (Cambodia)
(16, '2024-10-16 09:00:00', '2024-10-16 17:00:00', 'SYD', 'KIX', 950, 'AUD', 8),  -- Osaka (Japan)
(17, '2024-10-17 13:00:00', '2024-10-17 21:00:00', 'SYD', 'PEK', 1100, 'AUD', 9), -- Beijing (China)
(18, '2024-10-18 10:00:00', '2024-10-18 18:00:00', 'SYD', 'HAN', 900, 'AUD', 10), -- Hanoi (Vietnam)
(19, '2024-10-19 08:00:00', '2024-10-19 16:00:00', 'SYD', 'MNL', 850, 'AUD', 2),  -- Manila (Philippines)
(20, '2024-10-20 11:00:00', '2024-10-20 19:00:00', 'SYD', 'ICN', 950, 'AUD', 3),  -- Seoul (South Korea)
(21, '2024-10-21 09:00:00', '2024-10-21 17:00:00', 'SYD', 'SIN', 800, 'AUD', 4),
(22, '2024-10-22 12:00:00', '2024-10-22 20:00:00', 'SYD', 'HKG', 900, 'AUD', 5),
(23, '2024-10-23 10:00:00', '2024-10-23 20:00:00', 'SYD', 'NRT', 1000, 'AUD', 6),
(24, '2024-10-24 14:00:00', '2024-10-24 22:00:00', 'SYD', 'ICN', 950, 'AUD', 7),
(25, '2024-10-25 08:00:00', '2024-10-25 16:00:00', 'SYD', 'BKK', 750, 'AUD', 8),
(26, '2024-10-26 12:00:00', '2024-10-26 20:00:00', 'SYD', 'CAN', 700, 'AUD', 9),
(27, '2024-10-27 10:00:00', '2024-10-27 18:00:00', 'SYD', 'SGN', 850, 'AUD', 10),
(28, '2024-10-28 13:00:00', '2024-10-28 23:00:00', 'SYD', 'DEL', 1200, 'AUD', 2),
(29, '2024-10-29 10:00:00', '2024-10-29 18:00:00', 'SYD', 'KUL', 900, 'AUD', 3),
(30, '2024-10-30 09:00:00', '2024-10-30 16:00:00', 'SYD', 'TPE', 950, 'AUD', 4);

-- Insert 30 flights returning from Asia to Sydney (SYD)
INSERT INTO Flight (flight_id, departure_time, arrival_time, departure_airport_code, arrival_airport_code, price, currency, aircraft_id) VALUES
(31, '2024-11-01 09:00:00', '2024-11-01 18:00:00', 'SIN', 'SYD', 800, 'AUD', 2),
(32, '2024-11-02 12:00:00', '2024-11-02 20:00:00', 'HKG', 'SYD', 900, 'AUD', 3),
(33, '2024-11-03 10:00:00', '2024-11-03 20:00:00', 'NRT', 'SYD', 1000, 'AUD', 4),
(34, '2024-11-04 15:00:00', '2024-11-04 23:00:00', 'ICN', 'SYD', 950, 'AUD', 5),
(35, '2024-11-05 08:00:00', '2024-11-05 16:00:00', 'BKK', 'SYD', 750, 'AUD', 6),
(36, '2024-11-06 11:00:00', '2024-11-06 19:00:00', 'CAN', 'SYD', 700, 'AUD', 7),
(37, '2024-11-07 10:00:00', '2024-11-07 18:00:00', 'SGN', 'SYD', 850, 'AUD', 8),   -- Ho Chi Minh City
(38, '2024-11-08 14:00:00', '2024-11-08 23:00:00', 'DEL', 'SYD', 1200, 'AUD', 9),  -- New Delhi
(39, '2024-11-09 10:00:00', '2024-11-09 18:00:00', 'KUL', 'SYD', 900, 'AUD', 10),  -- Kuala Lumpur
(40, '2024-11-10 09:00:00', '2024-11-10 16:00:00', 'TPE', 'SYD', 950, 'AUD', 2),   -- Taipei
(41, '2024-11-11 11:00:00', '2024-11-11 19:00:00', 'CGK', 'SYD', 800, 'AUD', 3),   -- Jakarta
(42, '2024-11-12 08:00:00', '2024-11-12 16:00:00', 'HND', 'SYD', 1050, 'AUD', 4),  -- Tokyo (Haneda)
(43, '2024-11-13 14:00:00', '2024-11-13 21:00:00', 'DPS', 'SYD', 750, 'AUD', 5),   -- Denpasar (Bali)
(44, '2024-11-14 10:00:00', '2024-11-14 18:00:00', 'HKT', 'SYD', 700, 'AUD', 6),   -- Phuket
(45, '2024-11-15 12:00:00', '2024-11-15 20:00:00', 'PNH', 'SYD', 800, 'AUD', 7),   -- Phnom Penh
(46, '2024-11-16 09:00:00', '2024-11-16 17:00:00', 'KIX', 'SYD', 950, 'AUD', 8),   -- Osaka
(47, '2024-11-17 13:00:00', '2024-11-17 21:00:00', 'PEK', 'SYD', 1100, 'AUD', 9),  -- Beijing
(48, '2024-11-18 10:00:00', '2024-11-18 18:00:00', 'HAN', 'SYD', 900, 'AUD', 10),  -- Hanoi
(49, '2024-11-19 08:00:00', '2024-11-19 16:00:00', 'MNL', 'SYD', 850, 'AUD', 2),   -- Manila
(50, '2024-11-20 11:00:00', '2024-11-20 19:00:00', 'ICN', 'SYD', 950, 'AUD', 3),   -- Seoul
(51, '2024-11-21 09:00:00', '2024-11-21 18:00:00', 'SIN', 'SYD', 800, 'AUD', 4),   -- Singapore
(52, '2024-11-22 12:00:00', '2024-11-22 20:00:00', 'HKG', 'SYD', 900, 'AUD', 5),   -- Hong Kong
(53, '2024-11-23 10:00:00', '2024-11-23 20:00:00', 'NRT', 'SYD', 1000, 'AUD', 6),  -- Tokyo (Narita)
(54, '2024-11-24 14:00:00', '2024-11-24 22:00:00', 'ICN', 'SYD', 950, 'AUD', 7),   -- Seoul
(55, '2024-11-25 08:00:00', '2024-11-25 16:00:00', 'BKK', 'SYD', 750, 'AUD', 8),   -- Bangkok
(56, '2024-11-26 12:00:00', '2024-11-26 20:00:00', 'CAN', 'SYD', 700, 'AUD', 9),   -- Guangzhou
(57, '2024-11-27 10:00:00', '2024-11-27 18:00:00', 'SGN', 'SYD', 850, 'AUD', 10),  -- Ho Chi Minh City
(58, '2024-11-28 14:00:00', '2024-11-28 23:00:00', 'DEL', 'SYD', 1200, 'AUD', 2),  -- New Delhi
(59, '2024-11-29 10:00:00', '2024-11-29 18:00:00', 'KUL', 'SYD', 900, 'AUD', 3),   -- Kuala Lumpur
(60, '2024-11-30 09:00:00', '2024-11-30 16:00:00', 'TPE', 'SYD', 950, 'AUD', 4);   -- Taipei

-- Insert 20 tickets for different passengers and flights
INSERT INTO Ticket (ticket_id, created_date, paid_status, paid_date, email, flight_id) VALUES
(1, '2024-09-25', TRUE, '2024-09-26', 'john.doe@email.com', 1),
(2, '2024-09-26', TRUE, '2024-09-27', 'jane.smith@email.com', 2),
(3, '2024-09-27', TRUE, '2024-09-28', 'david.jones@email.com', 3),
(4, '2024-09-28', TRUE, '2024-09-29', 'liam.wilson@email.com', 4),
(5, '2024-09-29', TRUE, '2024-09-30', 'mia.moore@email.com', 5),
(6, '2024-09-30', TRUE, '2024-10-01', 'ethan.taylor@email.com', 6),
(7, '2024-10-01', TRUE, '2024-10-02', 'olivia.miller@email.com', 7),
(8, '2024-10-02', TRUE, '2024-10-03', 'john.doe@email.com', 8),
(9, '2024-10-03', TRUE, '2024-10-04', 'jane.smith@email.com', 9),
(10, '2024-10-04', TRUE, '2024-10-05', 'michael.lee@email.com', 10),
(11, '2024-10-05', TRUE, '2024-10-06', 'emma.watson@email.com', 11),
(12, '2024-10-06', TRUE, '2024-10-07', 'liam.wilson@email.com', 12),
(13, '2024-10-07', TRUE, '2024-10-08', 'sophia.brown@email.com', 13),
(14, '2024-10-08', TRUE, '2024-10-09', 'mia.moore@email.com', 14),
(15, '2024-10-09', TRUE, '2024-10-10', 'ethan.taylor@email.com', 15),
(16, '2024-10-10', TRUE, '2024-10-11', 'olivia.miller@email.com', 16),
(17, '2024-10-11', TRUE, '2024-10-12', 'john.doe@email.com', 17),
(18, '2024-10-12', TRUE, '2024-10-13', 'liam.wilson@email.com', 18),
(19, '2024-10-13', TRUE, '2024-10-14', 'emma.watson@email.com', 19),
(20, '2024-10-14', TRUE, '2024-10-15', 'sophia.brown@email.com', 20);

-- Insert 20 seats for the 20 reserved tickets
INSERT INTO Seat (name, type, price, flight_id, ticket_id) VALUES
('A1', 'Economy', 1, 1, 1),
('A2', 'Economy', 1, 2, 2),
('B1', 'Business', 3, 3, 3),
('B2', 'Business', 3, 4, 4),
('C1', 'First Class', 5, 5, 5),
('A1', 'Economy', 1, 6, 6),
('A2', 'Economy', 1, 7, 7),
('B1', 'Business', 3, 8, 8),
('B2', 'Business', 3, 9, 9),
('C1', 'First Class', 5, 10, 10),
('A1', 'Economy', 1.2, 11, 11),
('A2', 'Economy', 1.2, 12, 12),
('B1', 'Business', 3.20, 13, 13),
('B2', 'Business', 3.20, 14, 14),
('C1', 'First Class', 5.20, 15, 15),
('A1', 'Economy', 1.30, 16, 16),
('A2', 'Economy', 1.30, 17, 17),
('B1', 'Business', 3.30, 18, 18),
('B2', 'Business', 3.30, 19, 19),
('C1', 'First Class', 5.30, 20, 20);

-- Insert luggage 
INSERT INTO Luggage (luggage_id, weight, price) VALUES
(1, 5, 30), 
(2, 10, 45),
(3, 23.0, 90), 
(4, 30, 110),
(5, 50, 150), 
(6, 70, 180);

-- Insert insurance 
INSERT INTO Insurance (insurance_id, type, price) VALUES
(1, 'Basic', 50),
(2, 'Standard', 75),
(3, 'Premium', 100);

-- Insert Insurance_Ticket
INSERT INTO Insurance_Ticket (ticket_id, insurance_id) VALUES
(1, 2),
(2, 1),
(3, 3),
(4, 2),
(5, 1),
(6, 2),
(7, 1),
(8, 3),
(9, 1),
(10, 3),
(11, 1),
(12, 2),
(13, 1),
(20, 1),
(19, 1);

-- Insert Luggage_Ticket
INSERT INTO Luggage_Ticket (ticket_id, luggage_id) VALUES
(1, 2),
(2, 3),
(3, 5),
(4, 6),
(5, 1),
(6, 2),
(7, 4),
(8, 5),
(15, 6),
(16, 3),
(17, 1),
(18, 2),
(19, 3),
(20, 1);