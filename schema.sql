-- Zone Table
CREATE TABLE Zone (
    zone_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    population INT,
    area_size DECIMAL(10, 2)
);

-- WasteType Table
CREATE TABLE WasteType (
    waste_type_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    recyclable_flag BOOLEAN,
    processing_method VARCHAR(255)
);

-- Bin Table
CREATE TABLE Bin (
    bin_id INT PRIMARY KEY,
    zone_id INT NOT NULL,
    waste_type_id INT NOT NULL,
    capacity INT,
    current_level INT,
    status VARCHAR(50), -- e.g., 'Empty', 'Half-Full', 'Full', 'Overfilled', 'Maintenance'
    FOREIGN KEY (zone_id) REFERENCES Zone(zone_id),
    FOREIGN KEY (waste_type_id) REFERENCES WasteType(waste_type_id),
    CHECK (current_level >= 0 AND current_level <= capacity)
);

-- Truck Table
CREATE TABLE Truck (
    truck_id INT PRIMARY KEY,
    plate_no VARCHAR(20) NOT NULL UNIQUE,
    capacity INT,
    zone_assigned INT, -- FK to Zone
    FOREIGN KEY (zone_assigned) REFERENCES Zone(zone_id)
);

-- Staff Table
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(100),
    truck_id INT, -- FK to Truck
    shift VARCHAR(50), -- e.g., 'Morning', 'Evening', 'Night'
    FOREIGN KEY (truck_id) REFERENCES Truck(truck_id)
);

-- CollectionSchedule Table
CREATE TABLE CollectionSchedule (
    schedule_id INT PRIMARY KEY,
    bin_id INT NOT NULL,
    truck_id INT NOT NULL,
    staff_id INT NOT NULL,
    scheduled_time DATETIME NOT NULL,
    status VARCHAR(50), -- e.g., 'Scheduled', 'In Progress', 'Completed', 'Cancelled'
    FOREIGN KEY (bin_id) REFERENCES Bin(bin_id),
    FOREIGN KEY (truck_id) REFERENCES Truck(truck_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- ProcessingPlant Table
CREATE TABLE ProcessingPlant (
    plant_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    location VARCHAR(255),
    capacity INT,
    type_of_processing VARCHAR(255) -- e.g., 'Recycling', 'Composting', 'Incineration'
);

-- RecyclingReport Table
CREATE TABLE RecyclingReport (
    report_id INT PRIMARY KEY,
    plant_id INT NOT NULL,
    waste_type_id INT NOT NULL,
    date DATE NOT NULL,
    collected_amount INT,
    recycled_amount INT,
    FOREIGN KEY (plant_id) REFERENCES ProcessingPlant(plant_id),
    FOREIGN KEY (waste_type_id) REFERENCES WasteType(waste_type_id),
    CHECK (recycled_amount >= 0 AND recycled_amount <= collected_amount)
);

-- Complaint Table
CREATE TABLE Complaint (
    complaint_id INT PRIMARY KEY,
    zone_id INT, -- FK to Zone, can be null if complaint is not zone-specific
    bin_id INT, -- FK to Bin, can be null if complaint is not bin-specific
    citizen_name VARCHAR(255),
    issue TEXT NOT NULL,
    status VARCHAR(50), -- e.g., 'Open', 'In Progress', 'Resolved', 'Closed'
    date_reported DATE NOT NULL,
    date_resolved DATE,
    FOREIGN KEY (zone_id) REFERENCES Zone(zone_id),
    FOREIGN KEY (bin_id) REFERENCES Bin(bin_id)
);

-- WasteLog Table
CREATE TABLE WasteLog (
    log_id INT PRIMARY KEY,
    bin_id INT NOT NULL,
    truck_id INT NOT NULL,
    plant_id INT NOT NULL,
    weight DECIMAL(10, 2) NOT NULL,
    date DATETIME NOT NULL,
    FOREIGN KEY (bin_id) REFERENCES Bin(bin_id),
    FOREIGN KEY (truck_id) REFERENCES Truck(truck_id),
    FOREIGN KEY (plant_id) REFERENCES ProcessingPlant(plant_id),
    CHECK (weight > 0)
);

-- Sample Data --

-- Zone Data
INSERT INTO Zone (zone_id, name, population, area_size) VALUES
(1, 'North District', 50000, 10.5),
(2, 'South District', 75000, 15.2),
(3, 'East District', 60000, 12.0),
(4, 'West District', 45000, 8.7);

-- WasteType Data
INSERT INTO WasteType (waste_type_id, name, recyclable_flag, processing_method) VALUES
(101, 'General Waste', FALSE, 'Landfill'),
(102, 'Recyclable Plastic', TRUE, 'Recycling'),
(103, 'Recyclable Paper', TRUE, 'Recycling'),
(104, 'Organic Waste', TRUE, 'Composting'),
(105, 'Hazardous Waste', FALSE, 'Special Disposal');

-- Bin Data
INSERT INTO Bin (bin_id, zone_id, waste_type_id, capacity, current_level, status) VALUES
(1001, 1, 101, 1000, 850, 'Full'),
(1002, 1, 102, 500, 200, 'Half-Full'),
(1003, 1, 103, 500, 450, 'Full'),
(1004, 2, 101, 1200, 1100, 'Full'),
(1005, 2, 104, 600, 300, 'Half-Full'),
(1006, 2, 102, 500, 100, 'Empty'),
(1007, 3, 101, 1000, 700, 'Half-Full'),
(1008, 3, 103, 500, 400, 'Half-Full'),
(1009, 3, 105, 300, 250, 'Full'),
(1010, 4, 101, 1000, 900, 'Full'),
(1011, 4, 102, 500, 350, 'Half-Full'),
(1012, 4, 104, 600, 550, 'Full');

-- Truck Data
INSERT INTO Truck (truck_id, plate_no, capacity, zone_assigned) VALUES
(501, 'ABC-123', 5000, 1),
(502, 'DEF-456', 6000, 2),
(503, 'GHI-789', 5500, 1),
(504, 'JKL-012', 7000, 3),
(505, 'MNO-345', 6500, 2);

-- Staff Data
INSERT INTO Staff (staff_id, name, role, truck_id, shift) VALUES
(201, 'Alice Smith', 'Driver', 501, 'Morning'),
(202, 'Bob Johnson', 'Collector', 501, 'Morning'),
(203, 'Charlie Brown', 'Driver', 502, 'Evening'),
(204, 'Diana Prince', 'Collector', 502, 'Evening'),
(205, 'Ethan Hunt', 'Driver', 503, 'Morning'),
(206, 'Fiona Glenanne', 'Collector', 503, 'Morning'),
(207, 'George Jetson', 'Driver', 504, 'Night'),
(208, 'Hannah Montana', 'Collector', 504, 'Night'),
(209, 'Ian Malcolm', 'Driver', 505, 'Evening'),
(210, 'Jane Doe', 'Collector', 505, 'Evening');

-- CollectionSchedule Data
INSERT INTO CollectionSchedule (schedule_id, bin_id, truck_id, staff_id, scheduled_time, status) VALUES
(3001, 1001, 501, 201, '2025-08-28 08:00:00', 'Completed'),
(3002, 1002, 503, 205, '2025-08-28 09:00:00', 'Completed'),
(3003, 1003, 501, 202, '2025-08-28 10:00:00', 'Completed'),
(3004, 1004, 502, 203, '2025-08-28 11:00:00', 'Completed'),
(3005, 1005, 505, 209, '2025-08-28 12:00:00', 'Completed'),
(3006, 1006, 502, 204, '2025-08-28 13:00:00', 'Completed'),
(3007, 1007, 504, 207, '2025-08-28 14:00:00', 'Completed'),
(3008, 1008, 504, 208, '2025-08-28 15:00:00', 'Completed'),
(3009, 1009, 504, 207, '2025-08-28 16:00:00', 'Completed'),
(3010, 1010, 505, 210, '2025-08-28 17:00:00', 'Completed'),
(3011, 1011, 505, 209, '2025-08-28 18:00:00', 'Completed'),
(3012, 1012, 502, 204, '2025-08-28 19:00:00', 'Completed');

-- ProcessingPlant Data
INSERT INTO ProcessingPlant (plant_id, name, location, capacity, type_of_processing) VALUES
(701, 'Central Recycling Facility', '123 Recycle Way', 10000, 'Recycling'),
(702, 'North Compost Center', '456 Compost Lane', 5000, 'Composting'),
(703, 'West Hazardous Waste Site', '789 Hazard Road', 2000, 'Special Disposal');

-- RecyclingReport Data
INSERT INTO RecyclingReport (report_id, plant_id, waste_type_id, date, collected_amount, recycled_amount) VALUES
(4001, 701, 102, '2025-08-27', 1500, 1200),
(4002, 701, 103, '2025-08-27', 2000, 1800),
(4003, 702, 104, '2025-08-27', 3000, 2800),
(4004, 701, 102, '2025-08-26', 1400, 1150);

-- Complaint Data
INSERT INTO Complaint (complaint_id, zone_id, bin_id, citizen_name, issue, status, date_reported, date_resolved) VALUES
(6001, 1, 1001, 'John Doe', 'Bin is overflowing and smells bad.', 'Open', '2025-08-27', NULL),
(6002, 2, 1004, 'Jane Smith', 'Recycling bin not collected on schedule.', 'Open', '2025-08-28', NULL),
(6003, 1, NULL, 'Peter Jones', 'Street cleaning needed in North District.', 'Resolved', '2025-08-26', '2025-08-27'),
(6004, 3, 1009, 'Mary Brown', 'Hazardous waste bin is damaged.', 'Open', '2025-08-28', NULL),
(6005, 4, 1010, 'David Lee', 'General waste bin is full.', 'Resolved', '2025-08-27', '2025-08-28');

-- WasteLog Data
INSERT INTO WasteLog (log_id, bin_id, truck_id, plant_id, weight, date) VALUES
(5001, 1001, 501, 703, 850.50, '2025-08-28 08:15:00'),
(5002, 1002, 503, 701, 200.75, '2025-08-28 09:30:00'),
(5003, 1003, 501, 703, 450.00, '2025-08-28 10:15:00'),
(5004, 1004, 502, 702, 1100.20, '2025-08-28 11:30:00'),
(5005, 1005, 505, 702, 300.00, '2025-08-28 12:45:00'),
(5006, 1006, 502, 701, 100.50, '2025-08-28 13:15:00'),
(5007, 1007, 504, 703, 700.00, '2025-08-28 14:30:00'),
(5008, 1008, 504, 701, 400.00, '2025-08-28 15:30:00'),
(5009, 1009, 504, 703, 250.00, '2025-08-28 16:15:00'),
(5010, 1010, 505, 701, 900.00, '2025-08-28 17:30:00'),
(5011, 1011, 505, 701, 350.00, '2025-08-28 18:30:00'),
(5012, 1012, 502, 702, 550.00, '2025-08-28 19:30:00');

-- Queries --

-- 1. Total waste collected per zone
SELECT
    z.name AS zone_name,
    SUM(wl.weight) AS total_waste_collected
FROM
    WasteLog wl
JOIN
    Bin b ON wl.bin_id = b.bin_id
JOIN
    Zone z ON b.zone_id = z.zone_id
GROUP BY
    z.name
ORDER BY
    total_waste_collected DESC;

-- 2. Number of complaints per zone
SELECT
    z.name AS zone_name,
    COUNT(c.complaint_id) AS number_of_complaints
FROM
    Complaint c
JOIN
    Zone z ON c.zone_id = z.zone_id
GROUP BY
    z.name
ORDER BY
    number_of_complaints DESC;

-- 3. Bins that are near full (current_level > 80% of capacity)
SELECT
    b.bin_id,
    z.name AS zone_name,
    wt.name AS waste_type,
    b.capacity,
    b.current_level,
    (b.current_level * 100.0 / b.capacity) AS fill_percentage
FROM
    Bin b
JOIN
    Zone z ON b.zone_id = z.zone_id
JOIN
    WasteType wt ON b.waste_type_id = wt.waste_type_id
WHERE
    b.current_level > (b.capacity * 0.80)
ORDER BY
    fill_percentage DESC;

-- 4. Total recycled amount per waste type
SELECT
    wt.name AS waste_type,
    SUM(rr.recycled_amount) AS total_recycled_amount
FROM
    RecyclingReport rr
JOIN
    WasteType wt ON rr.waste_type_id = wt.waste_type_id
GROUP BY
    wt.name
ORDER BY
    total_recycled_amount DESC;

-- 5. Staff members and the trucks they are assigned to
SELECT
    s.name AS staff_name,
    s.role,
    t.plate_no AS truck_plate_number,
    t.zone_assigned AS truck_zone_id
FROM
    Staff s
LEFT JOIN
    Truck t ON s.truck_id = t.truck_id
ORDER BY
    s.name;

-- 6. Collection schedule for a specific bin (e.g., bin_id = 1001)
SELECT
    cs.schedule_id,
    z.name AS zone_name,
    wt.name AS waste_type,
    t.plate_no AS truck_plate_number,
    s.name AS staff_name,
    cs.scheduled_time,
    cs.status
FROM
    CollectionSchedule cs
JOIN
    Bin b ON cs.bin_id = b.bin_id
JOIN
    Zone z ON b.zone_id = z.zone_id
JOIN
    WasteType wt ON b.waste_type_id = wt.waste_type_id
JOIN
    Truck t ON cs.truck_id = t.truck_id
JOIN
    Staff s ON cs.staff_id = s.staff_id
WHERE
    cs.bin_id = 1001
ORDER BY
    cs.scheduled_time;

-- 7. Number of open complaints per zone
SELECT
    z.name AS zone_name,
    COUNT(c.complaint_id) AS number_of_open_complaints
FROM
    Complaint c
JOIN
    Zone z ON c.zone_id = z.zone_id
WHERE
    c.status = 'Open'
GROUP BY
    z.name
ORDER BY
    number_of_open_complaints DESC;

-- 8. Total weight of waste processed by each plant
SELECT
    pp.name AS plant_name,
    SUM(wl.weight) AS total_weight_processed
FROM
    WasteLog wl
JOIN
    ProcessingPlant pp ON wl.plant_id = pp.plant_id
GROUP BY
    pp.name
ORDER BY
    total_weight_processed DESC;

-- 9. Staff working on the 'Morning' shift
SELECT
    staff_id,
    name,
    role,
    shift
FROM
    Staff
WHERE
    shift = 'Morning'
ORDER BY
    name;

-- 10. Bins that are currently 'Full' or 'Overfilled'
SELECT
    b.bin_id,
    z.name AS zone_name,
    wt.name AS waste_type,
    b.current_level,
    b.capacity
FROM
    Bin b
JOIN
    Zone z ON b.zone_id = z.zone_id
JOIN
    WasteType wt ON b.waste_type_id = wt.waste_type_id
WHERE
    b.status IN ('Full', 'Overfilled')
ORDER BY
    z.name, b.bin_id;
