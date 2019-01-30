USE `essentialmode`;

CREATE TABLE `truck_categories` (
	`name` varchar(60) NOT NULL,
	`label` varchar(60) NOT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `truck_categories` (name, label) VALUES
	('haul','Haulers'),
	('box','Boxed Trucks'),
	('trans','Transport Trucks'),
	('other','Other Trucks')
;

CREATE TABLE `trucks` (
	`name` varchar(60) NOT NULL,
	`model` varchar(60) NOT NULL,
	`price` int(11) NOT NULL,
	`category` varchar(60) DEFAULT NULL,
	PRIMARY KEY (`model`)
);

INSERT INTO `trucks` (name, model, price, category) VALUES
	('Hauler', 'hauler', 100000, 'haul'),
	('Packer', 'packer', 100000, 'haul'),
	('Phantom', 'phantom', 105000, 'haul'),
	('Phantom Custom', 'phantom3', 110000, 'haul'),
	('Benson', 'benson', 55000, 'box'),
	('Boxville 1', 'boxville', 45000, 'box'),
	('Boxville 2', 'boxville2', 45000, 'box'),
	('Boxville 3', 'boxville3', 45000, 'box'),
	('Boxville 4', 'boxville4', 45000, 'box'),
	('Mule 1', 'mule', 40000, 'box'),
	('Mule 2', 'mule2', 40000, 'box'),
	('Mule 3', 'mule3', 40000, 'box'),
	('Pounder', 'pounder', 55000, 'box'),
	('Airport Bus', 'airbus', 50000, 'trans'),
	('Bus', 'bus', 50000, 'trans'),
	('Dashound', 'coach', 50000, 'trans'),
	('Festival Bus', 'pbus2', 125000, 'trans'),
	('Rental Bus', 'rentalbus', 35000, 'trans'),
	('Tour Bus', 'tourbus', 35000, 'trans'),
	('Biff', 'biff', 30000, 'other'),
	('Dozer', 'bulldozer', 20000, 'other'),
	('Field Master', 'tractor2', 15000, 'other'),
	('Mixer 1', 'mixer', 30000, 'other'),
	('Mixer 2', 'mixer2', 30000, 'other'),
	('Rubble', 'rubble', 30000, 'other'),
	('Scrap Truck', 'scrap', 10000, 'other'),
	('Tipper 1', 'tiptruck', 30000, 'other'),
	('Tipper 2', 'tiptruck2', 30000, 'other')
;
