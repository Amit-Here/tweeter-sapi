%dw 2.0
output text/plain
import dw::Crypto
import toBinary from dw::core::Numbers
import withMaxSize from dw::core::Strings
import toBase64 from dw::core::Binaries
import encodeURIComponent from dw::core::URL
import remove from dw::core::Strings
 
var consumer_key= attributes.headers.Consumer_Key 
var consumer_secret= attributes.headers.Consumer_Secret
var access_token = attributes.headers.Access_Token 
var token_secret= attributes.headers.Token_Secret 
var signature_method= "HMAC-SHA256"
var version="1.0"
var oauth_consumer_key = consumer_key
var oauth_nonce = toBase64(toBinary(randomInt(99999999999))) withMaxSize 12
var oauth_timestamp = now() as Number
var oauth_signature_method = signature_method
var oauth_token = access_token
var oauth_version = version
var oauth_token_secret = token_secret
 
var parameter_string =  'oauth_consumer_key=' ++ oauth_consumer_key ++ '&oauth_nonce=' ++ oauth_nonce ++ '&oauth_signature_method=' ++ oauth_signature_method ++ '&oauth_timestamp=' ++ oauth_timestamp ++ '&oauth_token=' ++ oauth_token ++ '&oauth_version=' ++ oauth_version
var signature_base_string = vars.httpMethod ++ '&' ++ encodeURIComponent(vars.baseUrl)  ++ '&' ++ encodeURIComponent(parameter_string)
var signing_key = consumer_secret ++ "&" ++ oauth_token_secret
var signature = toBase64(Crypto::HMACBinary(signing_key as Binary, signature_base_string as Binary, "HmacSHA256"))
var oauth_signature=encodeURIComponent(signature)
---
'Oauth oauth_consumer_key="' ++ oauth_consumer_key ++
'",oauth_token="' ++ oauth_token ++
'",oauth_signature_method="' ++ oauth_signature_method ++
'",oauth_timestamp="' ++ oauth_timestamp ++
'",oauth_nonce="' ++ oauth_nonce ++  
'",oauth_version="' ++ oauth_version ++
'",oauth_signature="' ++ oauth_signature ++ '"'