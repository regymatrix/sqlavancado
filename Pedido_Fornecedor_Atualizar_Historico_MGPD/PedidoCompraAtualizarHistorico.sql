USE [MGPD]
GO
/****** Object:  Trigger [dbo].[PedidoCompraAtualizarHistorico]    Script Date: 25/10/2022 23:58:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER trigger [dbo].[PedidoCompraAtualizarHistorico] on [dbo].[MGPD_ITENSPEDIDOFORNECEDO]
after insert
as
begin  
  SET NOCOUNT ON  
  declare @Status int,
		  @CLIID int,
     	  @INSID INT,
     	  @PEDIDO INT,
     	  @QTD real,
     	  @Preco real,
     	  @Total real,
     	  @QtdAcumulada real,     	 
     	  @TotalAcumulado real		  	 
		  
  select @PEDIDO=PEFID from inserted
  
  select @CLIID=CLIID,@Status=STAID from MGPD_PEDIDOFORNECEDOR
  where PEFID=@PEDIDO
 
  
  
  /*Recuperar cód do insumo e  a quantidade solicitada*/
  select @INSID=INSID,@QTD=ITFQUANTIDADE,@Preco=ITFPRECO,@Total=ITFQUANTIDADE*ITFPRECO   
  FROM inserted
  
  if @Status=2
  begin 
 
    if exists(select INSID FROM MGPD_CLIENTEINSUMO WHERE INSID = @INSID AND CINPEDIDO=@PEDIDO)
    begin  
				
		 update MGPD_CLIENTEINSUMO
		       set CINQUANTIDADE=@QTD,CINPRECO=@Preco,CINVALORPEDIDO=@QTD*@Preco,
		       INSID=@INSID, CINPEDIDO=@PEDIDO		    
		        where INSID=@INSID   AND CLIID=CLIID
     end else
     begin
     
        insert MGPD_CLIENTEINSUMO values (@CLIID,@INSID,@PEDIDO,@QTD,@Preco,@Total)     
     
     end
     
  end --fim do se do status
  
  
 

end





