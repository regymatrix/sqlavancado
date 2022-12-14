USE [MGPD]
GO
/****** Object:  StoredProcedure [dbo].[CadastrarParcela]    Script Date: 25/10/2022 22:56:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[CadastrarParcela] (@TipoConta char(1),@ParcQTD int,@Parc1Data Date, @ValPar1 money,@ValParX money,@Fixo bit,@Conta int,@Variacao int)
as
begin
   declare @P int
   set @P = 0
   if @TipoConta = 'P'
   begin /*Contas a pargar*/
   if @Fixo = 1
   begin /*Parcela com dia fixo*/
     while @P < @ParcQTD 
     begin
        if (@P + 1 = 1) and (@ParcQTD <> 1)/* Primeira de muitas*/
        begin
			insert into CONTAPAGARITENS values
			(@P + 1,null,@ValPar1,@Parc1Data,null,null,null,null,null,null,@Conta,null)    
		end
		if (@P + 1 = 1) and (@ParcQTD = 1)/*Parcela única*/
        begin
			insert into CONTAPAGARITENS values
			(@P + 1,null,@ValParX,@Parc1Data,null,null,null,null,null,null,@Conta,null)    
		end
		if (@P + 1 <> 1) and (@P +1 = @ParcQTD)/*Ultima parcela de muitas*/
		begin
			insert into CONTAPAGARITENS values
			(@P + 1,null,@ValParX,dateadd(M,@P,@Parc1Data),null,null,null,null,null,null,@Conta,null)    
		end
		if (@P + 1 >1) and (@P + 1 <>@ParcQTD )/*Parcela 2 ate a penultima*/
		begin
		   insert into CONTAPAGARITENS values
			(@P + 1,null,@ValPar1,dateadd(M,@P,@Parc1Data),null,null,null,null,null,null,@Conta,null)    
		end
		set @P = @P + 1
     end 
   end else	/*Fim parcela com dia fixo*/ 
   begin /*Parcela com dia variável*/
     while @P < @ParcQTD 
     begin
        declare @UltimaData date
        if (@P + 1 = 1) and (@ParcQTD <> 1)/* Primeira de muitas*/
        begin
			insert into CONTAPAGARITENS values
			(@P + 1,null,@ValPar1,@Parc1Data,null,null,null,null,null,null,@Conta,null)
			set @UltimaData = @Parc1Data
		end 
		if (@P + 1 = 1) and (@ParcQTD = 1)/*Parcela única*/
        begin
			insert into CONTAPAGARITENS values
			(@P + 1,null,@ValParX,@Parc1Data,null,null,null,null,null,null,@Conta,null) 			
		end
		if (@P + 1 <> 1) and (@P +1 = @ParcQTD)/*Ultima parcela de muitas*/
		begin
			insert into CONTAPAGARITENS values
			(@P + 1,null,@ValParX,dateadd(D,@Variacao ,@UltimaData),null,null,null,null,null,null,@Conta,null)    
			set @UltimaData = dateadd(D,@Variacao,@UltimaData)
		end
		if (@P + 1 >1) and (@P + 1 <>@ParcQTD )/*Parcelas 2 ate penultima*/
		begin
		   insert into CONTAPAGARITENS values
			(@P + 1,null,@ValPar1,dateadd(D,@Variacao ,@UltimaData),null,null,null,null,null,null,@Conta,null)    
			set @UltimaData = dateadd(D,@Variacao ,@UltimaData)
		end
		set @P = @P + 1
     end    
   end			/*Fim parcela com dia variável*/
   end else		/*Fim Contas a pargar*/
   begin
    /*Contas a receber*/
    print 'desenvolver! contas a receber'
   end
end

