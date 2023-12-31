USE [master]
GO
/****** Object:  Database [BaseTaxi]    Script Date: 06.10.2023 23:30:56 ******/
CREATE DATABASE [BaseTaxi]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BaseTaxi', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\BaseTaxi.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BaseTaxi_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\BaseTaxi_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [BaseTaxi] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BaseTaxi].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BaseTaxi] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BaseTaxi] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BaseTaxi] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BaseTaxi] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BaseTaxi] SET ARITHABORT OFF 
GO
ALTER DATABASE [BaseTaxi] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BaseTaxi] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [BaseTaxi] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BaseTaxi] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BaseTaxi] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BaseTaxi] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BaseTaxi] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BaseTaxi] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BaseTaxi] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BaseTaxi] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BaseTaxi] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BaseTaxi] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BaseTaxi] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BaseTaxi] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BaseTaxi] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BaseTaxi] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BaseTaxi] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BaseTaxi] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BaseTaxi] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BaseTaxi] SET  MULTI_USER 
GO
ALTER DATABASE [BaseTaxi] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BaseTaxi] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BaseTaxi] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BaseTaxi] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [BaseTaxi]
GO
/****** Object:  StoredProcedure [dbo].[Driver_OrdersPerMonth]    Script Date: 06.10.2023 23:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Driver_OrdersPerMonth]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(order_id) AS Orders,
		   driver_name 
		   FROM TaxiDriver
				INNER JOIN TaxiTable
					 ON TaxiDriver.driver_id = TaxiTable.table_driver_id
				INNER JOIN TaxiOrder
					 ON TaxiTable.table_id = TaxiOrder.order_table_id
	WHERE TaxiTable.table_date_start >= DATEADD(MONTH, -1, GETDATE())
	GROUP BY driver_name
END

GO
/****** Object:  StoredProcedure [dbo].[order_byMonth]    Script Date: 06.10.2023 23:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[order_byMonth]
    @month int,
    @year int
AS
    SELECT driver_name 
		   FROM TaxiDriver
				INNER JOIN TaxiTable
					 ON TaxiDriver.driver_id = TaxiTable.table_driver_id
				INNER JOIN TaxiOrder
					 ON TaxiTable.table_id = TaxiOrder.order_table_id
	WHERE DatePart(YEAR, table_date_start) = @year AND DatePart(MONTH, table_date_start) = @month
	GROUP BY driver_name

GO
/****** Object:  Table [dbo].[TaxiCar]    Script Date: 06.10.2023 23:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxiCar](
	[car_id] [int] IDENTITY(1,1) NOT NULL,
	[car_number] [nchar](10) NOT NULL,
	[car_brand] [nchar](30) NOT NULL,
	[car_color] [nchar](15) NOT NULL,
 CONSTRAINT [PK_Автомобиль] PRIMARY KEY CLUSTERED 
(
	[car_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaxiDriver]    Script Date: 06.10.2023 23:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxiDriver](
	[driver_id] [int] IDENTITY(1,1) NOT NULL,
	[driver_name] [nchar](50) NOT NULL,
	[driver_passport] [nchar](20) NOT NULL,
	[driver_phone] [nchar](20) NOT NULL,
	[driver_score_count] [int] NOT NULL,
	[driver_score_average] [float] NOT NULL,
	[driver_raiting] [float] NOT NULL,
 CONSTRAINT [PK_Водитель] PRIMARY KEY CLUSTERED 
(
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaxiOperator]    Script Date: 06.10.2023 23:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxiOperator](
	[operator_id] [int] IDENTITY(1,1) NOT NULL,
	[operator_name] [nchar](50) NOT NULL,
	[operator_phone] [nchar](20) NOT NULL,
 CONSTRAINT [PK_Operator] PRIMARY KEY CLUSTERED 
(
	[operator_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaxiOrder]    Script Date: 06.10.2023 23:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxiOrder](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[order_phone] [nchar](20) NOT NULL,
	[order_destination] [nchar](100) NOT NULL,
	[order_cost] [int] NOT NULL,
	[order_driver_score] [int] NOT NULL,
	[order_table_id] [int] NOT NULL,
	[order_operator_id] [int] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaxiTable]    Script Date: 06.10.2023 23:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxiTable](
	[table_id] [int] IDENTITY(1,1) NOT NULL,
	[table_date_start] [smalldatetime] NOT NULL,
	[table_date_final] [smalldatetime] NOT NULL,
	[table_driver_id] [int] NOT NULL,
	[table_car_id] [int] NOT NULL,
 CONSTRAINT [PK_Table] PRIMARY KEY CLUSTERED 
(
	[table_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[TaxiOrder]  WITH CHECK ADD  CONSTRAINT [FK_Order_Operator] FOREIGN KEY([order_operator_id])
REFERENCES [dbo].[TaxiOperator] ([operator_id])
GO
ALTER TABLE [dbo].[TaxiOrder] CHECK CONSTRAINT [FK_Order_Operator]
GO
ALTER TABLE [dbo].[TaxiOrder]  WITH CHECK ADD  CONSTRAINT [FK_Order_Table] FOREIGN KEY([order_table_id])
REFERENCES [dbo].[TaxiTable] ([table_id])
GO
ALTER TABLE [dbo].[TaxiOrder] CHECK CONSTRAINT [FK_Order_Table]
GO
ALTER TABLE [dbo].[TaxiTable]  WITH CHECK ADD  CONSTRAINT [FK_Table_Car] FOREIGN KEY([table_car_id])
REFERENCES [dbo].[TaxiCar] ([car_id])
GO
ALTER TABLE [dbo].[TaxiTable] CHECK CONSTRAINT [FK_Table_Car]
GO
ALTER TABLE [dbo].[TaxiTable]  WITH CHECK ADD  CONSTRAINT [FK_Table_Driver] FOREIGN KEY([table_driver_id])
REFERENCES [dbo].[TaxiDriver] ([driver_id])
GO
ALTER TABLE [dbo].[TaxiTable] CHECK CONSTRAINT [FK_Table_Driver]
GO
USE [master]
GO
ALTER DATABASE [BaseTaxi] SET  READ_WRITE 
GO
