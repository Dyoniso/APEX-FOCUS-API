# Implementação da API Focus NFE no APEX de forma simples.

Olá, sabendo da complexidade que é emitir notas fiscais no Apex, desenvolvi alguns
Pacotes que irá automatizar todo esse processo para você.

## Requerimentos:
1. Oracle APEX.
2. Acesso ao Focus API.
3. Empresa Autorizada para Emissão de Notas Fiscais na SEFAZ.

## Sumário:
1. Separar informações da API.
2. Instalar Pacotes no Apex.
3. Criar tableas atribuídas aos Pacotes.
4. Especificações do Script.

# Separar Informações da API:

Primeiro separe o Endpoint(Url-Padrão), versão e Token de Autorização da API.
Para mais informações consulte a [documentação](https://focusnfe.com.br/doc/?shell#introducao_autenticacao) da Focus API.

!- Certifique-se de está utilizando o Token de Homologação, para a emissão de notas com o objetivo de testar a aplicação.

# Instalar Pacotes no Apex:

Logue com sua conta no Apex, entre em **SQL Workshop** > **Browser Objects** e selecione a aba **PACOTES**.
Dentro da aba **PACOTES**, adicione os pacotes atribuidos a esse Repositório. Compile os pacotes, se tudo estiver bem, aparecerá uma
mensagem de sucesso.

# Criar tabelas atribuídas ao Script:

Entre em **SQL Workshop** > **SQL Commands** e execute os Scripts SQL na pasta **tables** do repositório. Essas tabelas são responsáveis por amazenar dados da emissão e consulta de notas que a API Oferece.

# Especificações do Script:

## NFE

**DADOS FICTÍCIOS**
``` 
OK_PKG_FOCUS_API_NFE.CREATE_NOTA_MODEL(
    l_natureza_operacao => 'Remessa',
    l_tipo_documento => 1,
    l_finalidade_emissao => 1,
    l_cnpj_emitente => '51916585000125',
    l_nome_emitente => 'ACME LTDA',
    l_nome_fantasia_emitente => 'ACME LTDA',
    l_logradouro_emitente => 'R. Padre Natal Pigato',
    l_numero_emitente => 100,
    l_bairro_emitente => 'Santa Felicidade',
    l_municipio_emitente => 'Curitiba',
    l_uf_emitente => 'PR',
    l_cep_emitente => '82320030',
    l_inscricao_estadual_emitente => '1234567',
    l_nome_destinatario => 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',
    l_cpf_destinatario => '51966818092',
    l_telefone_destinatario => '1196185555',
    l_logradouro_destinatario => 'Rua S\u005Cu00e3o Janu\u005Cu00e1rio',
    l_numero_destinatario => 99,
    l_bairro_destinatario => 'Crespo',
    l_municipio_destinatario => 'Manaus',
    l_uf_destinatario => 'AM',
    l_pais_destinatario => 'Brasil',
    l_cep_destinatario => '69073178',
    l_valor_frete => 0,
    l_valor_seguro => 0,
    l_valor_total => 47.23,
    l_valor_produtos => 47.23,
    l_modalidade_frete => 0
);
``` 
Cria um Modelo padrão da NFE e amazena na tabela. Retorna uma referência da Nota. 

**DADOS FICTÍCIOS**
```
OK_PKG_FOCUS_API_NFE.ADD_PRODUTO_NOTA(
    l_nota_ref => 'REFERÊNCIA DA NOTA',
    l_codigo_produto => 1,
    l_descricao => 'Cartu00f5es de Visita',
    l_cfop => 6923,
    l_unidade_comercial => 'un',
    l_quantidade_comercial => 100,
    l_valor_unitario_comercial => 0.4723,
    l_valor_unitario_tributavel => 0.4723,
    l_unidade_tributavel => 'un',
    l_codigo_ncm => 49111090,
    l_quantidade_tributavel => 100,
    l_valor_bruto => 47.23,
    l_icms_situacao_tributaria => 400,
    l_icms_origem => 0,
    l_pis_situacao_tributaria => '07',
    l_cofins_situacao_tributaria => '07'
);
``` 
Adiciona produtos ao Modelo da NFE. É necessário informar a Referência da Nota em ```l_nota_ref```.

```
OK_PKG_FOCUS_API_NFE.EMITIR_NOTA_MODEL(l_ref => 'REFERÊNCIA DA NOTA');
```
Executa uma requisição na API para a emissão de NFE. É opcional informar a Referência da Nota em ```l_ref```,
caso não informar o sistema processará todos os Modelos de NFE que ainda não foi enviado.

```
OK_PKG_FOCUS_API_NFE.CONSULTAR_NOTA(l_ref => 'REFERÊNCIA DA NOTA');
```
Executa uma requisição na API para a consulta da NFE. É necessário informar a Referência da Nota em ```l_ref```.

```
OK_PKG_FOCUS_API_NFE.UPDATE_NOTA_MODEL(l_ref => 'REFERÊNCIA DA NOTA');
```
Sicroniza as informações amazenadas na API com o banco de dados do APEX. (Nessário Realizar um Job a cada 1 minuto, para sicronizar as informações
em tempo real).

## NFSE

```
OK_PKG_FOCUS_API_NFSE.INIT_NFSE;
```
Cria um novo modelo de NFSE na tabela local do Apex. Retorna uma Referência da Nota.

**DADOS FICTÍCIOS**
```
OK_PKG_FOCUS_API_NFSE.CREATE_PRESTADOR_MODEL(
    l_ref => 'REFERÊNCIA DA NOTA',
    l_cnpj => '51916585000125',
    l_inscricao_municipal => '12345',
    l_codigo_municipio => '3518800'
);
```
Cria o objeto 'PRESTADOR' no modelo da Nota armazenado. Necessário informar a Referência da Nota.

**DADOS FICTÍCIOS**
```
OK_PKG_FOCUS_API_NFSE.CREATE_TOMADOR_MODEL(
    l_ref => 'REFERÊNCIA DA NOTA',
    l_cnpj => '07504505000132',
    l_razao_social => 'Acras Tecnologia da Informação LTDA',
    l_email => 'contato@acras.com.br',
    l_endereco_logradouro => 'Rua Dias da Rocha Filho',
    l_endereco_numero => 999,
    l_endereco_complemento => 'Prédio 04 - Sala 34C',
    l_endereco_bairro => 'Alto da XV',
    l_endereco_codigo_municipio => '4106902',
    l_endereco_uf => 'PR',
    l_endereco_cep => '80045165'
);
```
Cria o objeto 'TOMADOR' no modelo da Nota armazenado. Necessário informar a Referência da Nota.

**DADOS FICTÍCIOS**
```
OK_PKG_FOCUS_API_NFSE.CREATE_SERVICO_MODEL(
    l_ref => 'REFERÊNCIA DA NOTA',
    l_aliquota => 3,
    l_discriminacao => 'Nota fiscal referente a servicos prestados',
    l_iss_retido => 0,
    l_item_lista_servico => '1401',
    l_codigo_tributario_municipio => '452000100',
    l_valor_servicos => 1.0
);
```
Cria o objeto 'SERVICO' no modelo da Nota armazenado. Necessário informar a Referência da Nota.

```
OK_PKG_FOCUS_API_NFSE.EMITIR_NOTA_MODEL(l_ref => 'REFERÊNCIA DA NOTA')
```
Executa uma requisição na API para a emissão de NFSE. É opcional informar a Referência da Nota em ```l_ref```,
caso não informar o sistema processará todos os Modelos de NFSE que ainda não foi enviado.

```
OK_PKG_FOCUS_API_NFSE.CONSULTAR_NOTA_MODEL(l_ref => 'REFERÊNCIA DA NOTA')
```
Executa uma requisição na API para a consulta da NFSE. É necessário informar a Referência da Nota em ```l_ref```.

```
OK_PKG_FOCUS_API_NFSE.UPDATE_NOTA_MODEL(l_ref => 'REFERÊNCIA DA NOTA');
```
Sicroniza as informações amazenadas na API com o banco de dados do APEX. (Nessário Realizar um Job a cada 1 minuto, para sicronizar as informações
em tempo real).

Espero que o código listado aqui te ajude!
Bom Hacking ~Dyoniso.

