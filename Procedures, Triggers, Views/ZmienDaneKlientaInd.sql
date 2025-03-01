USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[ZmienDaneKlientaInd]    Script Date: 1/12/2015 8:14:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Zmienia dane klienta indywidualnego, zmienia osobe na nowa, oraz zmienia takze adres na nowy
ALTER PROCEDURE [dbo].[ZmienDaneKlientaInd] 
@id int, --id Klienta
@Name varchar(50),
@LastName varchar(50),
@Phone varchar(12),
@DateOfBirth Date,
@Sex bit,
@NrLeg nvarchar(10),
@NazwaFirmy varchar(25),
@TelFirm varchar(12),
@Fax varchar(12),
@Email varchar(50), 
@Login varchar(30), 
@Password varchar(20),
@Country varchar(50),
@Miasto varchar(50),
@KodPocztowy varchar(12),
@Ulica varchar(35),
@NrBud int, 
@NrMiesz int  
AS BEGIN
SET NOCOUNT ON; 
--Deklaracja zmiennych
DECLARE @OsobaID int
DECLARE @AdresID int
DECLARE @KlientID int
--Sprawdzenie czy to w ogole osoba ind
if (select CzyFirma from Klienci where id = @id) = 0
begin
--Dodanie nowej osoby
Exec dbo.DodajOsobe @Name ,@LastName ,@Phone ,@DateOfBirth ,@Sex,@NrLeg,@Country,@Miasto,@KodPocztowy,@Ulica,@NrBud,@NrMiesz 
SET @OsobaID =(Select id from Osoby where @Name = Imie and @LastName = Nazwisko and Plec = @Sex and [Legitymacja studencka nr] = @NrLeg)
--Dodanie nowego adresu
EXEC dbo.DodajAdres @Country,@Miasto,@KodPocztowy,@Ulica,@NrBud,@NrMiesz
--Znalezenie nowego adresu
SET @AdresID =(select A.id from Adresy as A 
	inner join Miasta  as M on A.MiastoID=M.id
	inner join Kraje as K on K.id=M.KrajID
	Where  A.[Numer budynku]=@NrBud and isnull(A.[Numer mieszkania],0) = isnull(@NrMiesz,0) and A.Ulica=@Ulica and M.Miasto=@Miasto And M.[Kod Pocztowy]=@KodPocztowy and K.Nazwa=@Country)
--Ustalenie danych w tablicy Klienci
update Klienci
set Login = @Login,
	Password = @Password,
	Email = @Email,
	OsobaID= @OsobaID
where id = @id
--Koniec
end
END
