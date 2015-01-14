USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[DodajRezerwacjeKonf]    Script Date: 2015-01-14 15:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[ZmienRezerwacjeKonf] 
@KlientID int,
@KonfID int,
@DataRezerwacji Date,
@Studenci int,
@Normalne int,
@anulowano bit

AS BEGIN
SET NOCOUNT ON; 

update [Rezerwacje konferencji] set KlientID=@KlientID,KonferencjaDzienId=@KonfID,[Data rezerwacji]=@DataRezerwacji,Studenci=@Studenci,Normalne=@Normalne,anulowano=@anulowano
END
