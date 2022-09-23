create or replace package OK_PKG_FOCUS_BASE as

    function GET_URL return varchar2;
    procedure INIT_DEFAULT_HEADER;
    
end OK_PKG_FOCUS_BASE;

create or replace package body OK_PKG_FOCUS_BASE as
    l_endpoint_h varchar2(200) := 'FOCUS_ENDPOINT';
    l_x_auth_token varchar2(200) := 'FOCUS_USER_TOKEN';
    l_api_version varchar2(10) := 'FOCUS_API_VERSION';

    function to_base64(t in varchar2) return varchar2 is
    begin
        return utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(t)));
    end to_base64;

    function GET_URL return varchar2 is url varchar2(200);
    begin
        url := l_endpoint_h || '/' || l_api_version;
        return url;
    end GET_URL;

    procedure INIT_DEFAULT_HEADER is
    begin
        apex_web_service.set_request_headers (
            p_name_01   =>      'Authorization',
            p_value_01  =>      'Basic ' || to_base64(l_x_auth_token)
        );

    end INIT_DEFAULT_HEADER;

end OK_PKG_FOCUS_BASE;

