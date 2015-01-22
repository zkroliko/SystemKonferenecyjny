USE [Konferencje]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Tworzy tabele danych z identyfikatorami dla danego warsztatu
CREATE PROCEDURE [dbo].[IdentyfikatoryRezerwacjiWarsztatu]
    @param int --id warsztatu
AS 
	set nocount on
select o.Imie, o.Nazwisko, isnull(f.[Nazwa Firmy], 'Osoba prywatna') as "Firma", o.Foto as "Sciezka do zdjecia" from [Uczestnicy konferencji] as uk
inner join Osoby as o
on o.id = uk.OsobaID
inner join Klienci as k
on k.id = uk.KlientID
inner join Firmy as f
on k.id = f.KlientID
-- Warunek na warsztat
where o.id in (
	select o.id from Osoby as o 
	inner join [Uczestnicy konferencji] as uk
	on uk.id = uk.OsobaID
	inner join [Uczestnicy] as u
	on u.RezerwacjaID = uk.id
	inner join [Rezerwacje warsztatow] as wk
	on wk.id = u.RezerwacjaID
	where wk.id = @param
)
GO

