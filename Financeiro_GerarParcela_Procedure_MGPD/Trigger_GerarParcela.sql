USE [MGPD]
GO
/****** Object:  Trigger [dbo].[GerarParcela]    Script Date: 06/16/2012 05:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER trigger [dbo].[GerarParcela]  ON  [dbo].[CONTAAPAGAR]   for insert
AS 
BEGIN
 SET NOCOUNT ON;
 declare 
	@PriVenc date,
	@IDConta int,
	@Variacao int,
	@VariID int,
	@QTDParc int,
	@Valor money,
	@ValorParc real,
	@Ajuste real,
	@Par1 money,
	@ParX money,
	@DiaFixo bit,
	@Decimais varchar(20),
	@ParTexto varchar(20)
	
 select 
	@IDConta = COTID, @PriVenc = COTDATAVENCIMENTO,
	@QTDParc = COTPARCELAS, @DiaFixo = COTDIAFIXO,
	@Valor = COTVALORCONTRATADO,@VariID = CALID  from inserted
	
   set @ValorParc = @Valor / @QTDParc  
   set @ParTexto = CAST(@ValorParc as varchar(20)) 
   set @Decimais = SUBSTRING(@ParTexto,charindex('.',@ParTexto),len(@ParTexto))
   if  @DiaFixo = 0
   select @Variacao = CALDIAS  from CALENDARIOVENCIMENTO WHERE CALID = @VariID
   
   if LEN(@Decimais)> 3
   begin    
     set @Par1 = cast(substring(@ParTexto,1, CHARINDEX('.',@ParTexto)+2) as real)
     set @Ajuste = @Valor - (@Par1 * @QTDParc)
     set @ParX = @Par1 + @Ajuste      
   end else
   begin
     set @Par1 = (@Valor) /@QTDParc
     set @ParX = @Par1
   end
  	
  /*Cadastrando Parcelas  P = Contas a Pagar e R = Contas a Receber */	
  exec CadastrarParcela 'P',@QTDParc,@PriVenc,@Par1,@ParX,@DiaFixo,@IDConta,@Variacao
 
END
