USE [MGPD]
GO
/****** Object:  Trigger [dbo].[PedidoInsumoEmCompraInserindo]    Script Date: 26/10/2022 00:00:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER trigger [dbo].[PedidoInsumoEmCompraInserindo] on [dbo].[MGPD_ITENSPEDIDOFORNECEDO]
after insert
as
begin  
  SET NOCOUNT ON  
  declare @Status int,
		  @CLIID int,
     	  @INSID INT,
     	  @PEDIDO INT,
     	  @QTDemCompra real
     	  
		  
  select @PEDIDO=PEFID from inserted
  
  select @CLIID=CLIID,@Status=STAID from MGPD_PEDIDOFORNECEDOR
  where PEFID=@PEDIDO
 
  
   /*Recuperar cód do insumo e  a quantidade solicitada*/
  select @INSID=INSID,@QTDemCompra=ITFQUANTIDADE  FROM inserted
  
  
  
  if @Status=2
  begin 
    if exists(select INSID FROM INSUMO WHERE INSID = @INSID)
    begin  
		update INSUMO
		       set INSEMCOMPRA=INSEMCOMPRA+@QTDemCompra
		        where INSID=@INSID
    end
   end --fim do se do status
  
  
 

end




