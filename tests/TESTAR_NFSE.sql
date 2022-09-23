DECLARE
    v_ref number;
BEGIN
    v_ref := OK_PKG_FOCUS_API_NFSE.INIT_NFSE;

    -- CRIAR MODELO NOTA DE SERVIÇO

    OK_PKG_FOCUS_API_NFSE.CREATE_PRESTADOR_MODEL(
        l_ref => v_ref,
        l_cnpj => '51916585000125',
        l_inscricao_municipal => '12345',
        l_codigo_municipio => '3518800'
    );

    OK_PKG_FOCUS_API_NFSE.CREATE_TOMADOR_MODEL(
        l_ref => v_ref,
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

    OK_PKG_FOCUS_API_NFSE.CREATE_SERVICO_MODEL(
        l_ref => v_ref,
        l_aliquota => 3,
        l_discriminacao => 'Nota fiscal referente a servicos prestados',
        l_iss_retido => 0,
        l_item_lista_servico => '1401',
        l_codigo_tributario_municipio => '452000100',
        l_valor_servicos => 1.0
    );

    -- EMITIR NOTA
    
    DBMS_OUTPUT.PUT_LINE(OK_PKG_FOCUS_API_NFSE.EMITIR_NOTA_MODEL(l_ref => v_ref));

    -- ATUALIZAR STATUS DA NOTA

    OK_PKG_FOCUS_API_NFSE.UPDATE_NOTA_MODEL(l_ref => v_ref);
END;
