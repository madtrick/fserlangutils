-module(fserlangutils_httpc).

-export([json/3]).

-define(CONTENT_TYPE, "content-type").
-define(CONTENT_TYPE_JSON, "application/json").
-define(CONTENT_TYPE_TRANSFER_ENC_SEPARATOR, ";").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
json(Method, Url, Body) ->
  case http_query(Url, Body, Method, [], [], []) of
    {ok, Result} ->
      {StatusLine, Headers, ResponseBody} = Result,
      %
      % NOTE: the code below is commented because
      % I'm not sure about how to handle JSON returned
      % with a content-type header that's not application/json
      %
      %case extract_header(Headers, ?CONTENT_TYPE) of
      %  undefined -> {raw, StatusLine, Headers, ResponseBody};
      %  {_HeaderName, HeaderValue} ->
          %case content_type_in_header(HeaderValue, ?CONTENT_TYPE_JSON) of
          %  false -> {raw, StatusLine, Headers, ResponseBody};
          %  true ->
              case fserlangutils_json:from(ResponseBody) of
                {error, _} -> {invalid_json, StatusLine, Headers, ResponseBody};
                JSON -> {json, StatusLine, Headers, JSON}
              end;
          %end
      %end;
    {error, Error} -> {error, Error}
  end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HELPERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
http_query(Url, Body, Method, Headers, HTTPOptions, Options) ->
  JSONBody    = fserlangutils_json:to(fserlangutils_json:to_json_structure(Body)),
  Request     = {Url, Headers, ?CONTENT_TYPE_JSON, JSONBody},
  MergedOptions     = lists:merge(Options, [{body_format, binary}]),
  httpc:request(Method, Request, HTTPOptions, MergedOptions).

extract_header(Headers, Header) ->
  % According to documentation (option 'header_as_is')
  % httpc will send the headers lowercase. I assume that
  % when reading the response from the server httpc will
  % convert all headers to lowercase too.
  %
  lists:keyfind(Header, 1, Headers).

content_type_in_header(Header, ContentType) ->
  [MediaType, _TransferEnc] = string:tokens(Header, ?CONTENT_TYPE_TRANSFER_ENC_SEPARATOR),
  ContentType == MediaType.

