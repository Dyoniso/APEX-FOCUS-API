create or replace package OK_PKG_FOCUS_API_NFE as

    function FETCH_CEP(l_cep IN varchar2) return varchar2;

    function EMITIR_NOTA_MODEL(l_ref number) return varchar2;

    procedure JOB_UPDATE_NOTA;

    procedure UPDATE_NOTA_MODEL(l_ref number);

    function CONSULTAR_NOTA(l_ref number) return varchar2;

    procedure UPDATE_NOTA_STATUS(
        l_ref number,
        l_status varchar2
    );
    
    function CREATE_NOTA_MODEL(
        l_natureza_operacao varchar2,
        l_tipo_documento number,
        l_finalidade_emissao number,
        l_cnpj_emitente varchar2,
        l_nome_emitente varchar2,
        l_nome_fantasia_emitente varchar2,
        l_logradouro_emitente varchar2,
        l_numero_emitente number,
        l_bairro_emitente varchar2,
        l_municipio_emitente varchar2,
        l_uf_emitente varchar2,
        l_cep_emitente varchar2,
        l_inscricao_estadual_emitente varchar2,
        l_nome_destinatario varchar2,
        l_cpf_destinatario varchar2,
        l_telefone_destinatario varchar2,
        l_logradouro_destinatario varchar2,
        l_numero_destinatario number,
        l_bairro_destinatario varchar2,
        l_municipio_destinatario varchar2,
        l_uf_destinatario varchar2,
        l_pais_destinatario varchar2,
        l_cep_destinatario varchar2,
        l_valor_frete float,
        l_valor_seguro float,
        l_valor_total float,
        l_valor_produtos float,
        l_modalidade_frete number
    ) return number;
    
    procedure ADD_PRODUTO_NOTA(
        l_nota_ref number,
        l_codigo_produto number,
        l_descricao varchar2,
        l_cfop number,
        l_unidade_comercial varchar2,
        l_quantidade_comercial number,
        l_valor_unitario_comercial float,
        l_valor_unitario_tributavel float,
        l_unidade_tributavel varchar2,
        l_codigo_ncm number,
        l_quantidade_tributavel number,
        l_valor_bruto float,
        l_icms_situacao_tributaria number,
        l_icms_origem number,
        l_pis_situacao_tributaria varchar2,
        l_cofins_situacao_tributaria varchar2
    );

end OK_PKG_FOCUS_API_NFE;

create or replace package body OK_PKG_FOCUS_API_NFE as
    --
    v_notamodel clob;
    --

    function FETCH_CEP(l_cep varchar2) return varchar2 is
        l_res varchar2(4000);
    begin
        OK_PKG_FOCUS_BASE.INIT_DEFAULT_HEADER;

        l_res := apex_web_service.make_rest_request(
           p_url               => OK_PKG_FOCUS_BASE.GET_URL || '/ceps/' || l_cep,
           p_http_method       => 'GET');

        return l_res;
        
    end FETCH_CEP;

    procedure UPDATE_NOTA_STATUS(
        l_ref number,
        l_status varchar2
    ) is
    begin
        UPDATE ok_nfe_model SET
            status = l_status
        WHERE id_nfe_model = l_ref;

        DBMS_OUTPUT.PUT_LINE('Updated Status NFE-' || l_ref);

    end UPDATE_NOTA_STATUS;

    function CREATE_NOTA_MODEL(
        l_natureza_operacao varchar2,
        l_tipo_documento number,
        l_finalidade_emissao number,
        l_cnpj_emitente varchar2,
        l_nome_emitente varchar2,
        l_nome_fantasia_emitente varchar2,
        l_logradouro_emitente varchar2,
        l_numero_emitente number,
        l_bairro_emitente varchar2,
        l_municipio_emitente varchar2,
        l_uf_emitente varchar2,
        l_cep_emitente varchar2,
        l_inscricao_estadual_emitente varchar2,
        l_nome_destinatario varchar2,
        l_cpf_destinatario varchar2,
        l_telefone_destinatario varchar2,
        l_logradouro_destinatario varchar2,
        l_numero_destinatario number,
        l_bairro_destinatario varchar2,
        l_municipio_destinatario varchar2,
        l_uf_destinatario varchar2,
        l_pais_destinatario varchar2,
        l_cep_destinatario varchar2,
        l_valor_frete float,
        l_valor_seguro float,
        l_valor_total float,
        l_valor_produtos float,
        l_modalidade_frete number
    ) return number is
        v_ref_nota number := 0;
        v_exists number := 0;

    begin
        INSERT INTO ok_nfe_model (
           "NATUREZA_OPERACAO",
           "TIPO_DOCUMENTO",
           "FINALIDADE_EMISSAO",
           "CNPJ_EMITENTE",
           "NOME_EMITENTE",
           "NOME_FANTASIA_EMITENTE",
           "LOGRADOURO_EMITENTE",
           "NUMERO_EMITENTE",
           "BAIRRO_EMITENTE",
           "MUNICIPIO_EMITENTE",
           "UF_EMITENTE",
           "CEP_EMITENTE",
           "INSCRICAO_ESTADUAL_EMITENTE",
           "NOME_DESTINATARIO",
           "CPF_DESTINATARIO",
           "TELEFONE_DESTINATARIO",
           "LOGRADOURO_DESTINATARIO",
           "NUMERO_DESTINATARIO",
           "BAIRRO_DESTINATARIO",
           "MUNICIPIO_DESTINATARIO",
           "UF_DESTINATARIO",
           "PAIS_DESTINATARIO",
           "CEP_DESTINATARIO",
           "VALOR_FRETE",
           "VALOR_SEGURO",
           "VALOR_TOTAL",
           "VALOR_PRODUTOS",
           "MODALIDADE_FRETE",
           "STATUS"
        ) VALUES (
            l_natureza_operacao, l_tipo_documento, l_finalidade_emissao, l_cnpj_emitente,
            l_nome_emitente, l_nome_fantasia_emitente, l_logradouro_emitente, l_numero_emitente, l_bairro_emitente,
            l_municipio_emitente, l_uf_emitente, l_cep_emitente, l_inscricao_estadual_emitente, l_nome_destinatario, l_cpf_destinatario,
            l_telefone_destinatario, l_logradouro_destinatario, l_numero_destinatario, l_bairro_destinatario, l_municipio_destinatario, l_uf_destinatario, 
            l_pais_destinatario, l_cep_destinatario, l_valor_frete, l_valor_seguro, l_valor_total, l_valor_produtos, l_modalidade_frete, 'modelo_envio'
        ) RETURNING id_nfe_model INTO v_ref_nota;

        DBMS_OUTPUT.PUT_LINE('NFE criada com sucesso! Ref: ' || v_ref_nota);

        RETURN v_ref_nota;

    end CREATE_NOTA_MODEL;

    procedure ADD_PRODUTO_NOTA(
        l_nota_ref number,
        l_codigo_produto number,
        l_descricao varchar2,
        l_cfop number,
        l_unidade_comercial varchar2,
        l_quantidade_comercial number,
        l_valor_unitario_comercial float,
        l_valor_unitario_tributavel float,
        l_unidade_tributavel varchar2,
        l_codigo_ncm number,
        l_quantidade_tributavel number,
        l_valor_bruto float,
        l_icms_situacao_tributaria number,
        l_icms_origem number,
        l_pis_situacao_tributaria varchar2,
        l_cofins_situacao_tributaria varchar2
    ) is
        ex_ref_not_found EXCEPTION;
        PRAGMA EXCEPTION_INIT( ex_ref_not_found, -4004 );

        v_exists number := 0;
        v_id_model number := 0;
    begin
        BEGIN
            SELECT 1 INTO v_exists FROM ok_nfe_model WHERE id_nfe_model = l_nota_ref;

            EXCEPTION
                WHEN no_data_found THEN
                    v_exists := 0;
        END;

        IF v_exists = 1 THEN 
            INSERT INTO ok_nfe_produto_model (
                "REF_NFE",
                "ID_PRODUTO",
                "DESCRICAO",
                "CFOP",
                "UNIDADE_COMERCIAL",
                "QUANTIDADE_COMERCIAL",
                "VALOR_UNITARIO_COMERCIAL",
                "VALOR_UNITARIO_TRIBUTAVEL",
                "UNIDADE_TRIBUTAVEL",
                "CODIGO_NCM",
                "QUANTIDADE_TRIBUTAVEL",
                "VALOR_BRUTO",
                "ICMS_SITUACAO_TRIBUTARIA",
                "ICMS_ORIGEM",
                "PIS_SITUACAO_TRIBUTARIA",
                "COFINS_SITUACAO_TRIBUTARIA" 
            ) VALUES (
                l_nota_ref, l_codigo_produto, l_descricao, l_cfop,
                l_unidade_comercial, l_quantidade_comercial, l_valor_unitario_comercial, 
                l_valor_unitario_tributavel, l_unidade_tributavel, l_codigo_ncm,
                l_quantidade_tributavel, l_valor_bruto, l_icms_situacao_tributaria, 
                l_icms_origem, l_pis_situacao_tributaria, l_cofins_situacao_tributaria
            ) RETURNING id_nfe_produto INTO v_id_model;

            DBMS_OUTPUT.PUT_LINE('Produto adicionada a nota: ' || l_nota_ref || '. Produto ID: ' || v_id_model);
        ELSE
            raise_application_error( -20001, 'Referência da Nota não encontrada. Certifique-se de ter criado a nota usando a função CREATE_NOTA_MODEL.' );
        END IF;

    end ADD_PRODUTO_NOTA;

    function CONSULTAR_NOTA(l_ref number) return varchar2 is
        l_res varchar2(4000);
    begin
        OK_PKG_FOCUS_BASE.INIT_DEFAULT_HEADER;

        l_res := apex_web_service.make_rest_request(
           p_url               => OK_PKG_FOCUS_BASE.GET_URL || '/nfe/' || l_ref,
           p_http_method       => 'GET'
        );

        RETURN l_res;
    end CONSULTAR_NOTA;

    procedure UPDATE_NOTA_MODEL(l_ref number) is
        l_res varchar2(4000);
        l_exists number := 0;

        ex_ref_not_found EXCEPTION;
        PRAGMA EXCEPTION_INIT( ex_ref_not_found, -4004 );
    begin
        BEGIN
            SELECT 1 INTO l_exists FROM ok_nfe_model WHERE id_nfe_model = l_ref;

            EXCEPTION
                WHEN no_data_found THEN
                    l_exists := 0;
        END;

        IF l_ref IS NOT NULL AND l_exists = 1 THEN
            l_res := CONSULTAR_NOTA(l_ref => l_ref);

            apex_json.parse(l_res);

            DECLARE
                v_codigo varchar2(200) := apex_json.get_varchar2(p_path => 'codigo');
                v_status varchar2(200) := apex_json.get_varchar2(p_path => 'status');
                v_mensagem_sefaz varchar2(4000) := apex_json.get_varchar2(p_path => 'mensagem_sefaz');
                v_status_sefaz number := to_number(apex_json.get_varchar2(p_path => 'status_sefaz'));
            BEGIN
                IF v_codigo IS NULL THEN
                    UPDATE_NOTA_STATUS(l_ref => l_ref, l_status => v_status);

                    UPDATE ok_nfe_model SET
                        mensagem_sefaz = v_mensagem_sefaz,
                        status_sefaz = v_status_sefaz
                    WHERE id_nfe_model = l_ref;

                    DBMS_OUTPUT.PUT_LINE('[NFE-Request] Nota Ref: ' ||  l_ref || ' está com Status: ' || v_status || '.');

                    IF v_status = 'autorizado' THEN
                        DECLARE 
                            v_caminho_xml varchar2(200) := apex_json.get_varchar2(p_path => 'caminho_xml_nota_fiscal');
                            v_caminho_danfe varchar2(200) := apex_json.get_varchar2(p_path => 'caminho_danfe');
                        BEGIN
                            UPDATE ok_nfe_model SET
                                caminho_xml_nota_fiscal = v_caminho_xml,
                                caminho_danfe = v_caminho_danfe
                            WHERE id_nfe_model = l_ref;

                            DBMS_OUTPUT.PUT_LINE('Atualizado para Status: ' || v_status || '.');
                        END;
                    ELSIF v_status = 'erro_autorizacao' THEN
                        DECLARE
                            v_erros_index number := apex_json.get_count(p_path => 'erros');
                            v_json varchar(4000);
                        BEGIN
                            apex_json.initialize_clob_output;
                            FOR i IN 1 .. v_erros_index
                            LOOP
                                apex_json.open_object;
                                apex_json.write('codigo', apex_json.get_varchar2('erros[%d].codigo', i));
                                apex_json.write('mensagem', apex_json.get_varchar2('erros[%d].mensagem', i));
                                apex_json.write('correcao', apex_json.get_varchar2('erros[%d].correcao', i));
                                apex_json.close_object;
                            END LOOP;

                            v_json := apex_json.get_clob_output;
                            apex_json.free_output;

                            UPDATE ok_nfe_model SET
                                json_errors = v_json
                            WHERE id_nfe_model = l_ref;
                        END;
                    END IF;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[NFE-Request] Nota Ref: ' ||  l_ref || ' Código: ' || v_codigo || '.');
                END IF;
            END;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error!');
            raise_application_error( -20001, 'Referência da Nota não encontrada. Certifique-se de ter criado a nota usando a função CREATE_NOTA_MODEL.' );
        END IF;

    end UPDATE_NOTA_MODEL;

    procedure JOB_UPDATE_NOTA is
    begin
        FOR cn IN (SELECT * FROM ok_nfe_model WHERE status = 'processando_autorizacao')
        LOOP
            UPDATE_NOTA_MODEL(cn.ID_NFE_MODEL);
        END LOOP;
    end JOB_UPDATE_NOTA;

    function EMITIR_NOTA_MODEL(l_ref number) return varchar2 is
        l_json clob;
        l_res varchar2(32767);
        l_menssage varchar2(4000);
        l_tag varchar2(200) := '[NFE-Request] ';

    begin
        DBMS_OUTPUT.PUT_LINE('Iniciando processo de emissão de notas..');

        apex_json.initialize_clob_output;
        FOR cn IN (
            SELECT * FROM OK_NFE_MODEL M
            INNER JOIN OK_NFE_PRODUTO_MODEL P ON P.ref_nfe = M.id_nfe_model
            WHERE M.status = 'modelo_envio' AND M.id_nfe_model = (CASE WHEN l_ref IS NOT NULL THEN l_ref ELSE P.ref_nfe END))
        LOOP
            DECLARE
                v_data_emissao varchar2(200) := TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'UTC', 'yyyy-mm-dd"T"hh24:mi:ss"Z"');
            BEGIN
                apex_json.open_object;
                apex_json.write('natureza_operacao', cn.NATUREZA_OPERACAO);
                apex_json.write('data_emissao', v_data_emissao);
                apex_json.write('data_entrada_saida', v_data_emissao);
                apex_json.write('tipo_documento', cn.TIPO_DOCUMENTO);
                apex_json.write('finalidade_emissao', cn.FINALIDADE_EMISSAO);
                apex_json.write('cnpj_emitente', cn.CNPJ_EMITENTE);
                apex_json.write('nome_emitente', cn.NOME_EMITENTE);
                apex_json.write('nome_fantasia_emitente', cn.NOME_FANTASIA_EMITENTE);
                apex_json.write('logradouro_emitente', cn.LOGRADOURO_EMITENTE);
                apex_json.write('numero_emitente', cn.NUMERO_EMITENTE);
                apex_json.write('bairro_emitente', cn.BAIRRO_EMITENTE);
                apex_json.write('uf_emitente', cn.UF_EMITENTE);
                apex_json.write('cep_emitente', cn.CEP_EMITENTE);
                apex_json.write('inscricao_estadual_emitente', cn.INSCRICAO_ESTADUAL_EMITENTE);
                apex_json.write('nome_destinatario', cn.NOME_DESTINATARIO);
                apex_json.write('cpf_destinatario', cn.CPF_DESTINATARIO);
                apex_json.write('telefone_destinatario', cn.TELEFONE_DESTINATARIO);
                apex_json.write('logradouro_destinatario', cn.LOGRADOURO_DESTINATARIO);
                apex_json.write('numero_destinatario', cn.NUMERO_DESTINATARIO);
                apex_json.write('bairro_destinatario', cn.BAIRRO_DESTINATARIO);
                apex_json.write('municipio_destinatario', cn.MUNICIPIO_DESTINATARIO);
                apex_json.write('uf_destinatario', cn.UF_DESTINATARIO);
                apex_json.write('pais_destinatario', cn.PAIS_DESTINATARIO);
                apex_json.write('cep_destinatario', cn.CEP_DESTINATARIO);
                apex_json.write('valor_frete', cn.VALOR_FRETE);
                apex_json.write('valor_seguro', cn.VALOR_SEGURO);
                apex_json.write('valor_total', cn.VALOR_TOTAL);
                apex_json.write('valor_produtos', cn.VALOR_PRODUTOS);
                apex_json.write('modalidade_frete', cn.MODALIDADE_FRETE);

                apex_json.open_array('items');
                DECLARE
                    p_count number := 0;

                BEGIN
                    FOR pd IN (SELECT * FROM ok_nfe_produto_model WHERE ref_nfe = cn.ID_NFE_MODEL)
                    LOOP
                        p_count := p_count + 1;
                        
                        apex_json.open_object;
                        apex_json.write('numero_item', p_count);
                        apex_json.write('codigo_produto', pd.ID_PRODUTO);
                        apex_json.write('descricao', pd.DESCRICAO);
                        apex_json.write('cfop', pd.CFOP);
                        apex_json.write('unidade_comercial', pd.UNIDADE_COMERCIAL);
                        apex_json.write('quantidade_comercial', pd.QUANTIDADE_COMERCIAL);
                        apex_json.write('valor_unitario_comercial', pd.VALOR_UNITARIO_COMERCIAL);
                        apex_json.write('valor_unitario_tributavel', pd.VALOR_UNITARIO_TRIBUTAVEL);
                        apex_json.write('unidade_tributavel', pd.UNIDADE_TRIBUTAVEL);
                        apex_json.write('codigo_ncm', pd.CODIGO_NCM);
                        apex_json.write('quantidade_tributavel', pd.QUANTIDADE_TRIBUTAVEL);
                        apex_json.write('valor_bruto', pd.VALOR_BRUTO);
                        apex_json.write('icms_situacao_tributaria', pd.ICMS_SITUACAO_TRIBUTARIA);
                        apex_json.write('icms_origem', pd.ICMS_ORIGEM);
                        apex_json.write('pis_situacao_tributaria', pd.PIS_SITUACAO_TRIBUTARIA);
                        apex_json.write('cofins_situacao_tributaria', pd.COFINS_SITUACAO_TRIBUTARIA);
                        apex_json.close_object;
                    END LOOP;
                END;
                apex_json.close_all;

                UPDATE ok_nfe_model SET
                   data_emissao = v_data_emissao,
                   data_entrada_saida = v_data_emissao
                WHERE id_nfe_model = cn.ID_NFE_MODEL;

                l_json := apex_json.get_clob_output;
                apex_json.free_output;
            END;

            OK_PKG_FOCUS_BASE.INIT_DEFAULT_HEADER;
            l_res := apex_web_service.make_rest_request(
               p_url               => OK_PKG_FOCUS_BASE.GET_URL || '/nfe?ref=' || cn.ID_NFE_MODEL,
               p_http_method       => 'POST',
               p_body              => l_json
            );

            apex_json.parse(l_res);

            declare
                v_status varchar2(4000) := apex_json.get_varchar2(p_path => 'status');
            begin
                UPDATE_NOTA_STATUS(
                    l_ref => cn.ID_NFE_MODEL,
                    l_status => v_status
                );

                l_menssage := l_menssage || l_tag || ' ref: ' || cn.ID_NFE_MODEL || ' ok. ' || v_status;
            
            exception
                when no_data_found then
                    l_menssage := l_menssage || l_tag || ' ref: ' || cn.ID_NFE_MODEL || ' bad. No data found';
            end;

        END LOOP;

        RETURN l_menssage;
    end EMITIR_NOTA_MODEL;

end OK_PKG_FOCUS_API_NFE;

