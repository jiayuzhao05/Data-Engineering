-- Branch Table
CREATE TABLE Branch (
  BranchID VARCHAR(10) PRIMARY KEY,
  BranchAddress VARCHAR(200) NOT NULL
);

-- Customer Table
CREATE TABLE Customer (
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Address VARCHAR(200) NOT NULL,
  Gender CHAR(1) CHECK (Gender IN ('M','F','O')),
  CustomerType VARCHAR(20) CHECK (CustomerType IN ('VIP','Member','Non-member')),
  PhoneNumber VARCHAR(20),
  Email VARCHAR(100),
  PRIMARY KEY (FirstName, LastName, Address, Gender)
);


-- Product Line Table
CREATE TABLE ProductLine (
  ProductLineID VARCHAR(10) PRIMARY KEY,
  ProductLineName VARCHAR(50) UNIQUE NOT NULL
);

-- Product Table
CREATE TABLE Product (
  ProductID VARCHAR(20) PRIMARY KEY,
  ProductLineID VARCHAR(20) NOT NULL,
  UnitPrice DECIMAL(10,2),
  COGS DECIMAL(10,2),
  FOREIGN KEY (ProductLineID) REFERENCES ProductLine(ProductLineID)
);

-- Payment Method Table
CREATE TABLE PaymentMethod (
  PaymentID VARCHAR(10) PRIMARY KEY,
  PaymentType VARCHAR(20) CHECK (PaymentType IN ('Cash','Credit card','Ewallet'))
);

-- Invoice Table
CREATE TABLE Invoice (
  InvoiceID VARCHAR(30) PRIMARY KEY,
  InvoiceDate DATE NOT NULL,
  BranchID VARCHAR(10) NOT NULL,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Address VARCHAR(200) NOT NULL,
  Gender CHAR(1) NOT NULL,
  PaymentID VARCHAR(10) NOT NULL,
  TotalAmount DECIMAL(12,2) NOT NULL,
  Rating TINYINT CHECK (Rating BETWEEN 1 AND 10),
  FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
  FOREIGN KEY (PaymentID) REFERENCES PaymentMethod(PaymentID),
  FOREIGN KEY (FirstName, LastName, Address, Gender) REFERENCES Customer(FirstName, LastName, Address, Gender)
);


-- Invoice Item Table
CREATE TABLE InvoiceItem (
  InvoiceID VARCHAR(30) NOT NULL,
  ProductID VARCHAR(20) NOT NULL,
  Quantity INT NOT NULL,
  PRIMARY KEY (InvoiceID, ProductID),
  FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

