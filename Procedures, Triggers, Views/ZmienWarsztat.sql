USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[ZmienWarsztat]    Script Date: 1/12/2015 8:30:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Zmienamy dane warsztatu, nie mozna dac w ten sposob mniej miejsc
ALTER PROCEDURE [dbo].[ZmienWarsztat] 
@id int,
@nazwa varchar (80),
@liczbaMiejsc int,
@cena money
AS BEGIN
SET NOCOUNT ON; 
if (@liczbaMiejsc < (select [Liczba miejsc] from Warsztaty where @id = id))
begin
update Konferencje
set [Nazwa Konferencji] = @Nazwa,
	[Liczba miejsc] = @liczbaMiejsc,
	[Cena za dzien] = @Cena
where @id = id
end
END
