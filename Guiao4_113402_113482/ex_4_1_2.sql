```sql
IF OBJECT_ID ('VOOS_FARE','U') IS NOT NULL
    DROP TABLE dbo.VOOS_FARE;
IF OBJECT_ID ('VOOS_SEATS','U') IS NOT NULL
    DROP TABLE dbo.VOOS_SEATS;
IF OBJECT_ID ('VOOS_LEG_INSTANCE','U') IS NOT NULL
    DROP TABLE dbo.VOOS_LEG_INSTANCE;
IF OBJECT_ID ('VOOS_FLIGHT_LEG','U') IS NOT NULL
    DROP TABLE dbo.VOOS_FLIGHT_LEG;
IF OBJECT_ID ('VOOS_FLIGHT','U') IS NOT NULL
    DROP TABLE dbo.VOOS_FLIGHT;
IF OBJECT_ID ('VOOS_AIRPLANE','U') IS NOT NULL
    DROP TABLE dbo.VOOS_AIRPLANE;
IF OBJECT_ID ('VOOS_CAN_LAND','U') IS NOT NULL
    DROP TABLE dbo.VOOS_CAN_LAND;
IF OBJECT_ID ('VOOS_AIRPLANE_TYPE','U') IS NOT NULL
    DROP TABLE dbo.VOOS_AIRPLANE_TYPE;
IF OBJECT_ID ('VOOS_AIRPORT','U') IS NOT NULL
    DROP TABLE dbo.VOOS_AIRPORT;


CREATE TABLE VOOS_AIRPORT(
	City			VARCHAR(10)			NOT NULL,
	State			VARCHAR(10)			NOT NULL,
	[Name]			VARCHAR(64)			NOT NULL,
	Code			INT					NOT NULL,
	PRIMARY KEY (Code)
);

CREATE TABLE VOOS_AIRPLANE_TYPE(
	[Type_name]			VARCHAR(64)			NOT NULL,
	Max_seats			INT					NOT NULL,
	[Company]			VARCHAR(64)			NOT NULL,
	PRIMARY KEY ([Type_name])
);

CREATE TABLE VOOS_CAN_LAND(
	Airport_code				INT					NOT NULL,
	[Airplane_Type_Type_name]	VARCHAR(64)			NOT NULL,
	PRIMARY KEY (Airport_code, [Airplane_Type_Type_name]),
	FOREIGN KEY (Airport_code)				REFERENCES VOOS_AIRPORT(Code),
	FOREIGN KEY (Airplane_Type_Type_name)	REFERENCES VOOS_AIRPLANE_TYPE([Type_name])
);

CREATE TABLE VOOS_AIRPLANE(
	Airplane_id					INT				NOT NULL,
	Total_no_of_seats			INT				NOT NULL,
	[Airplane_Type_Type_name]	VARCHAR(64)		NOT NULL
	PRIMARY KEY (Airplane_id),
	FOREIGN KEY ([Airplane_Type_Type_name])	REFERENCES VOOS_AIRPLANE_TYPE([Type_name])
);

CREATE TABLE VOOS_FLIGHT(
	Number			INT				NOT NULL,
	[Airline]		VARCHAR(64)		NOT NULL,
	[weekdays]		VARCHAR(64)		NOT NULL
	PRIMARY KEY (Number)
);

CREATE TABLE VOOS_FLIGHT_LEG(
	Leg_no					INT				NOT NULL, 
	Flight_Number			INT				NOT NULL,
	Airport_Dep_code		INT				NOT NULL,
	Airport_Arr_code		INT				NOT NULL,
	[Sch_deptime]			INT				NOT NULL,
	[Sch_arrtime]			INT				NOT NULL,
	PRIMARY KEY (Leg_no,Flight_Number),
	FOREIGN KEY (Flight_Number)			REFERENCES VOOS_FLIGHT(Number),
	FOREIGN KEY	(Airport_Dep_code)		REFERENCES VOOS_AIRPORT(Code),
	FOREIGN	KEY	(Airport_Arr_code)		REFERENCES VOOS_AIRPORT(Code)
);

CREATE TABLE VOOS_LEG_INSTANCE(
	[Date]						INT				NOT NULL,
	Airplane_Airplane_id		INT				NOT NULL,
	No_of_avail_seats			INT				NOT NULL,
	Airport_Dep_code			INT				NOT NULL,
	Airport_Arr_code			INT				NOT NULL,
	[deptime]					INT				NOT NULL,
	[arrtime]					INT				NOT NULL,
	Flight_Leg_Flight_Number	INT				NOT NULL,
	Flight_Leg_Leg_no			INT				NOT NULL,
	PRIMARY KEY([Date], Flight_Leg_Flight_Number, Flight_Leg_leg_no),
	FOREIGN KEY(Airplane_Airplane_id)		REFERENCES VOOS_AIRPLANE(Airplane_id),
	FOREIGN KEY(Airport_Dep_code)			REFERENCES VOOS_AIRPORT(Code),
	FOREIGN KEY(Airport_Arr_code)			REFERENCES VOOS_AIRPORT(Code),
	FOREIGN KEY(Flight_Leg_leg_no, Flight_Leg_Flight_Number)    REFERENCES VOOS_FLIGHT_LEG(Leg_no, Flight_Number)
);

CREATE TABLE VOOS_SEATS(
	Seat_no									INT				NOT NULL,
	Leg_Instance_Flight_Leg_Flight_Number	INT				NOT NULL,
	Leg_Instance_Flight_Leg_leg_no			INT				NOT NULL,
	[Leg_Instance_Date]						INT				NOT NULL,
	[Costumer_Name]							VARCHAR(64)		NOT NULL,
	Cphone									INT				NOT NULL,
	PRIMARY KEY (Seat_no,Leg_Instance_Flight_Leg_Flight_Number, Leg_Instance_Flight_Leg_leg_no, [Leg_Instance_Date]),
	FOREIGN KEY ( [Leg_Instance_Date], Leg_Instance_Flight_Leg_Flight_Number, Leg_Instance_Flight_Leg_leg_no)	REFERENCES VOOS_LEG_INSTANCE([Date], Flight_Leg_Flight_Number, Flight_Leg_leg_no)
);

CREATE TABLE VOOS_FARE(
	Code				INT				NOT NULL,
	Flight_Number		INT				NOT NULL,
	Amount				INT				NOT NULL,
	Restrictions		VARCHAR(64)		NOT NULL,
	PRIMARY KEY (Code, Flight_Number),
	FOREIGN KEY	(Flight_Number)	REFERENCES VOOS_FLIGHT(Number)
);
```