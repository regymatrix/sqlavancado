USE [MGPD]
GO
/****** Object:  Trigger [dbo].[PedidoAprovadoGerarOrdem]    Script Date: 25/10/2022 23:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER trigger [dbo].[PedidoAprovadoGerarOrdem] on [dbo].[MGPD_ITENSPEDIDO]
after insert
as
begin  
  SET NOCOUNT ON  
  declare @Status int,
		  @DataInicio datetime,
		  @DataPrevista datetime,
		  @Pedido int,
		  @Item int,
		  @Produto int,
		  @fase int,
		  @contfase int,
		  @cont int
		  		  
  select @PEDIDO=PEDID    from inserted
  
  select @DataPrevista=PEDDATAPREVISTA  from MGPD_PEDIDO
  
  select @Status=inserted.STIID,@item=inserted.ITEID,@Produto=inserted.PROID from inserted
  
  
  if @Status=2
  begin            
       insert MGPD_ORDEMPRODUCAO (ORDDATAINICIO,ORDDATAPREVISTA,STAID,ITEID) VALUES (GETDATE(),@DataPrevista,1,@Item)    					  
       
       set @contfase = (select COUNT(FASID) from MGPD_FASEPRODUTO where PROID=@Produto)
       set @cont=1
       if @contfase >0 
       begin
           while @cont<=@contfase
           begin
             insert MGPD_ORDEMPRODUCAOFASE (FASID,ORDID,COLID,SHFID) values (1,1,1,1)
             
             
           end
       end
       
       
  end --fim do se do status
  
  

end


