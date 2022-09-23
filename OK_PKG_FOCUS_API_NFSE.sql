create or replace package OK_PKG_FOCUS_API_NFSE as
    function EMITIR_NOTA_MODEL(l_ref number) return varchar2;

    procedure UPDATE_NOTA_MODEL(l_ref number);

    function CONSULTAR_NOTA(l_ref number) return varchar2;

    procedure JOB_UPDATE_NOTA;
    
    function INIT_NFSE return number;

    procedure CREATE_PRESTADOR_MODEL(
        l_ref number,
        l_cnpj varchar2,
        l_inscricao_municipal varchar2,
        l_codigo_municipio varchar2
    );

    procedure CREATE_TOMADOR_MODEL(
        l_ref number,
        l_cnpj varchar2,
        l_razao_social varchar2,
        l_email varchar2,
        l_endereco_logradouro varchar2,
        l_endereco_numero number,
        l_endereco_complemento varchar2,
        l_endereco_bairro varchar2,
        l_endereco_codigo_municipio varchar2,
        l_endereco_uf varchar2,
        l_endereco_cep varchar2
    );

    procedure CREATE_SERVICO_MODEL(
        l_ref number,
        l_aliquota number,
        l_discriminacao varchar2,
        l_iss_retido number,
        l_item_lista_servico varchar2,
        l_codigo_tributario_municipio varchar2,
        l_valor_servicos float
    );
    
end OK_PKG_FOCUS_API_NFSE;

create or replace package body OK_PKG_FOCUS_API_NFSE as
    --
    v_notamodel clob;
    --

    procedure UPDATE_NOTA_STATUS(
        l_ref number,
        l_status varchar2
    ) is
    begin
        UPDATE ok_nfse_model SET
            status = l_status
        WHERE id_nfse_model = l_ref;

        DBMS_OUTPUT.PUT_LINE('Updated Status NFSE-' || l_ref);

    end UPDATE_NOTA_STATUS;

    function INIT_NFSE return number is
        v_ref number;
    begin
        INSERT INTO ok_nfse_model(
           STATUS,
           OBJ_KEY
        ) VALUES (
            'modelo_envio', 'X'
        ) RETURNING id_nfse_model INTO v_ref;

        DBMS_OUTPUT.PUT_LINE('Modelo de Nota criado com sucesso. Referência: ' || v_ref || '.');

        RETURN v_ref;
    end INIT_NFSE;

    procedure CREATE_PRESTADOR_MODEL(
        l_ref number,
        l_cnpj varchar2,
        l_inscricao_municipal varchar2,
        l_codigo_municipio varchar2
    ) is
        v_exists number := 0;

        ex_ref_not_found EXCEPTION;
        PRAGMA EXCEPTION_INIT( ex_ref_not_found, -20001 );
    begin
        BEGIN
            SELECT 1 INTO v_exists FROM ok_nfse_model WHERE id_nfse_model = l_ref;
            EXCEPTION
                WHEN no_data_found THEN
                    v_exists := 0;
        END;

        IF v_exists = 1 THEN
            UPDATE ok_nfse_model SET
               PRESTADOR_CNPJ =  l_cnpj,
               PRESTADOR_INSCRICAO_MUNICIPAL = l_inscricao_municipal,
               PRESTADOR_CODIGO_MUNICIPIO = l_codigo_municipio
            WHERE id_nfse_model = l_ref;

            UPDATE ok_nfse_model SET
                OBJ_KEY = OBJ_KEY || 'X'
            WHERE id_nfse_model = l_ref AND length(OBJ_KEY) <= 4;
        ELSE
           raise_application_error( -20001, 'Referência da Nota não encontrada. Certifique-se de ter criado a nota usando a função INIT_NFSE.' ); 
        END IF;
    end CREATE_PRESTADOR_MODEL;

    procedure CREATE_TOMADOR_MODEL(
        l_ref number,
        l_cnpj varchar2,
        l_razao_social varchar2,
        l_email varchar2,
        l_endereco_logradouro varchar2,
        l_endereco_numero number,
        l_endereco_complemento varchar2,
        l_endereco_bairro varchar2,
        l_endereco_codigo_municipio varchar2,
        l_endereco_uf varchar2,
        l_endereco_cep varchar2
    ) is
        v_exists number := 0;

        ex_ref_not_found EXCEPTION;
        PRAGMA EXCEPTION_INIT( ex_ref_not_found, -20001 );
    begin
        BEGIN
            SELECT 1 INTO v_exists FROM ok_nfse_model WHERE id_nfse_model = l_ref;
            EXCEPTION
                WHEN no_data_found THEN
                    v_exists := 0;
        END;

        IF v_exists = 1 THEN
            UPDATE ok_nfse_model SET
                TOMADOR_CNPJ = l_cnpj,
                TOMADOR_RAZAO_SOCIAL = l_razao_social,
                TOMADOR_EMAIL = l_email,
                TOMADOR_ENDERECO_LOGRADOURO = l_endereco_logradouro,
                TOMADOR_ENDRECO_NUMERO = l_endereco_numero,
                TOMADOR_ENDERECO_COMPLEMENTO = l_endereco_complemento,
                TOMADOR_ENDERECO_BAIRRO = l_endereco_bairro,
                TOMADOR_ENDERECO_CODIGO_MUNICIPIO = l_endereco_codigo_municipio,
                TOMADOR_ENDERECO_UF = l_endereco_uf,
                TOMADOR_ENDERECO_CEP = l_endereco_cep
            WHERE id_nfse_model = l_ref;

            UPDATE ok_nfse_model SET
                OBJ_KEY = OBJ_KEY || 'X'
            WHERE id_nfse_model = l_ref AND length(OBJ_KEY) <= 4;
            
        ELSE
           raise_application_error( -20001, 'Referência da Nota não encontrada. Certifique-se de ter criado a nota usando a função INIT_NFSE.' ); 
        END IF;
    end;

    procedure CREATE_SERVICO_MODEL(
        l_ref number,
        l_aliquota number,
        l_discriminacao varchar2,
        l_iss_retido number,
        l_item_lista_servico varchar2,
        l_codigo_tributario_municipio varchar2,
        l_valor_servicos float
    ) is
        v_exists number := 0;

        ex_ref_not_found EXCEPTION;
        PRAGMA EXCEPTION_INIT( ex_ref_not_found, -20001 );
    begin
        BEGIN
            SELECT 1 INTO v_exists FROM ok_nfse_model WHERE id_nfse_model = l_ref;
            EXCEPTION
                WHEN no_data_found THEN
                    v_exists := 0;
        END;

        IF v_exists = 1 THEN
            UPDATE ok_nfse_model SET
                SERVICO_ALIQUOTA = l_aliquota,
                SERVICO_DISCRIMINACAO = l_discriminacao,
                SERVICO_ISS_RETIDO = l_iss_retido,
                SERVICO_ITEM_LISTA_SERVICO = l_item_lista_servico,
                SERVICO_CODIGO_TRIGUTARIO_MUNICIPIO = l_codigo_tributario_municipio,
                VALOR_SERVICOS = l_valor_servicos
            WHERE id_nfse_model = l_ref;

            UPDATE ok_nfse_model SET
                OBJ_KEY = OBJ_KEY || 'X'
            WHERE id_nfse_model = l_ref AND length(OBJ_KEY) <= 4;
        ELSE
           raise_application_error( -20001, 'Referência da Nota não encontrada. Certifique-se de ter criado a nota usando a função INIT_NFSE.' ); 
        END IF;
    end;

    function CONSULTAR_NOTA(l_ref number) return varchar2 is
        l_res varchar2(4000);
    begin
        OK_PKG_FOCUS_BASE.INIT_DEFAULT_HEADER;

        l_res := apex_web_service.make_rest_request(
           p_url               => OK_PKG_FOCUS_BASE.GET_URL || '/nfse/' || l_ref,
           p_http_method       => 'GET'
        );

        RETURN l_res;
    end CONSULTAR_NOTA;

    procedure UPDATE_NOTA_MODEL(l_ref number) is
        l_res varchar2(4000);
        l_exists number := 0;

        ex_ref_not_found EXCEPTION;
        PRAGMA EXCEPTION_INIT( ex_ref_not_found, -20001 );
    begin
        BEGIN
            SELECT 1 INTO l_exists FROM ok_nfse_model WHERE id_nfse_model = l_ref;

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
            BEGIN
                IF v_codigo IS NULL THEN
                    UPDATE_NOTA_STATUS(l_ref => l_ref, l_status => v_status);

                    DBMS_OUTPUT.PUT_LINE('[NFSE-Request] Nota Ref: ' ||  l_ref || ' está com Status: ' || v_status || '.');

                    IF v_status = 'autorizado' THEN
                        DBMS_OUTPUT.PUT_LINE(l_res);

                        DECLARE 
                            v_caminho_xml varchar2(200) := apex_json.get_varchar2(p_path => 'caminho_xml_nota_fiscal');
                            v_caminho_danfse varchar2(200) := apex_json.get_varchar2(p_path => 'caminho_danfe');
                            v_url_danfse varchar2(200) := apex_json.get_varchar2(p_path => 'url_danfse');
                            v_url varchar2(200) := apex_json.get_varchar2(p_path => 'url');
                        BEGIN
                            UPDATE ok_nfse_model SET
                                caminho_xml_nota_fiscal = v_caminho_xml,
                                caminho_danfse = v_caminho_danfse,
                                url_danfse = v_url_danfse,
                                url = v_url
                            WHERE id_nfse_model = l_ref;
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

                            UPDATE ok_nfse_model SET
                                json_errors = v_json
                            WHERE id_nfse_model = l_ref;
                        END;
                    END IF;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[NFSE-Request] Nota Ref: ' ||  l_ref || ' Código: ' || v_codigo || '.');
                END IF;
            END;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error!');
            raise_application_error( -20001, 'Referência da Nota não encontrada. Certifique-se de ter criado a nota usando a função INIT_NFSE.' );
        END IF;

    end UPDATE_NOTA_MODEL;

    procedure JOB_UPDATE_NOTA is
    begin
        FOR cn IN (SELECT * FROM ok_nfse_model WHERE status = 'processando_autorizacao')
        LOOP
            UPDATE_NOTA_MODEL(cn.ID_NFSE_MODEL);
        END LOOP;
    end JOB_UPDATE_NOTA;

    function EMITIR_NOTA_MODEL(l_ref number) return varchar2 is
        l_json clob;
        l_res varchar2(32767);
        l_menssage varchar2(4000);
        l_tag varchar2(200) := '[NFSE-Request] ';

        ex_data_not_found EXCEPTION;
        ex_invalid_note EXCEPTION;
        PRAGMA EXCEPTION_INIT( ex_data_not_found, -20001 );
        PRAGMA EXCEPTION_INIT( ex_invalid_note, -20002 );
    begin
        DBMS_OUTPUT.PUT_LINE('Iniciando processo de emissão de notas..');

        apex_json.initialize_clob_output;
        FOR cn IN (
            SELECT * FROM ok_nfse_model M
            WHERE M.status = 'modelo_envio' AND M.id_nfse_model = (CASE WHEN l_ref IS NOT NULL THEN l_ref ELSE M.id_nfse_model END))
        LOOP
            IF length(cn.OBJ_KEY) >= 4 THEN
                DECLARE
                    v_data_emissao varchar2(200) := TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'UTC', 'yyyy-mm-dd"T"hh24:mi:ss"Z"');
                BEGIN
                    apex_json.open_object;
                    apex_json.write('data_emissao', v_data_emissao);
                    apex_json.open_object('prestador');
                    apex_json.write('cnpj', cn.PRESTADOR_CNPJ);
                    apex_json.write('inscricao_municipal', cn.PRESTADOR_INSCRICAO_MUNICIPAL);
                    apex_json.write('codigo_municipio', cn.PRESTADOR_CODIGO_MUNICIPIO);
                    apex_json.close_object;
                    
                    apex_json.open_object('tomador');
                    apex_json.write('cnpj', cn.TOMADOR_CNPJ);
                    apex_json.write('razao_social', cn.TOMADOR_RAZAO_SOCIAL);
                    apex_json.write('email', cn.TOMADOR_EMAIL);
                    apex_json.open_object('endereco');
                    apex_json.write('logradouro', cn.TOMADOR_ENDERECO_LOGRADOURO);
                    apex_json.write('numero', cn.TOMADOR_ENDRECO_NUMERO);
                    apex_json.write('complemento', cn.TOMADOR_ENDERECO_COMPLEMENTO);
                    apex_json.write('bairro', cn.TOMADOR_ENDERECO_BAIRRO);
                    apex_json.write('codigo_municipio', cn.TOMADOR_ENDERECO_CODIGO_MUNICIPIO);
                    apex_json.write('uf', cn.TOMADOR_ENDERECO_UF);
                    apex_json.write('cep', cn.TOMADOR_ENDERECO_CEP);
                    apex_json.close_object;
                    apex_json.close_object;

                    apex_json.open_object('servico');
                    apex_json.write('aliquota', cn.SERVICO_ALIQUOTA);
                    apex_json.write('discriminacao', cn.SERVICO_DISCRIMINACAO);
                    apex_json.write('iss_retido', (CASE WHEN cn.SERVICO_ISS_RETIDO = 1 THEN 'true' ELSE 'false' END));
                    apex_json.write('item_lista_servico', cn.SERVICO_ITEM_LISTA_SERVICO);
                    apex_json.write('codigo_tributario_municipio', cn.SERVICO_CODIGO_TRIGUTARIO_MUNICIPIO);
                    apex_json.write('valor_servicos', cn.VALOR_SERVICOS);
                    apex_json.close_object;

                    apex_json.close_all;

                    UPDATE ok_nfse_model SET
                       data_emissao = v_data_emissao
                    WHERE id_nfse_model = cn.ID_NFSE_MODEL;

                    l_json := apex_json.get_clob_output;
                    apex_json.free_output;
                END;

                OK_PKG_FOCUS_BASE.INIT_DEFAULT_HEADER;
                l_res := apex_web_service.make_rest_request(
                   p_url               => OK_PKG_FOCUS_BASE.GET_URL || '/nfse?ref=' || cn.ID_NFSE_MODEL,
                   p_http_method       => 'POST',
                   p_body              => l_json
                );

                apex_json.parse(l_res);

                declare
                    v_status varchar2(4000) := apex_json.get_varchar2(p_path => 'status');
                begin
                    UPDATE_NOTA_STATUS(
                        l_ref => cn.ID_NFSE_MODEL,
                        l_status => v_status
                    );

                    l_menssage := l_menssage || l_tag || ' ref: ' || cn.ID_NFSE_MODEL || ' ok. ' || v_status;
                
                exception
                    when no_data_found then
                        l_menssage := l_menssage || l_tag || ' ref: ' || cn.ID_NFSE_MODEL || ' bad. No data found';
                end;
            ELSE
                raise_application_error( -20002, 'Modelo de Nota inválido. Certifique-se de ter adicionado Tomador, Prestador e o Serviço.' );
            END IF;
        END LOOP;

        RETURN l_menssage;
    end EMITIR_NOTA_MODEL;

end OK_PKG_FOCUS_API_NFSE;
