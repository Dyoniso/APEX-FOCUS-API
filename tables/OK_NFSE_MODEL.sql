CREATE TABLE  "OK_NFSE_MODEL" 
   (	"ID_NFSE_MODEL" NUMBER GENERATED BY DEFAULT AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"DATA_EMISSAO" VARCHAR2(30), 
	"PRESTADOR_CNPJ" VARCHAR2(30), 
	"PRESTADOR_INSCRICAO_MUNICIPAL" VARCHAR2(20), 
	"PRESTADOR_CODIGO_MUNICIPIO" VARCHAR2(20), 
	"TOMADOR_CNPJ" VARCHAR2(20), 
	"TOMADOR_RAZAO_SOCIAL" VARCHAR2(200), 
	"TOMADOR_EMAIL" VARCHAR2(100), 
	"TOMADOR_ENDERECO_LOGRADOURO" VARCHAR2(400), 
	"TOMADOR_ENDRECO_NUMERO" NUMBER, 
	"TOMADOR_ENDERECO_COMPLEMENTO" VARCHAR2(400), 
	"TOMADOR_ENDERECO_BAIRRO" VARCHAR2(200), 
	"TOMADOR_ENDERECO_CODIGO_MUNICIPIO" VARCHAR2(100), 
	"TOMADOR_ENDERECO_UF" VARCHAR2(20), 
	"TOMADOR_ENDERECO_CEP" VARCHAR2(20), 
	"SERVICO_ALIQUOTA" FLOAT(126), 
	"SERVICO_DISCRIMINACAO" VARCHAR2(400), 
	"SERVICO_ISS_RETIDO" NUMBER, 
	"SERVICO_ITEM_LISTA_SERVICO" VARCHAR2(30), 
	"SERVICO_CODIGO_TRIGUTARIO_MUNICIPIO" VARCHAR2(30), 
	"VALOR_SERVICOS" FLOAT(126), 
	"STATUS" VARCHAR2(200) NOT NULL ENABLE, 
	"CAMINHO_XML_NOTA_FISCAL" VARCHAR2(200), 
	"CAMINHO_DANFSE" VARCHAR2(200), 
	"OBJ_KEY" VARCHAR2(4) NOT NULL ENABLE, 
	"JSON_ERRORS" VARCHAR2(4000), 
	"URL" VARCHAR2(200), 
	"URL_DANFSE" VARCHAR2(200), 
	 CONSTRAINT "OK_NFSE_MODEL_PK" PRIMARY KEY ("ID_NFSE_MODEL")
  USING INDEX  ENABLE
   )
/

CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_OK_NFSE_MODEL" 
  before insert on "OK_NFSE_MODEL"               
  for each row  
begin   
  if :NEW."ID_NFSE_MODEL" is null then 
    select "OK_NFSE_MODEL_SEQ".nextval into :NEW."ID_NFSE_MODEL" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_OK_NFSE_MODEL" ENABLE
/
